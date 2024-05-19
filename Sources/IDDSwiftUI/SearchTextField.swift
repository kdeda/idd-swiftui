//
//  SearchTextField.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 5/5/21.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

#if os(macOS)

import SwiftUI
import AppKit
import Log4swift

public struct SearchTextField: View {
    var placeHolder: String = "Search..."
    @Binding var text: String
    @State var isFocused: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var onSubmit: (() -> Void) = {}

    #if !os(macOS)
    private let backgroundColor = Color(UIColor.secondarySystemBackground)
    #else
    private let backgroundColor = Color(NSColor.controlBackgroundColor)
    #endif
    
    private var rectColor: Color {
        colorScheme == .light
        ? Color(red: 255/255, green: 255/255, blue: 255/255)
        : Color(red: 60/255, green: 60/255, blue: 60/255)
    }
    
    public init(_ placeHolder: String, text: Binding<String>) {
        self.placeHolder = placeHolder
        self._text = text
    }
    
    /**
     Ideally this should look just like the Search field on Finder.
     September 11, 2023
     */
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(rectColor)
                    .frame(width: proxy.size.width, height: 22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(
                                isFocused ? Color.accentColor.opacity(0.5) : Color.gray.opacity(0.4),
                                lineWidth: isFocused ? 3.5 : 1
                            )
                            .frame(
                                width: proxy.size.width,
                                height: isFocused ? 24 : 21
                            )
                    )
                
                HStack(spacing: 0) {
                    // this should appear just like the `multiply.circle.fill` button image below
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .padding(.leading, 2)
                        .padding(.horizontal, 6)
                        .opacity(0.8)

                    SearchFocusTextField(
                        placeHolder,
                        text: $text,
                        isFocused: $isFocused
                    )
                    .onSubmit(onSubmit)
                    .truncationMode(.middle)
                    .textFieldStyle(PlainTextFieldStyle())

                    if text != "" {
                        Button(action: {
                            self.text = ""
                            self.isFocused = false
                        }) {
                            // erase the string
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 13, height: 13)
                                .padding(.leading, 2)
                                .padding(.horizontal, 6)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0.66)
                    }
                }
            }
        }
        .frame(height: 24)
    }

    /**
     Will be called when you hit the enter key on the Search Field
     */
    public func onSubmit(_ callBack: @escaping (() -> Void)) -> some View {
        var copy = self
        copy.onSubmit = callBack
        return copy
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                SearchTextField("Search...", text: .constant("IDDSwiftUI.SearchTextField body"))
                    .frame(width: 220)
            }
            .padding()
        }
        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .light)

        Group {
            VStack {
                SearchTextField("Search...", text: .constant("123"))
                    .frame(width: 220)
            }
            .padding()
        }
        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .dark)
    }
}

#endif
