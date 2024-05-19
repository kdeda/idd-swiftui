//
//  SearchFocusTextField.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 9/11/23.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

#if os(macOS)

import Foundation
import SwiftUI
import Log4swift

/**
 Quick and simple focusable TextField
 With many thanks to:
 https://github.com/onmyway133/blog/issues/589
 */
internal struct SearchFocusTextField: NSViewRepresentable {
    let placeholder: String
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSubmit: (() -> Void)?

    init(_ placeholder: String, text: Binding<String>, isFocused: Binding<Bool>) {
        self.placeholder = placeholder
        self._text = text
        self._isFocused = isFocused
    }

    func makeNSView(context: Context) -> FocusAwareTextField {
        let tf = FocusAwareTextField()

        tf.onFocusChange = { _ in
            isFocused = true
        }
        tf.focusRingType = .none
        tf.isBordered = false
        tf.isEditable = true
        tf.isSelectable = true
        tf.drawsBackground = false
        tf.delegate = context.coordinator
        tf.placeholderString = placeholder
        return tf
    }

    func updateNSView(
        _ nsView: FocusAwareTextField,
        context: Context
    ) {
        // true if we are first responder
        let isEditing = nsView.currentEditor() != nil

        // Log4swift[Self.self].info("isFocused: \(self.$isFocused.wrappedValue)")
        // let firstResponder = nsView.window?.firstResponder
        // let isFirstResponder = firstResponder == nsView
        // Log4swift[Self.self].info("isFirstResponder: \(isFirstResponder)")
        // Log4swift[Self.self].info("isEditing: \(isEditing)")

        nsView.stringValue = text
        nsView.placeholderString = placeholder
        if !self.$isFocused.wrappedValue && isEditing {
            // we are told to defocus and we are focused
            // for a change of state
            if let window = nsView.window {
                window.perform(
                    #selector(window.makeFirstResponder(_:)),
                    with: nil,
                    afterDelay: 0.1
                )
            }
        }
    }

    func makeCoordinator() -> SearchFocusTextField.Coordinator {
        Coordinator(parent: self)
    }

    func onSubmit(_ callBack: @escaping (() -> Void)) -> Self {
        var copy = self
        copy.onSubmit = callBack
        return copy
    }
}

extension SearchFocusTextField {
    class Coordinator: NSObject, NSTextFieldDelegate  {
        let parent: SearchFocusTextField
        
        init(parent: SearchFocusTextField) {
            self.parent = parent
        }

        func controlTextDidBeginEditing(_ obj: Notification) {
            parent.isFocused = true
        }

        func controlTextDidEndEditing(_ obj: Notification) {
            parent.isFocused = false
        }

        func controlTextDidChange(_ obj: Notification) {
            let textField = obj.object as! NSTextField
            parent.text = textField.stringValue
        }

        @objc public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onSubmit?()
                return true
            }
            return false
        }
    }
    
    class FocusAwareTextField: NSTextField {
        var onFocusChange: (Bool) -> Void = { _ in }

        override func becomeFirstResponder() -> Bool {
            onFocusChange(true)
            return super.becomeFirstResponder()
        }
    }
}

#endif
