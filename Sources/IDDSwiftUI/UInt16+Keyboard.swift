//
//  UInt16+Keyboard.swift
//  IDDSwift
//
//  Created by Klajd Deda on 3/5/24.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

import Foundation
import Carbon

// Convenience
// https://gist.github.com/rdev/627a254417687a90c493528639465943
// https://stackoverflow.com/questions/3202629/where-can-i-find-a-list-of-mac-virtual-key-codes
//
public extension UInt16 {
    // Layout-independent Keys
    // eg.These key codes are always the same key on all layouts.
    static let downArrow: UInt16 = 0x7D
    static let enter: UInt16 = 0x4C // kVK_ANSI_KeypadEnter
    static let escape: UInt16 = 0x35
    static let leftArrow: UInt16 = 0x7B
    static let returnKey: UInt16 = 0x24 // kVK_Return
    static let rightArrow: UInt16 = 0x7C
    static let space: UInt16 = 0x31 // kVK_Space
    static let upArrow: UInt16 = 0x7E
}

