#!/usr/bin/env swift
//
// Regenerates Conventions/Conventions/cache/<slug>Events.json from the live API, without
// building or running the app.
//
// This is a standalone re-implementation of SffEventsParser.parse(data:) + ConventionEvent.toJson()
// (see Conventions/Conventions/model/SffEventsParser.swift / ConventionEvent.swift). It has to be a
// separate implementation rather than reusing those files directly because they import
// UIKit/FirebaseMessaging/FirebaseAnalytics, which aren't available to a plain `swift` script. If the
// parsing rules in SffEventsParser/ConventionEvent ever change, this script needs a matching update.
//
// Note: ConventionEvent.toJson() only ever serializes the resolved hall's *name*, never its display
// order, so unlike the app (which resolves hall names against Convention.swift's hardcoded `halls`
// list to assign a stable display order), this script can just pass the raw API's "location" string
// straight through as "hall" - the app resolves it against the halls list again when it loads this
// cache file at runtime.
//
// Usage: swift scripts/refresh_events_cache.swift <slug>
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
let outputURL = repoRoot.appendingPathComponent("Conventions/Conventions/cache/\(slug)Events.json")

// MARK: - HTTP helper

func fetch(_ url: URL) -> (data: Data?, response: HTTPURLResponse?) {
    var resultData: Data?
    var resultResponse: HTTPURLResponse?
    var resultError: Error?
    let semaphore = DispatchSemaphore(value: 0)
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
    URLSession.shared.dataTask(with: request) { data, response, error in
        resultData = data
        resultResponse = response as? HTTPURLResponse
        resultError = error
        semaphore.signal()
    }.resume()
    semaphore.wait()
    if let resultError = resultError {
        fail("Request to \(url) failed: \(resultError)")
    }
    return (resultData, resultResponse)
}

// MARK: - HTML entity decoding
// Ported verbatim from Conventions/Conventions/externals/HtmlDecode/HTMLdecode.swift
// (taken from https://gitlab.com/snippets/32429 / https://gist.github.com/mwaterfall/25b4a6a06dc3309d9555)

