//
//  Untitled.swift
//  idd-swiftui
//
//  Created by Klajd Deda on 4/27/25.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

import SwiftUI

/**
 A simple circle button style
 We assume the content is an image
 */
public struct CircleButtonStyle: ButtonStyle {
    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(6)
            .contentShape(Rectangle())
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 0.5))
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CircleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("Bla Bla ...")
            Button(action: {
                // viewStore.send(.stopMeasuring(viewStore.folderURL))
            }) {
                Text("stop")
            }
            .buttonStyle(CapsuleButtonStyle())
            .help("Will stop measuring this folder")

            Button(action: {
                // configuration.tip.invalidate(reason: .tipClosed)
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .foregroundColor(.accentColor)
            }
            // .buttonStyle(BorderlessButtonStyle())
            .buttonStyle(CircleButtonStyle())
        }
        .padding(20)
        .frame(width: 480, height: 320)
        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .light)

        VStack {
            Text("Bla Bla ...")
            Spacer()
            Button(action: {
                // viewStore.send(.stopMeasuring(viewStore.folderURL))
            }) {
                Text("stop")
            }
            .buttonStyle(CapsuleButtonStyle())
            .help("Will stop measuring this folder")
        }
        .padding(20)
        .frame(width: 480, height: 320)
        .background(Color.windowBackgroundColor)
        .environment(\.colorScheme, .dark)
    }
}
