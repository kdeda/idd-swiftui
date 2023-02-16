//
//  ColumnDrag.swift
//  IDDSwiftCommons
//
//  Created by Klajd Deda on 1/18/23.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import Foundation
import SwiftUI
import Log4swift

public struct ColumnDrag: View {
    private static var padding: CGFloat = 3
    private static var imageHeight: CGFloat = 8
    private static var imageWidth: CGFloat = 7
    private static var width: CGFloat = 8 + padding * 2
    private static var height: CGFloat = 8 + padding * 2

    var minWidth: CGFloat
    @Binding var columnWidth: CGFloat
    var maxWidth: CGFloat
    var id: Int
    @Environment(\.colorScheme) var colorScheme
    @State private var frameOrigin: CGPoint?
    private var debugUI = false

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
        id: Int
    ) {
        self.minWidth = minWidth
        self._columnWidth = ideal
        self.maxWidth = maxWidth
        self.id = id
    }

    public func debug() -> Self {
        var copy = self
        copy.debugUI = true
        return copy
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
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Divider().frame(height: Self.height)
                    Image(systemName: "equal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: debugUI ? (Self.imageWidth + 20) : Self.imageWidth,
                            height: Self.imageHeight
                        )
                        .padding(.all, Self.padding)
                        // .border(.red)
                        .rotationEffect(debugUI ? .degrees(0) : .degrees(-90))
                    // .offset(x: 1)
                        .background(scrollerBackgroundColor)
                        .onHover { inside in
                            if inside {
                                NSCursor.resizeLeftRight.push()
                            } else {
                                NSCursor.pop()
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onChanged { value in
                                    let offset = offset(proxy: proxy)
                                    let width = (value.location.x - value.startLocation.x + offset).rounded(.down)
                                    let flags = NSApp.currentEvent?.modifierFlags ?? NSEvent.ModifierFlags(rawValue: 0)
                                    let optionClick = flags.contains([.option])

                                    Log4swift["ColumnDrag"].info("onChanged[\(id)] startLocation: '\(value.startLocation.x.rounded(.down))' location: '\(value.location.x.rounded(.down))' width: '\(width.rounded(.down))' offset: '\(offset.rounded(.down))' columnWidth: '\(columnWidth + width)' optionClick: '\(optionClick)'")

                                    if frameOrigin == .none && optionClick {
                                        frameOrigin = proxy.frame(in: .global).origin
                                    }
                                    add(width: width)
                                    // Log4swift["ColumnDrag"].info("onChanged[\(id)] columnWidth: '\(columnWidth)'")
                                }
                                .onEnded { value in
                                    let offset = offset(proxy: proxy)
                                    let width = (value.location.x - value.startLocation.x + offset).rounded(.down)

                                    Log4swift["ColumnDrag"].info("onEnded[\(id)] width: '\(width.rounded(.down))' offset: '\(offset.rounded(.down))' columnWidth: '\(columnWidth + width)'")
                                    add(width: width)
                                    frameOrigin = .none
                                }
                        )
                    Divider().frame(height: Self.height)
                }
                .background(debugUI ? Color.white : nil)
                if debugUI {
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
}

public struct ColumnDragContainer: View {
    struct ColumnConfig {
        static let MIN_WIDTH: CGFloat = 260
        static let MAX_WIDTH: CGFloat = 440
    }

    @State var columnWidths: [CGFloat] = [ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH, ColumnConfig.MIN_WIDTH]
    let colors: [Color] = [.red, .green, .yellow, .blue]

    public init() {
    }

    public var body: some View {
        VStack(spacing: 10) {
            HStack {
                ForEach(0 ..< colors.count, id: \.self) { index in
                    Rectangle()
                        .frame(width: columnWidths[index])
                        .foregroundColor(colors[index])
                        .overlay {
                            ColumnDrag(
                                minWidth: ColumnConfig.MIN_WIDTH,
                                ideal: Binding<CGFloat>(
                                    get: { columnWidths[index] },
                                    set: { newValue in
                                        columnWidths[index] = newValue
                                        let flags = NSApp.currentEvent?.modifierFlags ?? NSEvent.ModifierFlags(rawValue: 0)
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
                                id: index
                            )
                            // .debug()
                        }
                }
                Spacer()
            }
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

struct ColumnDrag_Previews: PreviewProvider {
    static var previews: some View {
        ColumnDragContainer()
    }
}
