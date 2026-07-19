//
//  Spinner.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 4/20/21.
//  Copyright (C) 1997-2026 id-design, inc. All rights reserved.
//

import SwiftUI
import IDDSwift
import Log4swift

// gif spinner
// https://giphy.com/stickers/spins-uploading-spinning-wheel-of-death-3o7TKtnuHOHHUjR38Y
// ease functions
// https://gist.github.com/liorazi/689047404b4508f94262ee6f946b97fd
// Mark Moyken
// https://www.youtube.com/watch?v=xQXS9vx4E0M
//
// Andy Regensky
// https://andyregensky.dev/articles/swiftui-autorepeating-fill-clear-animation/
//
// https://swiftui-lab.com/swiftui-animations-part4/
//

struct SliceInfo {
    static let duration: TimeInterval = 0.9
    static let shortDuration = Self.duration/6
    static let longDuration = 4*Self.duration/6

    let sliceCount: Int
    let innerCircleRadius: CGFloat
    let degrees: Double
    let width: CGFloat
    let height: CGFloat
    let sliceWidth: CGFloat
    let sliceHeight: CGFloat

    // we assume the proxy size is a square
    init(proxy: GeometryProxy) {
        let isSmall = proxy.size.width <= 32
        let sliceCount = isSmall ? 8 : 12
        // radius from the dead center we start the slices
        let innerCircleRadius = (proxy.size.height / 4.3).rounded(.down)

        self.sliceCount = sliceCount
        self.innerCircleRadius = innerCircleRadius
        self.degrees = 360.0 / Double(sliceCount)
        self.width = proxy.size.width
        self.height = proxy.size.height
        self.sliceWidth = ((self.height / 2 - innerCircleRadius) / (isSmall ? 2.5 : 2.0)).rounded(.down)
        self.sliceHeight = (self.height / 2 - innerCircleRadius).rounded(.down)
    }
}

fileprivate struct SliceView: View {
    var info: SliceInfo
    var index: Int
    /**
     Each slice is delayed a bit from the previous to create the illusion of progress
     */
    var delay: Double
    @State private var opacity: Double = 0.1
    @State private var animationTask: Task<Void, Never>?

    /**
     We want to combine 2 animations.

     1 From light to dark fast in shortDuration.
     2 From dark to light in longDuration.

     Than we want to repeat this until we are off.

     Stager them so that the very first one delays the least.
     The delay will achieve the fading as you spin effect.

     The trick here is to make sure that SliceInfo.shortDuration + SliceInfo.longDuration
     is less or equal to the duration on the SliceViewModel
     */
    private func startAnimating() {
        animationTask = Task {
            while !Task.isCancelled {
                withAnimation(
                    .easeIn(duration: SliceInfo.shortDuration)
                    .delay(delay)
                ) {
                    opacity = 1.0
                }
                withAnimation(
                    .easeOut(duration: SliceInfo.longDuration)
                    .delay(delay + SliceInfo.shortDuration)
                ) {
                    opacity = 0.1
                }
                try? await Task.sleep(nanoseconds: .nanoseconds(milliseconds: Int(SliceInfo.duration * 1_000)))
            }
        }
    }

    init(info: SliceInfo, index: Int) {
        self.info = info
        self.index = index
        self.delay = Double(index) * (SliceInfo.duration / Double(info.sliceCount))
    }

    public var body: some View {
        Rectangle()
            .clipShape(RoundedRectangle(cornerRadius: info.sliceWidth / 2))
            .frame(width: info.sliceWidth, height: info.sliceHeight)
        // .border(Color.yellow)
            .offset(y: -info.innerCircleRadius)
            .rotationEffect(.degrees(info.degrees * Double(index)), anchor: .bottom)
            .opacity(opacity)
            .onAppear { startAnimating() }
            .offset(
                x: info.width / 2 - info.sliceWidth / 2,
                y: info.innerCircleRadius
            )
            .onDisappear { animationTask?.cancel() }
    }
}

// https://daringsnowball.net/articles/stateobject-lifecycle/
public struct Spinner: View {
    private var isAnimating: Bool
    @State private var opacity: Double = 1.0
    @State private var scale: Double = 1.0

    public init(isAnimating: Bool = false) {
        self.isAnimating = isAnimating
    }

    public var body: some View {
        // Log4swift[Self.self].info("isAnimating: '\(isAnimating)'")
        BodyCount.timed("Spinner") {
            GeometryReader { proxy in
                if isAnimating {
                    let info = SliceInfo(proxy: proxy)

                    // Text("\(Double(info.sliceWidth).with2Digits)").font(.caption)
                    ForEach(0 ..< info.sliceCount, id: \.self) { index in
                        SliceView(info: info, index: index)
                    }
                    // .background(Color.yellow)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    // not sure why the math is so attrocious
                    // now we have spent 100h on it :-)
                    .offset(x: (info.sliceWidth - proxy.size.width) / 2, y: (info.sliceHeight - proxy.size.height) / 2)
                    // .border(Color.green)
                    .scaleEffect(scale, anchor: .center)
                    // .opacity(opacity)
                    .onAppear(perform: {
                        // make us visible
                        // self.opacity = 0.1
                        self.scale = 0.1
                        withAnimation(.easeOut(duration: SliceInfo.shortDuration * 2)) {
                            // self.opacity = 1.0
                            self.scale = 1.0
                        }
                    })
                } else {
                    Rectangle()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .opacity(0)
                }
            }
            // .drawingGroup()
        }
    }
}

struct SpinnerV3_Previews: PreviewProvider {
    static var previews: some View {
        Log4swift.configure(fileLogConfig: nil)

        return VStack {
            HStack {
                Spinner(isAnimating: true)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.gray)
                    .background(Color.init(white: 0.92))
                    .padding(2)
                    .border(Color.yellow)
                ProgressView()
                    .scaleEffect(4, anchor: .center)
                    .frame(width: 128, height: 128)
                    .progressViewStyle(.circular)
                    .padding(2)
                    .border(Color.yellow)
                Spacer()
            }
            HStack {
                Spinner(isAnimating: true)
                    .frame(width: 48, height: 48)
                    .foregroundColor(.gray)
                    // .background(Color.init(white: 0.92))
                    .padding(2)
                    .border(Color.yellow)
                ProgressView()
                    .scaleEffect(1.5, anchor: .center)
                    .frame(width: 48, height: 48)
                    .progressViewStyle(.circular)
                    .padding(2)
                    .border(Color.yellow)
                Spacer()
            }
        }
        .padding(20)
    }
}
