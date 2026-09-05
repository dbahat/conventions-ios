# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

This is the iOS app for **Olamot** ("עולמות" / "Worlds"), an annual Israeli science-fiction and fantasy convention (also branded ICON in some years), run by SF&F (sf-f.org.il). It's a UIKit app (storyboards + xibs, no SwiftUI) written in Swift, targeting iOS 15+. The app is reused/rebranded from year to year for each edition of the convention — most yearly updates touch `Convention.swift`, `Assets.xcassets`, and the discounts/HTML content rather than core logic.

The Xcode project lives in `Conventions/` (open `Conventions/Conventions.xcworkspace`, not the `.xcodeproj`, since CocoaPods is used).

## Build & dependencies

- Dependency manager: CocoaPods. After cloning or changing `Conventions/Podfile`, run `pod install` from `Conventions/`.
- Always open `Conventions/Conventions.xcworkspace` in Xcode (the workspace, not `Conventions.xcodeproj`).
- Build/run via Xcode with the `Conventions` scheme, or from the CLI:
  ```
  xcodebuild -workspace Conventions/Conventions.xcworkspace -scheme Conventions -configuration Debug build
  ```
- There is no test target in this project (no `*Tests` scheme/target exists) — there is nothing to run with `xcodebuild test`.
- Key third-party pods: `AppAuth` (OAuth login for ticket import), `GoogleMaps`, `FirebaseCore`/`FirebaseCrashlytics`/`FirebaseAnalytics`/`FirebaseMessaging` (push notifications), `UICollectionViewRightAlignedLayout` (RTL support).

## Architecture

**Convention-centric singleton model.** `model/Convention.swift` (`Convention.instance`) is the root object for all convention-specific state: dates, display name, hall list (with display order), feedback survey definitions (Google Forms), and owns the `Events`, `Updates`, `SecondHand`, and `UserInputs` singletons. Almost everything else in the app reads from `Convention.instance`. When a new yearly edition of the app is prepared, this file (name/slug/dates/halls/forms) is the primary place that changes.