private let characterEntities: [String: Character] = [
    "&quot;": "\"", "&amp;": "&", "&apos;": "'", "&lt;": "<", "&gt;": ">",
    "&nbsp;": "\u{00A0}", "&iexcl;": "\u{00A1}", "&cent;": "\u{00A2}", "&pound;": "\u{00A3}",
    "&curren;": "\u{00A4}", "&yen;": "\u{00A5}", "&brvbar;": "\u{00A6}", "&sect;": "\u{00A7}",
    "&uml;": "\u{00A8}", "&copy;": "\u{00A9}", "&ordf;": "\u{00AA}", "&laquo;": "\u{00AB}",
    "&not;": "\u{00AC}", "&shy;": "\u{00AD}", "&reg;": "\u{00AE}", "&macr;": "\u{00AF}",
    "&deg;": "\u{00B0}", "&plusmn;": "\u{00B1}", "&sup2;": "\u{00B2}", "&sup3;": "\u{00B3}",
    "&acute;": "\u{00B4}", "&micro;": "\u{00B5}", "&para;": "\u{00B6}", "&middot;": "\u{00B7}",
    "&cedil;": "\u{00B8}", "&sup1;": "\u{00B9}", "&ordm;": "\u{00BA}", "&raquo;": "\u{00BB}",
    "&frac14;": "\u{00BC}", "&frac12;": "\u{00BD}", "&frac34;": "\u{00BE}", "&iquest;": "\u{00BF}",
    "&Agrave;": "\u{00C0}", "&Aacute;": "\u{00C1}", "&Acirc;": "\u{00C2}", "&Atilde;": "\u{00C3}",
    "&Auml;": "\u{00C4}", "&Aring;": "\u{00C5}", "&AElig;": "\u{00C6}", "&Ccedil;": "\u{00C7}",
    "&Egrave;": "\u{00C8}", "&Eacute;": "\u{00C9}", "&Ecirc;": "\u{00CA}", "&Euml;": "\u{00CB}",
    "&Igrave;": "\u{00CC}", "&Iacute;": "\u{00CD}", "&Icirc;": "\u{00CE}", "&Iuml;": "\u{00CF}",
    "&ETH;": "\u{00D0}", "&Ntilde;": "\u{00D1}", "&Ograve;": "\u{00D2}", "&Oacute;": "\u{00D3}",
    "&Ocirc;": "\u{00D4}", "&Otilde;": "\u{00D5}", "&Ouml;": "\u{00D6}", "&times;": "\u{00D7}",
    "&Oslash;": "\u{00D8}", "&Ugrave;": "\u{00D9}", "&Uacute;": "\u{00DA}", "&Ucirc;": "\u{00DB}",
    "&Uuml;": "\u{00DC}", "&Yacute;": "\u{00DD}", "&THORN;": "\u{00DE}", "&szlig;": "\u{00DF}",
    "&agrave;": "\u{00E0}", "&aacute;": "\u{00E1}", "&acirc;": "\u{00E2}", "&atilde;": "\u{00E3}",
    "&auml;": "\u{00E4}", "&aring;": "\u{00E5}", "&aelig;": "\u{00E6}", "&ccedil;": "\u{00E7}",
    "&egrave;": "\u{00E8}", "&eacute;": "\u{00E9}", "&ecirc;": "\u{00EA}", "&euml;": "\u{00EB}",
    "&igrave;": "\u{00EC}", "&iacute;": "\u{00ED}", "&icirc;": "\u{00EE}", "&iuml;": "\u{00EF}",
    "&eth;": "\u{00F0}", "&ntilde;": "\u{00F1}", "&ograve;": "\u{00F2}", "&oacute;": "\u{00F3}",
    "&ocirc;": "\u{00F4}", "&otilde;": "\u{00F5}", "&ouml;": "\u{00F6}", "&divide;": "\u{00F7}",
    "&oslash;": "\u{00F8}", "&ugrave;": "\u{00F9}", "&uacute;": "\u{00FA}", "&ucirc;": "\u{00FB}",
    "&uuml;": "\u{00FC}", "&yacute;": "\u{00FD}", "&thorn;": "\u{00FE}", "&yuml;": "\u{00FF}",
    "&OElig;": "\u{0152}", "&oelig;": "\u{0153}", "&Scaron;": "\u{0160}", "&scaron;": "\u{0161}",
    "&Yuml;": "\u{0178}", "&fnof;": "\u{0192}", "&circ;": "\u{02C6}", "&tilde;": "\u{02DC}",
    "&Alpha;": "\u{0391}", "&Beta;": "\u{0392}", "&Gamma;": "\u{0393}", "&Delta;": "\u{0394}",
    "&Epsilon;": "\u{0395}", "&Zeta;": "\u{0396}", "&Eta;": "\u{0397}", "&Theta;": "\u{0398}",
    "&Iota;": "\u{0399}", "&Kappa;": "\u{039A}", "&Lambda;": "\u{039B}", "&Mu;": "\u{039C}",
    "&Nu;": "\u{039D}", "&Xi;": "\u{039E}", "&Omicron;": "\u{039F}", "&Pi;": "\u{03A0}",
    "&Rho;": "\u{03A1}", "&Sigma;": "\u{03A3}", "&Tau;": "\u{03A4}", "&Upsilon;": "\u{03A5}",
    "&Phi;": "\u{03A6}", "&Chi;": "\u{03A7}", "&Psi;": "\u{03A8}", "&Omega;": "\u{03A9}",
    "&alpha;": "\u{03B1}", "&beta;": "\u{03B2}", "&gamma;": "\u{03B3}", "&delta;": "\u{03B4}",
    "&epsilon;": "\u{03B5}", "&zeta;": "\u{03B6}", "&eta;": "\u{03B7}", "&theta;": "\u{03B8}",
    "&iota;": "\u{03B9}", "&kappa;": "\u{03BA}", "&lambda;": "\u{03BB}", "&mu;": "\u{03BC}",
    "&nu;": "\u{03BD}", "&xi;": "\u{03BE}", "&omicron;": "\u{03BF}", "&pi;": "\u{03C0}",
    "&rho;": "\u{03C1}", "&sigmaf;": "\u{03C2}", "&sigma;": "\u{03C3}", "&tau;": "\u{03C4}",
    "&upsilon;": "\u{03C5}", "&phi;": "\u{03C6}", "&chi;": "\u{03C7}", "&psi;": "\u{03C8}",
    "&omega;": "\u{03C9}", "&thetasym;": "\u{03D1}", "&upsih;": "\u{03D2}", "&piv;": "\u{03D6}",
    "&ensp;": "\u{2002}", "&emsp;": "\u{2003}", "&thinsp;": "\u{2009}", "&zwnj;": "\u{200C}",
    "&zwj;": "\u{200D}", "&lrm;": "\u{200E}", "&rlm;": "\u{200F}", "&ndash;": "\u{2013}",
    "&mdash;": "\u{2014}", "&lsquo;": "\u{2018}", "&rsquo;": "\u{2019}", "&sbquo;": "\u{201A}",
    "&ldquo;": "\u{201C}", "&rdquo;": "\u{201D}", "&bdquo;": "\u{201E}", "&dagger;": "\u{2020}",
    "&Dagger;": "\u{2021}", "&bull;": "\u{2022}", "&hellip;": "\u{2026}", "&permil;": "\u{2030}",
    "&prime;": "\u{2032}", "&Prime;": "\u{2033}", "&lsaquo;": "\u{2039}", "&rsaquo;": "\u{203A}",
    "&oline;": "\u{203E}", "&frasl;": "\u{2044}", "&euro;": "\u{20AC}", "&image;": "\u{2111}",
    "&weierp;": "\u{2118}", "&real;": "\u{211C}", "&trade;": "\u{2122}", "&alefsym;": "\u{2135}",
    "&larr;": "\u{2190}", "&uarr;": "\u{2191}", "&rarr;": "\u{2192}", "&darr;": "\u{2193}",
    "&harr;": "\u{2194}", "&crarr;": "\u{21B5}", "&lArr;": "\u{21D0}", "&uArr;": "\u{21D1}",
    "&rArr;": "\u{21D2}", "&dArr;": "\u{21D3}", "&hArr;": "\u{21D4}", "&forall;": "\u{2200}",
    "&part;": "\u{2202}", "&exist;": "\u{2203}", "&empty;": "\u{2205}", "&nabla;": "\u{2207}",
    "&isin;": "\u{2208}", "&notin;": "\u{2209}", "&ni;": "\u{220B}", "&prod;": "\u{220F}",
    "&sum;": "\u{2211}", "&minus;": "\u{2212}", "&lowast;": "\u{2217}", "&radic;": "\u{221A}",
    "&prop;": "\u{221D}", "&infin;": "\u{221E}", "&ang;": "\u{2220}", "&and;": "\u{2227}",
    "&or;": "\u{2228}", "&cap;": "\u{2229}", "&cup;": "\u{222A}", "&int;": "\u{222B}",
    "&there4;": "\u{2234}", "&sim;": "\u{223C}", "&cong;": "\u{2245}", "&asymp;": "\u{2248}",
    "&ne;": "\u{2260}", "&equiv;": "\u{2261}", "&le;": "\u{2264}", "&ge;": "\u{2265}",
    "&sub;": "\u{2282}", "&sup;": "\u{2283}", "&nsub;": "\u{2284}", "&sube;": "\u{2286}",
    "&supe;": "\u{2287}", "&oplus;": "\u{2295}", "&otimes;": "\u{2297}", "&perp;": "\u{22A5}",
    "&sdot;": "\u{22C5}", "&lceil;": "\u{2308}", "&rceil;": "\u{2309}", "&lfloor;": "\u{230A}",
    "&rfloor;": "\u{230B}", "&lang;": "\u{2329}", "&rang;": "\u{232A}", "&loz;": "\u{25CA}",
    "&spades;": "\u{2660}", "&clubs;": "\u{2663}", "&hearts;": "\u{2665}", "&diams;": "\u{2666}",
]

