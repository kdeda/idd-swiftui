//
//  CapsuleButtonStyle.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 11/19/22.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

import SwiftUI

/**
 A simple capsule button style
 */
public struct CapsuleButtonStyle: ButtonStyle {
    public init() {
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .frame(height: 18)
            .padding([.leading, .trailing], 8)
            .background(Color.white)
            .foregroundColor(Color.black)
            .cornerRadius(9)
            .overlay(
                RoundedRectangle(cornerRadius: 9)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct CapsuleButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
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
