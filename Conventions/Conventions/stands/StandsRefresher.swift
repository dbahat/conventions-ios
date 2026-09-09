//
//  StandsRefresher.swift
//  Conventions
//
//  Created by David Bahat on 9/5/26.
//  Copyright © 2026 Amai. All rights reserved.
//

import Foundation

class StandsRefresher {
    private static let apiUrl = URL(string: "https://api.sf-f.org.il/booths/booths.json")!

    private static let fileName = Convention.name + "Stands.json";
    private static let cacheFile = NSHomeDirectory() + "/Library/Caches/" + fileName;

    private let parser = StandsParser()
    private var stands: Array<Stand> = [];

    init() {
        guard let resourcePath = Bundle.main.resourcePath else { return };

        if let cachedStands = try? Data(contentsOf: URL(fileURLWithPath: StandsRefresher.cacheFile)) {
            if let parsedCachedStands = parser.parseCached(data: cachedStands) {
                stands = parsedCachedStands
                print("Cached stands: ", stands.count)
            }
        } else if let preInstalledStands = try? Data(contentsOf: URL(fileURLWithPath: resourcePath + "/" + StandsRefresher.fileName)) {
            if let parsedPreInstalledStands = parser.parseCached(data: preInstalledStands) {
                stands = parsedPreInstalledStands
                print("Preinstalled stands: ", stands.count)
            }
        }
    }

    func getAll() -> Array<Stand> {
        return stands;
    }

    func refresh(_ callback: ((_ success: Bool) -> Void)?) {
        let request = URLRequest(url: StandsRefresher.apiUrl, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in

            guard let data = data, let parsedStands = self.parser.parse(data: data) else {
                DispatchQueue.main.async {
                    callback?(false);
                }
                return;
            }

            // Using main thread for syncronizing access to stands
            DispatchQueue.main.async {
                self.stands = parsedStands;
                print("Downloaded stands: ", self.stands.count);
                callback?(true);

                // Persist the updated stands in a background thread, so as not to block the UI
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    self.save()
                }
            }
        }).resume()
    }

    private func save() {
        guard let serializedData = try? JSONEncoder().encode(stands) else { return }
        try? serializedData.write(to: URL(fileURLWithPath: StandsRefresher.cacheFile), options: [.atomic])
    }
}
