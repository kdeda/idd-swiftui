//
//  SpinnerV0.swift
//  IDDSwiftCommons
//
//  Created by Klajd Deda on 4/20/21.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import SwiftUI
// import Log4swift

// gif spinner
// https://giphy.com/stickers/spins-uploading-spinning-wheel-of-death-3o7TKtnuHOHHUjR38Y
// ease functions
// https://gist.github.com/liorazi/689047404b4508f94262ee6f946b97fd
// Mark Moyken
// https://www.youtube.com/watch?v=xQXS9vx4E0M
//

public struct SpinnerV0: View {
    struct SliceInfo {
        let sliceCount: Int
        let innerCircleRadius: CGFloat
        let degrees: Double
        let width: CGFloat
        let height: CGFloat

        // we assume the proxy size is a square
        init(proxy: GeometryProxy) {
            let isSmall = proxy.size.width <= 32
            let sliceCount = isSmall ? 8 : 12

            self.sliceCount = sliceCount
            // radius from the dead center we start the slices
            let innerCircleRadius = proxy.size.height / 4
            self.innerCircleRadius = innerCircleRadius
            self.width = (proxy.size.height / 2 - innerCircleRadius) / (isSmall ? 2.5 : 2.0)
            self.height = proxy.size.height / 2 - innerCircleRadius
            self.degrees = 360.0 / Double(sliceCount)
        }
    }

    private let animationDuration: Double = 0.8
    @State private var isAnimating: Bool = false

    /**
     Stager them so that the very first one delayes the least.
     The delay will achieve the fading as you spin effect.
     */
    private func animation(_ index: Int, sliceCount: Int) -> Animation {
        // Log4swift[Self.self].info("index: '\(index)'")

        switch isAnimating {
            case true:
                let delay = Double(index) * (animationDuration / Double(sliceCount))

                // Log4swift[Self.self].info("slice: '\(String(format: "%2d", index))' duration: '\(animationDuration)', delay: '\(delay)'")
                return Animation
                    // .easeInOut(duration: animationDuration)
                .linear(duration: animationDuration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)

            case false:
                return Animation
                    .linear(duration: 0.0)
                    .delay(0.0)
        }
    }

    private var opacity: Double {
        isAnimating ? 1.0 : 0.0
    }

    private var startAnimating: Bool
    var tag: String

    public init(
        isAnimating: Bool = false,
        tag: String = ""
    ) {
        self.startAnimating = isAnimating
        self.tag = tag
        // Log4swift[Self.self].info("tag: '\(tag)' startAnimating: '\(startAnimating)' isAnimating: '\(isAnimating)'")
    }

    public var body: some View {
        // Log4swift[Self.self].info("tag: '\(tag)' startAnimating: '\(startAnimating)' isAnimating: '\(isAnimating)'")

        return GeometryReader { proxy in
            let info = SliceInfo(proxy: proxy)

            // Log4swift[Self.self].info("info: '\(info)'")
            // Text("\(Int(proxy.size.width))")
            //     .font(.footnote)
            //     .fontWeight(.semibold)
            //     .foregroundColor(Color.black)
            ForEach(0..<info.sliceCount, id: \.self) { index in
                Group {
                    Rectangle()
                        .frame(width: info.width, height: info.height)
                        .cornerRadius(info.width/2)
                        .opacity(opacity)
                        .animation(animation(index, sliceCount: info.sliceCount), value: opacity)
                        .offset(y: -info.innerCircleRadius)
                        .rotationEffect(.degrees(info.degrees * Double(index)), anchor: .bottom)
                }
                .offset(
                    x: proxy.size.width / 2 - info.width / 2,
                    y: info.innerCircleRadius
                )
            }
        }
        // .opacity(isAnimating ? 1.0 : 0.3)

        // debugging
        //        return VStack {
        //            switch isAnimating {
        //            case true:
        //                Text("yes")
        //                    .font(.footnote)
        //                    .fontWeight(.semibold)
        //                    .foregroundColor(Color.black)
        //            case false:
        //                Text("no")
        //                    .font(.footnote)
        //                    .fontWeight(.semibold)
        //                    .foregroundColor(Color.black)
        //            }
        //        }
        //        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .drawingGroup()
        // .border(Color.yellow)
        .aspectRatio(1, contentMode: .fit)
        .onChange(of: startAnimating) { newValue in
//            Log4swift[Self.self].info("onChange: tag: '\(tag)' startAnimating: '\(newValue)' isAnimating: '\(isAnimating)'")

            if newValue != isAnimating {
                withAnimation {
                    // now trigger the animations ...
                    isAnimating = newValue
                }
            }
        }
        .onAppear {
//            Log4swift[Self.self].info("onAppear: tag: '\(tag)' startAnimating: '\(startAnimating)' isAnimating: '\(isAnimating)'")

            if startAnimating != isAnimating {
                withAnimation {
                    // now trigger the animations ...
                    isAnimating = startAnimating
                }
            }
        }
    }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SpinnerV0(isAnimating: true)
                .frame(width: 16, height: 16)
                .foregroundColor(.green)
//            Spinner()
//                .frame(width: 24, height: 24)
//                .foregroundColor(.green)
            SpinnerV0()
                .frame(width: 32, height: 32)
                .foregroundColor(.green)
            ZStack {
                SpinnerV0(isAnimating: true)
                    .frame(width: 128, height: 128)
                    .foregroundColor(.gray)
                ProgressView()
                    .scaleEffect(4, anchor: .center)
                    .frame(width: 128, height: 128)
                    .progressViewStyle(.circular)
            }
//            Spinner()
//                .frame(width: 64, height: 64)
//                .foregroundColor(.green)]
            //            Spinner(isAnimating: true)
            //                .frame(width: 128, height: 128)
            //                .foregroundColor(.red)
            //            HStack {
            //                Spinner(isAnimating: true)
            //                    .frame(width: 256, height: 256)
            //                    .foregroundColor(.gray)
            //                ProgressView()
            //                    .scaleEffect(8.0, anchor: .center)
            //                    .frame(width: 256, height: 256)
            //                    .progressViewStyle(.circular)
            //            }
            //            Spinner()
            //                .frame(width: 512, height: 512)
            //                .foregroundColor(.red)
        }
        .padding(20)
    }
}
