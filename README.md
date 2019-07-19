
# Danger Xcode Static Analyzer

[Danger Swift](https://github.com/danger/danger-swift) plugin for Xcode Static Analzyer. So you can get analyzer warnings on your pull requests!

## Usage

[Install and run](https://github.com/danger/danger-swift#ci-configuration) Danger Swift as normal.

```yaml
dependencies:
  override:
  - npm install -g danger # This installs Danger
  - brew install danger/tap/danger-swift # This installs Danger-Swift
```

Then use the following `Dangerfile.swift`.

```swift
// Dangerfile.swift

import Danger
import DangerXcodeStaticAnalyzer // package: https://github.com/hteytan/DangerXcodeStaticAnalyzer.git

XcodeStaticAnalyzer.analyze(arguments: [...])
```

That will run the static analzyer and report warnings inline for created and modified files. Violations that are out of the diff will show in danger's fail or warn section.

### Report all files

By default, only the warnings from files that were added or modified are reported; however, you can use the `reportAllFiles` option to report warnings from all files.

```swift
XcodeStaticAnalyzer.analyze(arguments: [...], reportAllFiles=true)
```

# License

[#MIT4Lyfe](LICENSE)

# Attributions

Thank you, [ashfurrow](https://github.com/ashfurrow/danger-swiftlint).
