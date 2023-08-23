//
//  AnimationTimers.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 8/21/23.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import Foundation
import Log4swift

public class AnimationTimers: ObservableObject {
    private var timersByTag: [Int: AnimationTimer]

    public init() {
        timersByTag = [:]
    }

    deinit {
        Log4swift[Self.self].info("timersByTag: '\(timersByTag.count)'")
    }

    public func timer(index: Int) -> AnimationTimer {
        guard let timer = timersByTag[index]
        else {
            let timer = AnimationTimer()
            timer.tag = index
            timersByTag[index] = timer
            return timer
        }
        return timer
    }
}
