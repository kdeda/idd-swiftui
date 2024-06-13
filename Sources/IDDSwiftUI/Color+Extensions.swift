//
//  Color+Extensions.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 12/29/22.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
#if os(macOS)
    public static let selectedContentBackgroundColor: Color = Color(NSColor.selectedContentBackgroundColor)
    public static let windowBackgroundColor: Color = Color(NSColor.windowBackgroundColor)
    public static let windowBackground = Color(NSColor.windowBackground)
    public static let lightGray: Color = Color(NSColor.lightGray)
#else
    public static let selectedContentBackgroundColor = Color(UIColor.gray)
    public static let windowBackgroundColor: Color = Color(UIColor.gray)
    public static let windowBackground = Color(UIColor.gray)
    public static let lightGray: Color = Color(UIColor.lightGray)
#endif
}
