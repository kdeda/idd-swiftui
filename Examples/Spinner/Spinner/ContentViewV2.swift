//
//  ContentView.swift
//  ComposableAnimations
//
//  Created by Wendell Thompson (AO) on 12/20/22.
//

import SwiftUI
import IDDSwift
import IDDSwiftCommons

struct ContentViewV2: View {
    enum Transition: String {
        case first
        case second
        case third

        var color: Color {
            switch self {
            case .first: return .red
            case .second: return .green
            case .third: return .blue
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .first: return 50.0
            case .second: return 0.0
            case .third: return 25.0
            }
        }

        var dimension: CGFloat {
            switch self {
            case .first: return 100.0
            case .second: return 200.0
            case .third: return 150.0
            }
        }

        var rotationDegrees: CGFloat {
            switch self {
            case .first: return 0.0
            case .second: return 45.0
            case .third: return 180.0
            }
        }

        var rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
            switch self {
            case .first: return (0.0, 0.0, 0.0)
            case .second: return (1.0, 0.0, 0.0)
            case .third: return (0.0, 1.0, 0.0)
            }
        }
    }

    var animationEffect: AnimationEffect<Transition> {
        .init(
            index: 0,
            .easeInOut(duration: 0.5)
            .delay(1.0),
            state: .first,
            duration: 5.0
        )
        .with(
            .easeInOut(duration: 0.5)
            .delay(1.0),
            state: .second,
            duration: 5.0
        )
        .with(
            .easeInOut(duration: 0.5)
            .delay(1.0),
            state: .third,
            duration: 5.0
        )
    }
    @State private var timer: Timer? = .none
    @State private var startDate: Date? = .none
    @State private var elapsed: String = ""

    var body: some View {
        VStack {
            AnimationEffectView(effect: animationEffect) { state in
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hello, world!")
                            Text("state: \(state.rawValue)")
                            Text("elapsed: '\(elapsed)'")
                        }
                        Spacer()
                    }
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: state.cornerRadius)
                            .fill(state.color)

                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .padding(32.0)
                    }
                    .frame(width: state.dimension, height: state.dimension)
                    .rotation3DEffect(.degrees(state.rotationDegrees), axis: state.rotationAxis)
                }
                .frame(width: 320, height: 320)
            }
        }
        .padding()
        .onAppear {
            startDate = Date()
            timer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { timer in
                MainActor.assumeIsolated {
                    elapsed = startDate?.elapsedTimeInSeconds.with2Digits ?? ""
                }
            }
        }
    }
}

struct ContentViewV2_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewV2()
    }
}