extension String {
    var stringByDecodingHTMLEntities: String {
        func decodeNumeric(_ string: String, base: Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                  let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }

        func decode(_ entity: String) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 3)..<entity.index(entity.endIndex, offsetBy: -1)]), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(String(entity[entity.index(entity.startIndex, offsetBy: 2)..<entity.index(entity.endIndex, offsetBy: -1)]), base: 10)
            } else {
                return characterEntities[entity]
            }
        }

        var result = ""
        var position = startIndex
        while let ampRange = self.range(of: "&", range: position..<endIndex) {
            result.append(String(self[position..<ampRange.lowerBound]))
            position = ampRange.lowerBound
            if let semiRange = self.range(of: ";", range: position..<endIndex) {
                let entity = String(self[position..<semiRange.upperBound])
                position = semiRange.upperBound
                if let decoded = decode(entity) {
                    result.append(decoded)
                } else {
                    result.append(entity)
                }
            } else {
                break
            }
        }
        result.append(String(self[position..<endIndex]))
        return result
    }

    // Ported from Conventions/Conventions/model/AmaiEventsParser.swift
    func replace(pattern: String, withTemplate template: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return self
        }
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: template)
    }
}

// Ported from SffEventsParser.parseEventDescription
func parseEventDescription(_ description: String) -> String {
    return description
        .replace(pattern: "<img", withTemplate: "<ximg")
        .replace(pattern: "/img>", withTemplate: "/ximg>")
        .replace(pattern: "<iframe", withTemplate: "<xiframe")
        .replace(pattern: "iframe>", withTemplate: "xiframe>")
}

