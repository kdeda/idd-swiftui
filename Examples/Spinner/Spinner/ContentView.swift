//
//  ContentView.swift
//  Spinner
//
//  Created by Klajd Deda on 12/9/22.
//

import SwiftUI
import IDDSwiftUI

struct ContentView: View {
    @State var isAnimating = false
    @State var counter: Int = 0

    private func workOnMainThread() {
        let startDate = Date()
        let items = (0 ... 10_000_000).map {
            let value = Double($0)
            return ((value*value) / value * 1.1234567891247587964)
        }
        Log4swift[Self.self].info("\(#function) items: '\(items.count)' completed in: \(startDate.elapsedTime)")
    }

    var body: some View {
        BodyCount.timed("ContentView") {
            VStack {
                HStack {
                    Text("Spinner")
                    Spacer()
                }
                HStack(alignment: .top) {
                    Spinner(isAnimating: isAnimating)
                        .frame(width: 128, height: 128)
                        .foregroundColor(.gray)
                        .border(Color.yellow)
                    ProgressView()
                        .scaleEffect(4, anchor: .center)
                        .frame(width: 128, height: 128)
                        .progressViewStyle(.circular)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .border(Color.yellow)
                    Spacer()
                    VStack {
                        HStack {
                            Button(action: {
                                workOnMainThread()
                                counter += 1
                            }) {
                                Label("Incrememt", systemImage: "plus")
                            }
                            Spacer()
                            Text("\(counter)")
                            Spacer()
                            Button(action: {
                                workOnMainThread()
                                counter -= 1
                            }) {
                                Label("Decrement", systemImage: "minus")
                            }
                        }
                    }
                    .padding()
                    .border(Color.yellow)
                }
                HStack {
                    Text("SpinnerV0")
                    Spacer()
                }
                HStack {
                    SpinnerV0(isAnimating: isAnimating)
                        .frame(width: 128, height: 128)
                        .foregroundColor(.gray)
                        .border(Color.yellow)
                    ProgressView()
                        .scaleEffect(4, anchor: .center)
                        .frame(width: 128, height: 128)
                        .progressViewStyle(.circular)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .border(Color.yellow)
                    Spacer()
                }
                
                VStack {
                    ForEach(0 ..< 3) { _ in
                        HStack {
                            if isAnimating {
                                Group {
                                    Spinner(isAnimating: isAnimating)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(Color.gray)
                                    Spinner(isAnimating: isAnimating)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(Color.gray)
                                    Spinner(isAnimating: isAnimating)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(Color.gray)
                                    Spinner(isAnimating: isAnimating)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(Color.gray)
                                    Spinner(isAnimating: isAnimating)
                                        .frame(width: 48, height: 48)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            Group {
                                Spinner(isAnimating: isAnimating)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.gray)
                                Spinner(isAnimating: isAnimating)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.gray)
                                Spinner(isAnimating: isAnimating)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.gray)
                                Spinner(isAnimating: isAnimating)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.gray)
                                Spinner(isAnimating: isAnimating)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                        .frame(height: 50)
                        .border(Color.yellow)
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isAnimating.toggle()
                    }) {
                        Text("\(isAnimating ? "Stop" : "Start") Animating")
                    }
                }
            }
            .padding(20)
            .frame(minWidth: 320, minHeight: 480)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(minWidth: 320, minHeight: 640)
    }
}
