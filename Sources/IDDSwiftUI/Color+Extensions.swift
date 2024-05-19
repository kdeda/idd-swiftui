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
    public static var selectedContentBackgroundColor: Color = Color(NSColor.selectedContentBackgroundColor)
    public static var windowBackgroundColor: Color = Color(NSColor.windowBackgroundColor)
    public static var windowBackground = Color(NSColor.windowBackground)
    public static var lightGray: Color = Color(NSColor.lightGray)
#else
    public static var selectedContentBackgroundColor = Color(UIColor.gray)
    public static var windowBackgroundColor: Color = Color(UIColor.gray)
    public static var windowBackground = Color(UIColor.gray)
    public static var lightGray: Color = Color(UIColor.lightGray)
#endif
}
