//
//  ColumnDrag.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 1/18/23.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

#if os(macOS)

import AppKit
import Foundation
import SwiftUI
import Log4swift

@MainActor
final class ColumnDragViewModel: ObservableObject {
    enum ViewType {
        case verticalLine
        case dragIcon
    }
    @Published var viewType: ViewType
    private var task: Task<Void, Never>?

    private func setScrollType(_ newValue: NSScroller.Style) {
        Log4swift[Self.self].info("newValue: '\(newValue)'")
        viewType = (newValue == .legacy) ? .dragIcon : .verticalLine
    }

    init() {
        self.viewType = .dragIcon
        listen()
    }

    deinit {
        task?.cancel()
        self.task = nil
    }

    private func listen() {
        task = Task {
            self.setScrollType(NSScroller.preferredScrollerStyle)

            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    if #available(macOS 12, *) {
                        for await notification in NotificationCenter.default.notifications(named: NSScroller.preferredScrollerStyleDidChangeNotification, object: nil) {
                            Log4swift[Self.self].error("notification: '\(notification)'")
                            if let userInfo = notification.userInfo,
                               let styleInt = userInfo["NSScrollerStyle"] as? Int
                            {
                                let newStyle = NSScroller.Style.init(rawValue: styleInt) ?? .legacy
                                await self.setScrollType(newStyle)
                            }
                        }
                    } else {
                        // should be on macos 13 and greater
                        // Fallback on earlier versions
                    }
                }
            }
        }
    }
}

/**
 Very cool, It lets you grab the corner of a view and resize it.
 */
public struct ColumnDrag: View {
    private static var padding: CGFloat = 3
    private static var imageHeight: CGFloat = 8
    private static var imageWidth: CGFloat = 7
    private static var width: CGFloat = 8 + padding * 2
    private static var height: CGFloat = 8 + padding * 2

    var minWidth: CGFloat
    @Binding var columnWidth: CGFloat
    var maxWidth: CGFloat
    var columnIndex: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var frameOrigin: CGPoint?
    private var debugUI = false
    private var isIcon = false
    @StateObject private var viewModel = ColumnDragViewModel()

    private var scrollerBackgroundColor: Color {
        colorScheme == .light
        ? Color(red: 250/255, green: 250/255, blue: 250/255)
        : Color(red: 43/255, green: 43/255, blue: 43/255)
    }

    /**
     We want to detect width changes.
     As the user drags us left or right, we want to push the new changed width up to the parent chain using the columnWidth binding.

     However, as the parent components resize this has the side effect of producing the wrong DragGesture.onChange.value.startLocation.
     This is our attempt at compensating.

     It fixes the option click + draggin but fucks the rest since now the cursor pointer is off
     */
    private func offset(proxy: GeometryProxy) -> CGFloat {
        if let frameOrigin = frameOrigin {
            let origin = proxy.frame(in: .global).origin
            return origin.x - frameOrigin.x
        }
        return 0
    }

    private func add(width: CGFloat) {
        columnWidth += width.rounded(.down)
        if columnWidth > maxWidth {
            columnWidth = maxWidth
        } else if columnWidth <= minWidth {
            columnWidth = minWidth
        }
    }

    private func proxyFrame(_ frame: CGRect) -> String {
        "\(frame)"
    }

    public init(
        minWidth: CGFloat,
        ideal: Binding<CGFloat>,
        maxWidth: CGFloat,
        columnIndex: Int
    ) {
        self.minWidth = minWidth
        self._columnWidth = ideal
        self.maxWidth = maxWidth
        self.columnIndex = columnIndex
    }

    public func debug() -> Self {
        var copy = self
        copy.debugUI = true
        return copy
    }

    private func updateCursor(_ inside: Bool) {
        if inside {
            NSCursor.resizeLeftRight.push()
        } else {
            NSCursor.pop()
        }
    }

    private func drgaGestureDidChange(_ value: DragGesture.Value, _ proxy: GeometryProxy) {
        let offset = offset(proxy: proxy)
        let width = (value.location.x - value.startLocation.x + offset).rounded(.down)
        let flags = NSApplication.shared.currentEvent?.modifierFlags ?? NSEvent.ModifierFlags(rawValue: 0)
        let optionClick = flags.contains([.option])

        Log4swift[Self.self].debug("onChanged[\(columnIndex)] startLocation: '\(value.startLocation.x.rounded(.down))' location: '\(value.location.x.rounded(.down))' width: '\(width.rounded(.down))' offset: '\(offset.rounded(.down))' columnWidth: '\(columnWidth + width)' optionClick: '\(optionClick)'")

        if frameOrigin == .none && optionClick {
            frameOrigin = proxy.frame(in: .global).origin
        }
        add(width: width)
        // Log4swift["ColumnDrag"].info("onChanged[\(id)] columnWidth: '\(columnWidth)'")
    }

    private func drgaGestureDidEnd(_ value: DragGesture.Value, _ proxy: GeometryProxy) {
        let offset = offset(proxy: proxy)
        let width = (value.location.x - value.startLocation.x + offset).rounded(.down)

        Log4swift[Self.self].debug("onEnded[\(columnIndex)] width: '\(width.rounded(.down))' offset: '\(offset.rounded(.down))' columnWidth: '\(columnWidth + width)'")
        add(width: width)
        frameOrigin = .none
    }

