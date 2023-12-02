//
//  NSColor.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 6/3/19.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

#if os(macOS)

import Cocoa

public extension NSColor {
    /**
     Poor attempt at coloring ...
     */
    static var windowBackground: NSColor {
        let light = NSColor.init(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        let dark = NSColor.init(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)

        return .init(light: light, dark: dark)
    }

    static var magicBlue: NSColor {
        // magic blue for now
        //
        .init(red: 0.0/255.0, green: 154.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }

    /**
     https://www.jessesquires.com/blog/2023/07/11/creating-dynamic-colors-in-swiftui/
     */
    convenience init(light: NSColor, dark: NSColor) {
        self.init(name: nil, dynamicProvider: { appearance in
            switch appearance.name {
            case .aqua,
                 .vibrantLight,
                 .accessibilityHighContrastAqua,
                 .accessibilityHighContrastVibrantLight:
                return light

            case .darkAqua,
                 .vibrantDark,
                 .accessibilityHighContrastDarkAqua,
                 .accessibilityHighContrastVibrantDark:
                return dark

            default:
                assertionFailure("Unknown appearance: \(appearance.name)")
                return light
            }
        })
    }
}

#endif
