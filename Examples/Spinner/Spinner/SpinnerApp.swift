//
//  SpinnerApp.swift
//  Spinner
//
//  Created by Klajd Deda on 12/9/22.
//

import SwiftUI
import Log4swift

@main
struct SpinnerApp: App {
    init() {
        let logRootURL = URL.home.appendingPathComponent("Library/Logs/Spinner")
        Log4swift.configure(fileLogConfig: try? .init(logRootURL: logRootURL, appPrefix: "Spinner", appSuffix: "", daysToKeep: 30))

        Log4swift[""].info("")
        Log4swift[""].info("\(String(repeating: "-", count: Bundle.main.appVersion.shortDescription.count))")
        Log4swift[""].info("\(Bundle.main.appVersion.shortDescription)")

        Log4swift[Self.self].info("starting ...")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
