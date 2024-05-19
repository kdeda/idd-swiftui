//
//  Button+Extensions.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 4/9/21.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

import SwiftUI

/// Convenience to create a Button with an SF Symbol
extension Button<Image> {
    public init(systemImage: String, action: @escaping () -> Void) {
        self.init(
            action: action,
            label: {
                Image(systemName: systemImage)
            }
        )
    }
}

struct Button_Extensions_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Button {
                // Action
            } label: {
                Image(systemName: "eject.fill")
            }
            .padding()

            Button(systemImage: "delete.left.fill") {
                // Action
            }
            .padding()
            .border(.yellow)
        }
        .padding()
    }
}
