import Danger
import Foundation

public struct XcodeStaticAnalyzer {
    internal static let danger = Danger()
    internal static let shellExecutor = ShellExecutor()

    /// This is the main entry point for running the hstatic analyzer in PRs
    /// using Danger-Swift. call this function anywhere from within your
    /// Dangerfile.swift. Specify xcodebuild arguments, e.g. ["-workspace",
    /// "MyProject.xcworkspace", "-scheme", "MyScheme"]. This function will
    /// automatically include the analyze,  CLANG_ANALYZER_OUTPUT,
    /// and CLANG_ANALYZER_OUTPUT_DIR arguments
    @discardableResult
    public static func analyze(arguments: [String],
                               reportAllFiles: Bool = false) -> XcodeStaticAnalyzerResult {
        return self.analyze(
            danger: danger,
            shellExecutor: shellExecutor,
            arguments: arguments,
            reportAllFiles: reportAllFiles
        )
    }
}

/// This extension is for internal workings of the plugin. It is marked as internal for unit testing.
internal extension XcodeStaticAnalyzer {
    static func analyze(
        danger: DangerDSL,
        shellExecutor: ShellExecutor,
        arguments: [String],
        reportAllFiles: Bool = false) -> XcodeStaticAnalyzerResult {

        // Clear a directory for storing the output from the static analyzer.
        let outputDirectory: String
        if #available(macOS 10.12, *) {
            outputDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("clang").path
        } else {
            outputDirectory = NSTemporaryDirectory().appending("/clang")
        }

        // Clear out the directory, if applicable.
        print("output directory: \(outputDirectory)")
        if FileManager.default.fileExists(atPath: outputDirectory) {
            do {
                try FileManager.default.removeItem(atPath: outputDirectory)
            } catch {
                print(error)
            }
        }

        // Amend the input arguments with the ones required in this context.
        let arguments = arguments + [
            "analyze",
            "CLANG_ANALYZER_OUTPUT=plist",
            "CLANG_ANALYZER_OUTPUT_DIR=\"\(outputDirectory)\"",
        ]

        // Execute the static analyzer
        let buildResult = shellExecutor.executeUnpiped("xcodebuild", arguments: arguments)

        let files = danger.git.createdFiles + danger.git.modifiedFiles
        print(files)

        let analyzerViolations = FileManager.default
            .enumerator(atPath: outputDirectory)?
            .allObjects
            .map({ URL(fileURLWithPath: outputDirectory).appendingPathComponent($0 as! String) })
            .filter({ $0.pathExtension == "plist" })
            .flatMap({ (url) -> [XcodeStaticAnalyzerViolation] in

                guard let data = try? Data(contentsOf: url) else {
                    print("Unable to generate Data from contents of: \(url)")
                    return []
                }

                let decoder = PropertyListDecoder()

                guard let plist = try? decoder.decode(XcodeStaticAnalyzerPlist.self, from: data) else {
                    print("Unable to decode plist from contents of: \(url)")
                    return []
                }

                return plist.violations()
            })
            .filter({ reportAllFiles || files.contains($0.location.file) }) ?? []

        analyzerViolations.forEach({ (violation) in
            print("\(violation.location.file)")
            warn(message: violation.description, file: violation.location.file, line: violation.location.line)
        })

        // Clean up.
        if FileManager.default.fileExists(atPath: outputDirectory) {
            do {
                try FileManager.default.removeItem(atPath: outputDirectory)
            } catch {
                print(error)
            }
        }

        return XcodeStaticAnalyzerResult(violations: analyzerViolations, result: buildResult)
    }

}
internal extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