// Ported from SffEventsParser.parsePresentation
func parsePresentation(_ event: [String: Any]) -> (mode: String, location: String) {
    guard
        let hasPhysical = event["has_physical"] as? Bool,
        let hasVirtual = event["has_virtual"] as? Bool,
        let isInhouse = event["is_inhouse"] as? Bool
    else {
        return ("Physical", "Indoors")
    }
    let mode = (hasPhysical && hasVirtual) ? "Hybrid" : (hasVirtual ? "Virtual" : "Physical")
    let location = isInhouse ? "Indoors" : "Virtual"
    return (mode, location)
}

let eventDateFormatter = DateFormatter()
eventDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
eventDateFormatter.timeZone = TimeZone(identifier: "GMT")
eventDateFormatter.locale = Locale(identifier: "en_US")

let lastModifiedFormatter = DateFormatter()
lastModifiedFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
lastModifiedFormatter.timeZone = TimeZone(identifier: "GMT")
lastModifiedFormatter.locale = Locale(identifier: "en_US")

// MARK: - Fetch events list

guard let eventsURL = URL(string: "https://api.sf-f.org.il/program/list_events.php?slug=\(slug)") else {
    fail("Invalid events URL for slug '\(slug)'")
}
print("Fetching \(eventsURL)...")
let (eventsData, _) = fetch(eventsURL)
guard let eventsData = eventsData else {
    fail("No data returned from events API")
}

// MARK: - Fetch available-tickets last-modified (same second call Events.refresh() makes)

guard let lastModifiedURL = URL(string: "https://api.sf-f.org.il/program/cache_get_last_updated.php?which=available_tickets&slug=\(slug)") else {
    fail("Invalid last-modified URL for slug '\(slug)'")
}
print("Fetching \(lastModifiedURL)...")
let (_, lastModifiedResponse) = fetch(lastModifiedURL)
guard let lastModifiedResponse = lastModifiedResponse, lastModifiedResponse.statusCode == 200 else {
    fail("Failed to fetch available-tickets last-modified (bad HTTP status)")
}
guard let lastModifiedString = lastModifiedResponse.allHeaderFields["Last-Modified"] as? String else {
    fail("available-tickets response is missing the Last-Modified header")
}
guard let availableTicketsLastModified = lastModifiedFormatter.date(from: lastModifiedString) else {
    fail("Could not parse Last-Modified header: '\(lastModifiedString)'")
}

// MARK: - Parse events (port of SffEventsParser.parse(data:))

guard let rawEvents = (try? JSONSerialization.jsonObject(with: eventsData, options: [])) as? [[String: Any]] else {
    fail("Failed to deserialize events list JSON as an array of objects")
}

