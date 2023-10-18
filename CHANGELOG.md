## 0.2.6 - 2023-10-18
### Chore
- Updated dependencies.

## 0.2.5 - 2023-10-18
### Added
- Updated examples and docs.
- Moved example folder to repository: [merging_builder_example](https://github.com/simphotonics/merging_builder_example)

## 0.2.4 - 2023-10-18
### Added
- Updated dependencies.

## 0.2.3 - 2023-10-18
### Added
- Updated dependencies.
- Removed `test` directory from `example/researcher`.
  Reason: `BuildStep` is now a sealed class and may not be extended or implemented.

## 0.2.2 - 2023-10-18
### Added
- Migrated CI to github.

## 0.2.1 - 2023-10-18
### Added
- Expanded Dart docs.

## 0.2.0 - 2023-10-18
### Added
- Migrated to null-safety.

## 0.1.6 - 2023-10-18
### Added
- Renamed classes `LibDir` and `PackageDir` to `LibDir` and `PackageDir`.

## 0.1.5 - 2023-10-18
### Added
- Added abstract class [`SyntheticBuilder`][SyntheticBuilder].

## 0.1.4 - 2023-10-18
### Added
- Package now uses `quote_builder` as dev_dependency.

## 0.1.3 - 2023-10-18
### Added
- Applied pedantic lint suggestions. Removed builder getters: `outputDirectory` and `outputPath`.

## 0.1.2 - 2023-10-18
### Added
- Amended docs.

## 0.1.1 - 2023-10-18
### Added
- Amended docs.

## 0.1.0 - 2023-10-18
### Added
- Added classes `SyntheticBuilder` and `StandaloneBuilder`.

## 0.0.9 - 2023-10-18
### Added
- Extended example `researcher_builder`. The builder `addNamesBuilder` now handles `BuilderOptions` specified in the `build.yaml` file of the package consuming the config settings, `researcher`.

## 0.0.8 - 2023-10-18
### Added
- Amended docs and hyperlinks. Changed `MergingBuilder` log message type from `log.info` to `log.fine`.

## 0.0.7 - 2023-10-18
### Added
- Changed `MergingBuilder` log message type from `log.fine` to `log.info`.


## 0.0.6 - 2023-10-18
### Added
- Updated to latest version of `directed_graph`.

## 0.0.5 - 2023-10-18
### Added
- Changed format of README.md hyperlinks.

## 0.0.4 - 2023-10-18
### Added
- Amended typo in README.md.

## 0.0.3 - 2023-10-18
### Added
- Amended docs.

## 0.0.2 - 2023-10-18
### Added
- Amended docs, renamed builder method `combinedStream` to `combineStreams`.
- Renamed generator method `mergedContent` to `generateMergedContent`.

## 0.0.1 - 2023-10-18
### Added
- Initial version of the library.
- [SyntheticBuilder]: https://pub.dev/documentation/merging_builder/latest/merging_builder/SyntheticBuilder-class.html