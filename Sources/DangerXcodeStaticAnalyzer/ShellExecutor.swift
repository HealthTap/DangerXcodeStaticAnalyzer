import Foundation

internal class ShellExecutor {
    func executeUnpiped(_ command: String, arguments: [String] = []) {
        let script = "\(command) \(arguments.joined(separator: " "))"
        print("Executing \(script)")

        var env = ProcessInfo.processInfo.environment
        let task = Process()
        task.launchPath = env["SHELL"]
        task.arguments = ["-l", "-c", script]
        task.currentDirectoryPath = FileManager.default.currentDirectoryPath

        task.launch()
        task.waitUntilExit()
    }
}
