#!/usr/bin/env swift
//
// Regenerates Conventions/Conventions/cache/<slug>Stands.json from the live API, without
// building or running the app. Mirrors StandsRefresher.swift's refresh()/save() flow:
// fetch https://api.sf-f.org.il/booths/<slug>.json, keep only the "booths" array (StandsParser
// discards the rest of the response wrapper), and write it back out as a bare JSON array, which
// is exactly what StandsRefresher.save() persists via JSONEncoder().encode(stands).
//
// Usage: swift scripts/refresh_stands_cache.swift <slug>
//

import Foundation

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(("Error: " + message + "\n").data(using: .utf8)!)
    exit(1)
}

guard CommandLine.arguments.count == 2 else {
    fail("Usage: swift \(CommandLine.arguments[0]) <slug>")
}
let slug = CommandLine.arguments[1]

let scriptURL = URL(fileURLWithPath: CommandLine.arguments[0])
let repoRoot = scriptURL.deletingLastPathComponent().deletingLastPathComponent()
let outputURL = repoRoot.appendingPathComponent("Conventions/Conventions/cache/\(slug)Stands.json")

guard let standsURL = URL(string: "https://api.sf-f.org.il/booths/\(slug).json") else {
    fail("Invalid stands URL for slug '\(slug)'")
}

print("Fetching \(standsURL)...")

var responseData: Data?
var responseError: Error?
let semaphore = DispatchSemaphore(value: 0)
URLSession.shared.dataTask(with: standsURL) { data, response, error in
    responseData = data
    responseError = error
    semaphore.signal()
}.resume()
semaphore.wait()

if let responseError = responseError {
    fail("Request failed: \(responseError)")
}
guard let data = responseData else {
    fail("No data returned from stands API")
}

guard let root = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
    fail("Failed to deserialize stands response as a JSON object")
}
guard let booths = root["booths"] else {
    fail("Stands response is missing the \"booths\" key")
}

guard JSONSerialization.isValidJSONObject(booths) else {
    fail("\"booths\" value is not serializable back to JSON")
}
let output = try! JSONSerialization.data(withJSONObject: booths, options: [.prettyPrinted])

try! FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
try output.write(to: outputURL, options: [.atomic])

let count = (booths as? [Any])?.count ?? 0
print("Wrote \(count) stands to \(outputURL.path)")