**Data flow for events:**
- `model/Events.swift` fetches the event list from `https://api.sf-f.org.il/program/list_events.php` and parses it via `SffEventsParser` (the parser actually in use). `model/AmaiEventsParser.swift` is a legacy/unused parser kept from an earlier backend — don't assume it's live.
- Fetched events are cached to disk (`Library/Caches/1_<slug>Events.json`) and fall back to a bundled pre-installed snapshot (`Conventions/cache/<slug>Events.json`) when no cache/network is available yet, so the app has content on first launch before any network call completes.
- `model/ConventionEvent.swift` is the parsed event model; `model/Hall.swift` represents a venue/hall (ordering matters for UI display — see `Convention.swift`'s hall list, which is manually ordered to match the physical programme).

**User state is file-based, not Core Data/UserDefaults for most of it.** `model/UserInputs.swift` persists per-event user data (favorites, feedback answers) and overall convention feedback as JSON files under the app's `Documents` directory, keyed by `Convention.name`. `secondhand/SecondHand.swift` and `notifications/NotificationSettings.swift` follow similar simple JSON/UserDefaults persistence patterns.

**Ticket import / auth.** `model/UserTicketsRetriever.swift` implements OAuth (via `AppAuth`/`OIDAuthState`) against the ticketing backend to import a user's purchased tickets; the auth session is threaded through `AppDelegate.currentAuthorizationFlow` since the OAuth redirect comes back through `application(_:open:options:)`. Note there is also a near-empty stub `events/UserTicketsRetriever.swift` left over from a refactor — the real implementation is `model/UserTicketsRetriever.swift`.

**UI structure.** `TabBarViewController` hosts the main tabs (Home, Events, My Events/Favorites, Map, More Info), built from `Base.lproj/Main.storyboard`. Feature areas are organized into folders that mix storyboard-driven `UIViewController`s with `.xib`-backed custom views: `events/`, `feedback/`, `home/` (different home content views are swapped in depending on convention phase — before/during/after, with/without favorites, see `home/ConventionHomeContentViewProtocol.swift`), `secondhand/`, `updates/`, `notifications/`, `controllers/` (map, about, discounts, arrival methods, generic web content). Static content pages (About, Accessibility, Arrival Methods, Kids) are plain HTML files under `htmls/` loaded into a web view via `controllers/WebContentViewControllers.swift`.

**RTL / Hebrew-first.** The UI text and convention content are primarily Hebrew (RTL). The app forces left-to-right *layout* (`AppDelegate`) while text itself renders RTL, for consistent pre-iOS9-style layout — don't "fix" this without understanding why.

**Localization/strings.** No `.strings`/`.xcstrings` catalog is used for UI copy — Hebrew strings are hardcoded directly in Swift/storyboards/xibs (this is a single-language Hebrew app).

**Push notifications & local scheduling.** `notifications/NotificationsSchedualer.swift` schedules local notifications (event-about-to-start reminders, feedback reminders) client-side; `AppDelegate` handles both local and remote (Firebase Messaging) notification delivery/routing, including deep-linking into the relevant `EventViewController` or feedback screen.

**External integrations:** Google Maps SDK (map view + venue floor plans as static images under `Assets.xcassets/Map`), Firebase (Crashlytics/Analytics/Messaging), Google Forms (feedback submission — see `model/SurveyForm.swift` and the hardcoded form entry IDs in `Convention.swift`), AppAuth (ticket login).

## Bi-annual convention switch

This single app (one bundle ID `SF-F.Conventions`, one Firebase project) is re-skinned and re-released roughly twice a year, alternating between the **Olamot** and **Icon** conventions (e.g. Olamot 2026 in April, Icon in the following autumn). Each switch is a content/theme reskin, not a feature change. Based on past switches (see commits like `dd991ad`, `55f6e44`, `558d8f2`, `d568103`, `0d6684f`, `b167ea1`, `8c9aea4`, `8ae6b51`), the recurring task list is:

1. **`model/Convention.swift`** — `date`/`endDate`, `name` (e.g. `icon2026`), `slug`, `displayName`, the `halls` array (Icon and Olamot use different venues/hall layouts and ordering), and the feedback form URLs/`questionToFormEntry` maps if a new Google Form is used.
2. **`Info.plist`** — `CFBundleDisplayName`.
3. **Bundled events cache** — add `cache/<newSlug>Events.json`, remove the old one; must be added/removed as an actual **Xcode resource reference** in `project.pbxproj` (drag into Xcode), not just changed on disk. No other code changes needed — `Events.swift`, `UserTicketsRetriever.swift`, `MyEventsViewController.swift`'s UserDefaults keys, and `NotificationsSchedualer` are already parameterized by `Convention.name`/`slug`.
4. **Theme & assets** — `Colors.swift` (full palette swap to new `iconYYYY_*`/`olamotYYYY_*` constants) and `Assets.xcassets` (`AppIcon`, `AppBackground`, `AboutLogo`, `Home/*`, `Map/*`, `Discounts/*`, `Activities/*`) — swap in the new year's images, remove the old year's.
5. **Static content** — `htmls/AboutContent.html`, `AccessabilityContent.html`, `ArrivalMethodsContent.html` — full text rewrite per edition. Proofread after find/replace (a past switch left a dropped space: "לחגוג **אתפסטיבל** אייקון").
6. **`controllers/DiscountsViewController.swift`** — hardcoded sponsor/discount `Item(...)` list, rewritten each edition.
7. **`controllers/MoreInfoViewController.swift`** — menu item labels (e.g. "אודות הכנס" vs "אודות הפסטיבל"), and this is also where a feature gets temporarily commented out (e.g. the map, when that edition's map art isn't ready yet).
8. **Housekeeping** — make sure `extentions/NSDateExtentions.swift`'s `Date.now()` isn't left pointing at a hardcoded testing date; bump `MARKETING_VERSION`/`CURRENT_PROJECT_VERSION` in `project.pbxproj`.
9. **Cleanup** — prune the previous edition's now-unused imagesets instead of just adding new ones (stale assets accumulate across editions, e.g. a misspelled duplicate `Assets.xcassets/Activies` folder still carries old `icon2025_activities_*` images).
