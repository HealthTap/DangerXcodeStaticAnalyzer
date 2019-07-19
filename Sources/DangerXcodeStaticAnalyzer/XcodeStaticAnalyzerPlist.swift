import Foundation

struct XcodeAnalyzerPlist: Codable {
    let diagnostics: [Diagnostic]
    let files: [String]

    struct Diagnostic: Codable {
        let description: String
        let location: Location

        struct Location: Codable {
            let line: Int
            let column: Int
            let file: Int

            enum CodingKeys: String, CodingKey {
                case line
                case column = "col"
                case file
            }
        }
    }

    func violations() -> [XcodeStaticAnalyzerViolation] {
        return diagnostics.map { (diagnostic) -> XcodeStaticAnalyzerViolation in

            let file = files[diagnostic.location.file]
                .deletingPrefix(FileManager.default.currentDirectoryPath)
                .deletingPrefix("/")

            return XcodeStaticAnalyzerViolation(
                description: diagnostic.description,
                location: XcodeAnalyzerViolation.Location(
                    line: diagnostic.location.line,
                    column: diagnostic.location.column,
                    file: file
                )
            )
        }
    }
}
