//
//  ImageButton.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 8/1/23.
//  Copyright (C) 1997-2025 id-design, inc. All rights reserved.
//

import SwiftUI

public struct ImageButton: View {
    var systemName: String
    var action: () -> Void
    @State var isHovered = false

    public init(systemName: String, action: @escaping () -> Void) {
        self.systemName = systemName
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: systemName + ".fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(isHovered ? 0.2 : 1.0)
                if isHovered {
                    // when hovered bump it a notch
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(1.1)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hover in
            isHovered = hover
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Text("Folder 123")

            ImageButton(systemName: "eject") {
            }
            .frame(width: 12, height: 12)
            .padding(2)

            ImageButton(systemName: "delete.left") {
            }
            .frame(width: 14, height: 14)
            .padding(2)
        }
        .padding()
    }
}
