public struct XcodeStaticAnalyzerViolation: Codable {
    public let description: String
    public let location: Location

    public struct Location: Codable {
        public let line: Int
        public let column: Int
        public let file: String
    }
}
