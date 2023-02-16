//
//  SpinningRects.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 1/9/23.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import Foundation
import SwiftUI

struct SpinningRects: View {
    @State private var moving = false
    @State var scale: Double = 1.0
    var count = 8

    var body: some View {
        GeometryReader { proxy in
            let info = SliceInfo(proxy: proxy)

            ForEach(0 ..< info.sliceCount, id: \.self) { index in
                Group {
                    Rectangle()
                        .cornerRadius(info.sliceWidth / 2)
                        .frame(width: info.sliceWidth, height: info.sliceHeight)
                        .offset(y: -info.innerCircleRadius)
                        .rotationEffect(.degrees(info.degrees * Double(index)), anchor: .bottom)
                        .opacity(0.1)
                        .scaleEffect(scale, anchor: .center)
                        .offset(
                            x: proxy.size.width / 2 - info.sliceWidth / 2,
                            y: info.innerCircleRadius
                        )
                }
                .border(Color.yellow)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .offset(x: (info.sliceWidth - proxy.size.width) / 2, y: (info.sliceHeight - proxy.size.height) / 2)
        }
        .onAppear{
            // make us visible
            // self.opacity = 0.1
            self.scale = 0.1
            withAnimation(.easeOut(duration: SliceInfo.shortDuration * 180)) {
                // self.opacity = 1.0
                self.scale = 1.0
            }
        }

//        GeometryReader { proxy in
//            ZStack() {
//                ForEach(1 ... count, id: \.self) { index in
//                    Circle()
//                        .stroke(lineWidth: 5)
//                        .frame(width: 20 + Double(index) * 30, height: 20 + Double(index) * 30)
//                        .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                        .offset(y: moving ? proxy.size.height/4 : -proxy.size.height/4)
//                        .animation(
//                            .interpolatingSpring(stiffness: 100, damping: 5)
//                            .repeatForever(autoreverses: true)
//                            .delay(Double(index) * 0.05),
//                            value: moving
//                        )
//                }
//            }
//            .offset(x: proxy.size.width/2 - Double(count) / 2 * 30)
//        }
//            ZStack {
//            Circle() // One
//                .stroke(lineWidth: 5)
//                .frame(width: 20, height: 20)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true), value: moving)
//
//            Circle()  // Two
//                .stroke(lineWidth: 5)
//                .frame(width: 50, height: 50)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.05), value: moving)
//
//            Circle()  // Three
//                .stroke(lineWidth: 5)
//                .frame(width: 80, height: 80)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.1), value: moving)
//
//            Circle()  // Four
//                .stroke(lineWidth: 5)
//                .frame(width: 110, height: 110)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.15), value: moving)
//
//            Circle()  // Five
//                .stroke(lineWidth: 5)
//                .frame(width: 140, height: 140)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.2), value: moving)
//
//            Circle()  // Six
//                .stroke(lineWidth: 5)
//                .frame(width: 170, height: 170)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.25), value: moving)
//
//            Circle()  // Seven
//                .stroke(lineWidth: 5)
//                .frame(width: 200, height: 200)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.3), value: moving)
//
//            Circle()  // Eight
//                .stroke(lineWidth: 5)
//                .frame(width: 230, height: 230)
//                .rotation3DEffect(.degrees(75), axis: (x: 1, y: 0, z: 0))
//                .offset(y: moving ? 50 : -50)
//                .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(0.35), value: moving)
//        }
//        .onAppear{
//            moving.toggle()
//        }
    }

}

struct SpinningRects_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SpinningRects()
                .frame(width: 512, height: 512)
        }
        .frame(width: 512, height: 512)
        .environment(\.colorScheme, .light)
    }
}