var results: [String: [String: Any]] = [:]
var skippedCount = 0

for event in rawEvents {
    guard let id = event["id"] as? String else {
        print("Got event without ID. Skipping")
        skippedCount += 1
        continue
    }
    guard let type = event["track"] as? String else {
        print("Got event without type. Skipping. ID=\(id)")
        skippedCount += 1
        continue
    }
    guard let title = event["title"] as? String else {
        print("Event missing title. Skipping. ID=\(id)")
        skippedCount += 1
        continue
    }
    guard let description = event["description"] as? String else {
        print("Event missing description. Skipping. ID=\(id)")
        skippedCount += 1
        continue
    }
    guard let startTimeString = (event["time"] as? [String: Any])?["start"] as? String else {
        print("Event missing startTime. Skipping. ID=\(id)")
        skippedCount += 1
        continue
    }
    guard let endTimeString = (event["time"] as? [String: Any])?["end"] as? String else {
        print("Event missing endTime. Skipping. ID=\(id)")
        skippedCount += 1
        continue
    }
    guard let hallName = event["location"] as? String else {
        print("Event missing location. Skipping. ID=\(id) name=\(title)")
        skippedCount += 1
        continue
    }
    guard let url = event["url"] as? String else {
        print("Event missing url. Skipping. ID=\(id) name=\(title)")
        skippedCount += 1
        continue
    }
    guard let startTime = eventDateFormatter.date(from: startTimeString) else {
        fail("Event \(id) has an unparseable startTime '\(startTimeString)'")
    }
    guard let endTime = eventDateFormatter.date(from: endTimeString) else {
        fail("Event \(id) has an unparseable endTime '\(endTimeString)'")
    }

    let (presentationMode, presentationLocation) = parsePresentation(event)

    var eventPrice = 0
    if let priceString = event["price"] as? String, let intPrice = Int(priceString) {
        eventPrice = intPrice
    }

    var speaker = ""
    if let speakers = event["speakers"] as? [Any], !speakers.isEmpty {
        speaker = speakers.map { "\($0)" }.joined(separator: ",")
    }

    var json: [String: Any] = [
        "id": id,
        "serverId": Int(id) ?? 0,
        "title": title.stringByDecodingHTMLEntities,
        "lecturer": speaker.stringByDecodingHTMLEntities,
        "startTime": startTime.timeIntervalSince1970,
        "endTime": endTime.timeIntervalSince1970,
        "type": type,
        "hall": hallName,
        "description": parseEventDescription(description),
        "category": (event["categories"] as? [Any])?.first as? String ?? "",
        "price": eventPrice,
        "tags": Array(Set((event["tags"] as? [String]) ?? [])),
        "url": url,
        "availableTickets": NSNull(),
        "availableTicketsLastModified": availableTicketsLastModified.timeIntervalSince1970,
        "presentationMode": presentationMode,
        "presentationLocation": presentationLocation,
        "virtualUrl": "",
        "isTicketless": false,
        "isOngoing": false,
    ]

    if let availableTicketsString = event["available_tickets"] as? String, let availableTickets = Int(availableTicketsString) {
        json["availableTickets"] = availableTickets
    }
    if let virtualUrl = event["virtual_url"] as? String {
        json["virtualUrl"] = virtualUrl
    }
    if let isTicketless = event["is_ticketless"] as? Bool {
        json["isTicketless"] = isTicketless
    }
    if let isOngoing = event["is_ongoing"] as? Bool {
        json["isOngoing"] = isOngoing
    }

    // Matches SffEventsParser's dedup-by-id behavior (last one wins)
    results[id] = json
}

let parsedEvents = Array(results.values)
guard JSONSerialization.isValidJSONObject(parsedEvents) else {
    fail("Parsed events are not serializable back to JSON")
}
let output = try! JSONSerialization.data(withJSONObject: parsedEvents, options: [.prettyPrinted])

try! FileManager.default.createDirectory(at: outputURL.deletingLastPathComponent(), withIntermediateDirectories: true)
try output.write(to: outputURL, options: [.atomic])

print("Wrote \(parsedEvents.count) events to \(outputURL.path) (\(skippedCount) skipped)")
