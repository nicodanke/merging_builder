import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:lazy_evaluation/lazy_evaluation.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart' show Generator, LibraryReader;

import '../errors/builder_error.dart';
import 'formatter.dart';
import 'synthetic_input.dart';
import 'synthetic_builder.dart';

/// Builder that uses synthetic input and
/// creates one output file for each input file.
///
/// Input files must be specified using [Glob] syntax.
/// The output path must be specified.
///
/// The type parameter [S] represents the synthetic input used by the builder.
/// Valid types are [$Lib$] and [$Package$], both extending [SyntheticInput].
class StandaloneBuilder<S extends SyntheticInput> extends SyntheticBuilder<S> {
  /// Constructs a [StandAloneBuilder] object.
  ///
  /// - [inputFiles] defaults to: `'lib/*.dart'`.
  ///
  /// - [outputFiles] defaults to: `'lib/standalone_(*).dart'`.
  ///
  /// - [generator] is required.
  ///
  /// - [header] defaults to: `''`
  ///
  /// - [footer] defaults to : `''`
  ///
  /// - [formatOutput] defaults to: `DartFormatter().format`.
  StandaloneBuilder({
    String inputFiles = 'lib/*.dart',
    this.outputFiles = 'lib/standalone_(*).dart',
    @required this.generator,
    String header = '',
    String footer = '',
    Formatter formatOutput,
    String root = '',
  })  : root = root.trim(),
        super(
            inputFiles: inputFiles,
            header: header,
            footer: footer,
            formatOutput: formatOutput) {
    _resolvedOutputFiles = Lazy(_outputFileNames);
  }

  /// Path to output files.
  /// The symbol `(*)` will be replaced with the corresponding input file name
  /// (omitting the extension).
  ///
  /// Example: `lib/standalone_(*).dart`
  final String outputFiles;

  /// Instance of [Generator].
  final Generator generator;

  /// Lazily computes the output file names by replacing the
  /// placeholder `(*)` in [outputFiles] with the input file basename.
  Lazy<List<String>> _resolvedOutputFiles;

  /// The root directory of the package the build is applied to.
  /// This variable does not need to be set if the build command is initiated
  /// from the root directory of the package.
  final String root;

  /// Returns the output file name.
  String get outputPath => path.basename(outputFiles);

  /// Returns the output directory name.
  String get outputDirectory => path.dirname(outputFiles);

  /// Returns a list of output file paths.
  List<String> _outputFileNames() {
    final List<String> result = [];
    SyntheticInput.validatePath<S>(inputFiles);
    SyntheticInput.validatePath<S>(outputFiles);
    final resolvedInputFiles = Glob(inputFiles);
    for (final inputEntity in resolvedInputFiles.listSync(root: root)) {
      final basename = path.basenameWithoutExtension(inputEntity.path);
      String outputFileName = outputFiles.replaceAll(
        RegExp(r'\(\*\)'),
        basename,
      );
      // Check if output clashes with input files.
      if (path.equals(outputFileName, inputEntity.path)) {
        throw BuilderError(
            message: 'Output file clashes with input file!',
            expectedState: 'Output files must not overwrite input files. '
                'Check the [StandaloneBuilder] constructor argument [outputFiles].',
            invalidState: 'Output: $outputFileName is also an input file.');
      }
      result.add(outputFileName);
    }
    return result;
  }

  /// Returns a map of type `<String, List<String>>`
  /// with content {synthetic input: list of output files}.
  ///
  /// The builder uses the synthetic input specified by the
  /// type parameter [S extends SyntheticInput].
  @override
  Map<String, List<String>> get buildExtensions => {
        syntheticInput.value: _resolvedOutputFiles.value,
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final List<AssetId> libAssetIds = await libraryAssetIds(buildStep);
    // Accessing libraries.
    for (final libAssetId in libAssetIds ?? []) {
      final library = LibraryReader(
        await buildStep.resolver.libraryFor(libAssetId),
      );
      // Calling generator.generate.
      log.fine('Running ${generator.runtimeType} on: ${libAssetId.path}.');

      // Create output file name.
      await buildStep.writeAsString(
        AssetId(
          buildStep.inputId.package,
          _outputFile(libAssetId),
        ),
        arrangeContent(await generator.generate(library, buildStep),
            generatedBy: 'Generated by ${generator.runtimeType}. '),
      );
    }
  }

  /// Returns path of the output file for a given input file [assetId].
  String _outputFile(AssetId assetId) {
    final String basename = path.basenameWithoutExtension(assetId.path);
    return outputFiles.replaceAll(RegExp(r'\(\*\)'), basename);
  }
}
