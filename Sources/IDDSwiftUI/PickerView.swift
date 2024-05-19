//
//  PickerView.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 5/19/24.
//  Copyright (C) 1997-2024 id-design, inc. All rights reserved.
//

import SwiftUI

public struct PickerView<Value, Content>: View where Value: Identifiable, Value: Hashable, Content: View {
    var items: [Value]
    @Binding var selectedItem: Value
    let itemView: (_ item: Value) -> Content

    public init(
        items: [Value],
        selectedItem: Binding<Value>,
        @ViewBuilder itemView: @escaping (_ item: Value) -> Content
    ) {
        self._selectedItem = selectedItem
        self.items = items
        self.itemView = itemView
    }

    public var body: some View {
        Picker(
            selection: $selectedItem,
            label: EmptyView(),
            content: {
                ForEach(items) { type in
                    itemView(type)
                        .tag(type)
                }
            }
        )
    }
}

public protocol PickerItemContent {
    var isSeparator: Bool { get }
    var title: String { get }
}

/**
 Reusable component to be used in a PickerView
 */
public struct PickerItemView<Value>: View where Value: PickerItemContent, Value: Hashable {
    public var item: Value

    public init(item: Value) {
        self.item = item
    }

    public var body: some View {
        switch item.isSeparator {
        case true:
            Divider()
        case false:
            Text(item.title)
                .font(.subheadline)
        }
    }
}
