//
//  Application.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 6/9/18.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

#if os(macOS)

import Cocoa

public extension NSApplication {
    static let AppearanceDidChange = NSNotification.Name("NSApplication_AppearanceDidChange")
    private static var _observer: NSKeyValueObservation?
    private static var _isDarkMode: Bool?

    var currentOptionEvent: NSEvent? {
        if let currentEvent = NSApp.currentEvent {
            if currentEvent.modifierFlags.contains(.option) {
                return currentEvent
            }
        }
        return nil
    }
    
    var isOptionKey: Bool {
        return currentOptionEvent != nil
    }

    var currentShiftEvent: NSEvent? {
        if let currentEvent = NSApp.currentEvent {
            if currentEvent.modifierFlags.contains(.shift) {
                return currentEvent
            }
        }
        return nil
    }
}

#endif
