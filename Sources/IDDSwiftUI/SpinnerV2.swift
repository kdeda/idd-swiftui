//
//  SpinnerV2.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 12/8/22.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import SwiftUI
//import Log4swift

public struct SpinnerV2: View {
    struct Slice: Identifiable {
        let id: Int
        let width: CGFloat
        let height: CGFloat
        var degrees: Double = 0
        var animationDuration: Double = 2.5
        var delay: Double = 0.0
        var opacity: Double = 0

        static func slices(proxy: GeometryProxy) -> [Slice] {
            let isSmall = proxy.size.width <= 32
            let sliceCount = isSmall ? 8 : 12
            let width = proxy.size.width / CGFloat(sliceCount)
            let height = proxy.size.height

            return (0 ..< sliceCount).map { index in
                var rv = Slice(
                    id: index,
                    width: width,
                    height: height
                )

                rv.delay = Double(index + 1) * (rv.animationDuration / Double(sliceCount))
                rv.degrees = 360.0 / Double(sliceCount)
                return rv
            }
        }
    }

    public struct SliceView: View {
        var slice: Slice
        private var horizontalPadding: Double = 2
        @State private var opacity: Double = 0

        /**
         Stager them so that the very first one delayes the least.
         The delay will achieve the fading as you spin effect.
         */
        private var animation: Animation {
            return Animation
            // .easeInOut(duration: animationDuration)
                .easeInOut(duration: slice.animationDuration)
                .repeatForever(autoreverses: true)
                .delay(slice.delay)
        }

        init(slice: Slice) {
            self.slice = slice
        }
        
        public var body: some View {
            Rectangle()
                .frame(width: slice.width - horizontalPadding * 2, height: slice.height)
                .cornerRadius((slice.width - horizontalPadding * 2) / 2)
                .padding(.horizontal, horizontalPadding)
                .border(Color.yellow)
                .offset(x: slice.width * CGFloat(slice.id))
                .opacity(opacity)
                .onAppear(perform: {
                    withAnimation(animation) {
                        opacity = 1.0
                    }
                })
        }
    }

    private var isAnimating: Bool = false

    public init(isAnimating: Bool = false) {
        self.isAnimating = isAnimating
    }

    public var body: some View {
        GeometryReader { proxy in
            if isAnimating {
                let slices = Slice.slices(proxy: proxy)

                ForEach(slices) { slice in
                    SliceView(slice: slice)
                }
            } else {
                Rectangle()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .opacity(0)

            }
        }
        // .border(Color.yellow)
        .drawingGroup()
        // .border(Color.yellow)
//        .aspectRatio(1, contentMode: .fit)
//        .onChange(of: startAnimating) { newValue in
//            Log4swift[Self.self].info("onChange: tag: '\(tag)' startAnimating: '\(newValue)' isAnimating: '\(isAnimating)'")
//
//            if newValue != isAnimating {
//                withAnimation {
//                    // now trigger the animations ...
//                    isAnimating = newValue
//                }
//            }
//        }
//        .onAppear {
//            Log4swift[Self.self].info("onAppear: tag: '\(tag)' startAnimating: '\(startAnimating)' isAnimating: '\(isAnimating)'")
//
//            if startAnimating != isAnimating {
//                withAnimation {
//                    // now trigger the animations ...
//                    isAnimating = startAnimating
//                }
//            }
//        }
    }
}

struct SpinnerV2_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VStack {
                SpinnerV2(isAnimating: true)
                    .frame(width: 256, height: 32)
                    .foregroundColor(.gray)
                Spacer()
                    .frame(width: 128, height: 128)
//                ProgressView()
//                    .scaleEffect(4.0, anchor: .center)
//                    .frame(width: 128, height: 128)
//                    .progressViewStyle(.circular)
            }
        }
        .padding(20)
    }
}