    @ViewBuilder
    private func verticalLine(_ proxy: GeometryProxy) -> some View {
        HStack {
            Spacer()
            Rectangle()
                .fill(.gray.opacity(0.14))
                .frame(width: 1)
                .padding(.horizontal, 3)
                // .border(.red.opacity(0.5))
                .contentShape(Rectangle())
                .onHover(perform: updateCursor)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { drgaGestureDidChange($0, proxy) }
                        .onEnded { drgaGestureDidEnd($0, proxy) }
                )
        }
    }

    @ViewBuilder
    private func dragIcon(_ proxy: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: "equal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: debugUI ? (Self.imageWidth + 20) : Self.imageWidth,
                        height: Self.imageHeight
                    )
                    .padding(.all, Self.padding)
                    .padding(.trailing, 2)
                // .border(.red)
                    .rotationEffect(debugUI ? .degrees(0) : .degrees(-90))
                // .offset(x: 1)
                // .background(Color.clear)
                    .background(scrollerBackgroundColor)
                    .onHover(perform: updateCursor)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged { drgaGestureDidChange($0, proxy) }
                            .onEnded { drgaGestureDidEnd($0, proxy) }
                    )
                    .background(debugUI ? Color.white : nil)
                    .overlay(
                        Rectangle()
                            .fill(.gray.opacity(0.18))
                            .frame(width: 1)
                        , alignment: .leading)
                    .overlay(
                        Rectangle()
                            .fill(.gray.opacity(0.14))
                            .frame(width: 1)
                        , alignment: .trailing)
            }
            if debugUI {
                VStack {
                    HStack {
                        Text("local: " + proxyFrame(proxy.frame(in: .local)))
                            .font(.caption)
                        Spacer()
                    }
                    .background(Color.white)
                    HStack {
                        Text("child: " + proxyFrame(proxy.frame(in: .global)))
                            .font(.caption)
                        Spacer()
                    }
                    .background(Color.white)
                }
            }
        }
    }

    /**
     Even more crap.
     We are designed in a way that the DragGesture is all the way at the bottom trailing of the GeometryReader.
     If this design breaks the math at offset(proxy:) will be off.

     Really hacky ...
     We need a real NSViewRepresentable DragGesture
     */
    public var body: some View {
        // Log4swift[Self.self].info("idealWidth[\(id)]: '\(idealWidth)'")
        GeometryReader { proxy in
            switch viewModel.viewType {
            case .verticalLine:
                verticalLine(proxy)
            case .dragIcon:
                dragIcon(proxy)
            }
            // .border(.red)
        }
    }
}

public struct ColumnDragContainer: View {
    struct ColumnConfig {
        static let MIN_WIDTH: CGFloat = 160
        static let MAX_WIDTH: CGFloat = 340
    }

    @State var columnWidths: [CGFloat] = [ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH]
    let colors: [Color] = [.red, .green, .yellow, .blue]

    public init() {
    }

    public var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(0 ..< colors.count, id: \.self) { index in
                    ScrollView {
                        //    HStack { // debug
                        //        VStack(alignment: .leading, spacing: 2) {
                        //            Text("minWidth: \(ColumnConfig.MIN_WIDTH)")
                        //            Text("ideal: \(columnWidths[index])")
                        //            Text("index: \(index)")
                        //        }
                        //        .padding(4)
                        //        .font(.caption)
                        //        Spacer()
                        //    }
                        Rectangle()
                            .frame(width: columnWidths[index] - 10, height: 200 + Double(index) * 50)
                            .foregroundColor(colors[index].opacity(0.1))
                            .padding(10)
                    }
                    // .border(.red)
                    .overlay(
                        ColumnDrag(
                            minWidth: ColumnConfig.MIN_WIDTH,
                            // ideal: $columnWidths[index],
                            ideal: Binding<CGFloat>(
                                get: { self.columnWidths[index] },
                                set: { newValue in
                                    let flags = NSApplication.shared.currentEvent?.modifierFlags ?? NSEvent.ModifierFlags(rawValue: 0)

                                    columnWidths[index] = newValue
                                    if flags.contains([.option]) {
                                        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        // this will fucking break the DragGesture locatiom for us
                                        // we will move each column to be of the exact width and so the column before us
                                        // will become wider for example
                                        // this will cause the DragGesture locatiom to appear as if we moved left !!!!
                                        // fuck apple.
                                        //
                                        Log4swift[Self.self].info("optionClick[\(index)]: '\(newValue)'")

                                        // this works, since we are avoiding to change the origin of the ColumnDrag before us
                                        // columnWidths = (0 ..< columnWidths.count)
                                        //     .reduce(into: columnWidths) { partialResult, nextIndex in
                                        //         if nextIndex >= index {
                                        //             partialResult[nextIndex] = newValue
                                        //         }
                                        //     }
                                        columnWidths = columnWidths.map { _ in newValue }
                                        // }
                                    }
                                }),
                            // $columnWidths[index], // .animation(.linear(duration: 5.0)),
                            maxWidth: ColumnConfig.MAX_WIDTH,
                            columnIndex: index
                        )
                        // .debug()
                        , alignment: .bottomTrailing)
                }
                Spacer()
            }
            .padding(10)
            .padding(.horizontal, 40)
            Divider()
            HStack {
                Spacer()
                Button("Reset") {
                    Log4swift[Self.self].info("Measure Home [NOOP]")
                    columnWidths = columnWidths.reduce(into: [CGFloat](), { partialResult, nextValue in
                        partialResult.append(180.0)
                    })
                }
            }
            .padding(10)
        }
    }
}

#Preview("ColumnDrag - Light") {
    ColumnDragContainer()
//        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .light)
}

#Preview("ColumnDrag - Dark") {
    ColumnDragContainer()
        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .dark)
}

#endif
