//
//  BodyCount.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 7/17/26.
//  Copyright (C) 1997-2026 id-design, inc. All rights reserved.
//

import Foundation
import SwiftUI
import Log4swift
import os.signpost

/**
 Re-usable to investigate SwiftUI performance.

 In Instruments add the "os_signpost" instrument.
 Filter by subsystem = Bundle.main.bundleIdentifier and category = "viewLifeCycle".
 Each interval is named "body"; the message shows which view fired and how many times.
 */
public enum BodyCount {
    private static let countByBodyName = UnfairLock(initialState: [String: Int]())
    // When you run Instruments add the "os_signpost" instrument,
    // then filter by subsystem and category "viewLifeCycle".
    //
    public static let viewLifeCycle = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "com.id-design.idd-swiftui",
        category: "viewLifeCycle"
    )

    /**
     true only when running under instruments
     */
    public static let isEnabled: Bool = {
        let env = ProcessInfo.processInfo.environment
        let looksProfiled =
        env["XPC_SERVICE_NAME"]?.contains("Instruments") ?? false
        || env["__CFBundleIdentifier"]?.contains("Instruments") ?? false
        
        /// -IDDSwiftUI.BodyCount D
        /// to see where these are defined
        if Log4swift[Self.self].isDebug {
            env.keys.forEach { key in
                let value = env[key] ?? ""
                Log4swift[Self.self].dash("\(key): \(value)")
                Log4swift[Self.self].info("\(key): \(value)")
            }
        }
        return looksProfiled
    }()

    public static func tick(_ name: String) {
        countByBodyName.withLock {
            $0[name, default: 0] += 1
        }
    }

    public static func report() {
        countByBodyName.withLock { inner in
            inner
                .sorted(by: { $0.value > $1.value })
                .forEach({ element in
                    print("\(element.value)\t\(element.key)")
                })
            inner.removeAll()
        }
    }
}

extension BodyCount {
    @inline(never)
    /**
     Will add events so we can profile some rowdy view bodies.

     The interval name is the literal "body" so that Instruments can resolve it.
     The actual view name and invocation count appear in the message column.
     */
    public static func timed<V: View>(_ name: StaticString, @ViewBuilder _ build: () -> V) -> V {
        guard isEnabled
        else {
            // ya too old to play with this
            return build()
        }

        if #available(macOS 12.0, *) {
            let name_ = name.description
            let tick = countByBodyName.withLock {
                $0[name_, default: 0] += 1
                return $0[name_] ?? 0
            }
            let signpostID = OSSignpostID(log: BodyCount.viewLifeCycle)
            // "body" is a compile-time literal so Instruments resolves the interval name correctly.
            // The actual view name goes in the message.
            os_signpost(.begin, log: BodyCount.viewLifeCycle, name: "body", signpostID: signpostID, "%{public}@", name_)
            defer {
                os_signpost(.end, log: BodyCount.viewLifeCycle, name: "body", signpostID: signpostID, "%{public}@ #%d", name_, tick)
            }
            return build()
        }
        // ya too old to play with this
        return build()
    }
}
