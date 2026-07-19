//
//  ColumnDragApp.swift
//  ColumnDrag
//
//  Created by Klajd Deda on 12/9/22.
//

import SwiftUI
import IDDSwiftUI
import Log4swift
import Logging

@main
struct ColumnDragApp: App {
    init() {
        let logRootURL = URL.home.appendingPathComponent("Library/Logs/ColumnDrag")
        Log4swift.configure(fileLogConfig: try? .init(logRootURL: logRootURL, appPrefix: "ColumnDrag", appSuffix: "", daysToKeep: 30))

        Log4swift[""].info("")
        Log4swift[""].info("\(String(repeating: "-", count: Bundle.main.appVersion.shortDescription.count))")
        Log4swift[""].info("\(Bundle.main.appVersion.shortDescription)")
    }

    var body: some Scene {
        WindowGroup {
            ColumnDragContainer()
        }
    }
}
