//
//  SearchTextField.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 5/5/21.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//
//  With many thanks to:
//  https://fullstackstanley.com/read/replicating-the-macos-search-textfield-in-swiftui/
//  Modified to use GeometryReader
//  Might need to https://github.com/siteline/SwiftUI-Introspect
//  Read
//  https://sarunw.com/posts/textfield-in-swiftui/
//

import SwiftUI
import AppKit
import Log4swift

// This extension removes the focus ring entirely.
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

// https://swiftui-lab.com/a-powerful-combo/
// The NSViewRepresentable is a beast and allows to plugin to the AppKit
//
// https://swiftuirecipes.com/blog/focus-change-in-securefield
//
//struct MyTextField: NSViewRepresentable {
//    var placeHolder: String = "Search..."
//    @Binding var text: String
//    @Binding var isFocused: Bool
//
//    init(_ placeHolder: String, text: Binding<String>, isFocused: Binding<Bool>) {
//        self.placeHolder = placeHolder
//        self._text = text
//        self._isFocused = isFocused
//    }
//
//    func makeNSView(context: NSViewRepresentableContext<MyTextField>) -> NSTextField {
//        let tf = NSTextField()
//
//        tf.focusRingType = .none
//        tf.isBordered = false
//        tf.drawsBackground = false
//        tf.delegate = context.coordinator
//        return tf
//    }
//
//    func updateNSView(_ nsView: NSTextField, context: NSViewRepresentableContext<MyTextField>) {
//        nsView.stringValue = text
//        Log4swift["MyTextField"].logInfo("stringValue: '\(text)'")
//    }
//
//    func makeCoordinator() -> MyTextField.Coordinator {
//        Coordinator(text: $text, isFocused: $isFocused)
//    }
//
//    class Coordinator: NSObject, NSTextFieldDelegate  {
//        @Binding var text: String
//        @Binding var isFocused: Bool
//
//        init(text: Binding<String>, isFocused: Binding<Bool>) {
//            self._text = text
//            self._isFocused = isFocused
//        }
//
//        func controlTextDidBeginEditing(_ obj: Notification) {
//            DispatchQueue.main.async {
//               self.isFocused = true
//            }
//        }
//
//        func controlTextDidEndEditing(_ obj: Notification) {
//            DispatchQueue.main.async {
//                self.isFocused = false
//            }
//        }
//
//        func controlTextDidChange(_ obj: Notification) {
//            let textField = obj.object as! NSTextField
//            text = textField.stringValue
//        }
//    }
//}

public struct SearchTextField: View {
    var placeHolder: String = "Search..."
    @Binding var text: String
    @State var isFocused: Bool = false

    #if !os(macOS)
    private let backgroundColor = Color(UIColor.secondarySystemBackground)
    #else
    private let backgroundColor = Color(NSColor.controlBackgroundColor)
    #endif

    public init(_ placeHolder: String, text: Binding<String>) {
        self.placeHolder = placeHolder
        self._text = text
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(Color.white)
                    .frame(width: proxy.size.width, height: 22)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(isFocused ? Color.blue.opacity(0.7) : Color.gray.opacity(0.4), lineWidth: isFocused ? 3 : 1)
                            .frame(width: proxy.size.width, height: 21)
                    )
                
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 12, height: 12)
                        .padding(.horizontal, 5)
                        .opacity(0.8)
                    
                    // experimental code ...
//                    MyTextField(placeHolder, text: $text, isFocused: $isFocused)
//                        .whenHovered { newValue in
//                            Log4swift[Self.self].logInfo("whenHovered: \(newValue) text: \(text)")
//                            self.isFocused = newValue
//                        }

                    TextField(placeHolder, text: $text, onEditingChanged: { (changed) in
                        Log4swift[Self.self].logInfo("onEditingChanged: \(changed) text: \(text)")

                        self.isFocused = changed
                    }, onCommit: {
                        Log4swift[Self.self].logInfo("onCommit: \(text)")
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                    .whenHovered { newValue in
                        Log4swift[Self.self].logInfo("whenHovered: \(newValue) text: \(text)")
                        self.isFocused = newValue
                    }

                    if text != "" {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .padding(.trailing, 3)
                                .opacity(0.5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(self.text == "" ? 0 : 0.5)
                    }
                }
                .focusable(isFocused, onFocusChange: { focused in
                    Log4swift[Self.self].logInfo("onFocusChange: \(focused)")
                })

            }
        }
        .frame(height: 22)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                SearchTextField("Search...", text: .constant("123"))
                    .frame(width: 220)
            }
            .padding()
        }
    }
}
