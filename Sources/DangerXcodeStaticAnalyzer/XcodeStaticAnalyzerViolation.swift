struct XcodeStaticAnalyzerViolation: Codable {
    let description: String
    let location: Location

    struct Location: Codable {
        let line: Int
        let column: Int
        let file: String
    }
}
