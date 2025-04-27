//
//  IDDKeyPress.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 11/3/24.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

import SwiftUI
import AppKit
import Log4swift

#if os(macOS)

//struct IDDKeyPress: ViewModifier {
//    // @State var monitorID: Any?
//    let key: KeyEquivalent
//    let action: () -> Void
//
//    func body(content: Content) -> some View {
//        if #available(macOS 14.0, *) {
//            content.onKeyPress(KeyEquivalent.space, action: {
//                action()
//                return KeyPress.Result.handled
//            })
//        }
//    }
//}
//
//extension View {
//    func iddKeyPress(_ key: KeyEquivalent, action: @escaping () -> Void) -> some View {
//        modifier(IDDKeyPress(key: key, action: action))
//    }
//}

/**
 Work around apple's BS on supporting macOS 14 and above.
 This is all it takes to support older macs ...
 */
public struct IDDKeyPress: ViewModifier {
    let handleEvent: (_ event: NSEvent) -> Bool

    public init(_ handleEvent: @escaping (NSEvent) -> Bool) {
        self.handleEvent = handleEvent
    }

    public func body(content: Content) -> some View {
        content
            .background(Representable(handleEvent: handleEvent))
    }

    private struct Representable: NSViewRepresentable {
        let handleEvent: (_ event: NSEvent) -> Bool

        func makeCoordinator() -> Coordinator {
            let coordinator = Coordinator()

            coordinator.handleEvent = handleEvent
            coordinator.addLocalMonitor()
            return coordinator
        }

        final class Coordinator: NSResponder {
            var monitorID: Any?
            var handleEvent: ((_ event: NSEvent) -> Bool)?

            private func _handleEvent(_ event: NSEvent) -> NSEvent? {
                Log4swift[Self.self].info("event: '\(event)'")

                if (self.handleEvent?(event) ?? false) {
                    return nil
                }
                return event
            }

            internal func addLocalMonitor() {
                self.monitorID = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                    return self?._handleEvent(event)
                }
            }

            internal func removeMonitor() {
                if let id = self.monitorID {
                    // clean up or else we are called with older captured values
                    NSEvent.removeMonitor(id)
                }
            }
        }

        func makeNSView(context: Context) -> NSView {
            return NSView(frame: NSZeroRect)
        }

        func updateNSView(_ nsView: NSView, context: Context) {
        }

        static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
            coordinator.removeMonitor()
        }
    }
}

extension View {
    public func iddKeyPress(_ handleEvent: @escaping (_ event: NSEvent) -> Bool) -> some View {
        modifier(IDDKeyPress(handleEvent))
    }
}

#endif
