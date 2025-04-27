//
//  UInt16+Keyboard.swift
//  IDDSwift
//
//  Created by Klajd Deda on 3/5/24.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

import Foundation

// Convenience
// https://gist.github.com/rdev/627a254417687a90c493528639465943
//
public extension UInt16 {
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    static let downArrow: UInt16 = 0x7D
    static let enter: UInt16 = 0x4C
    static let escape: UInt16 = 0x35
    static let leftArrow: UInt16 = 0x7B
    static let returnKey: UInt16 = 0x24
    static let rightArrow: UInt16 = 0x7C
    static let space: UInt16 = 0x31
    static let upArrow: UInt16 = 0x7E
}

