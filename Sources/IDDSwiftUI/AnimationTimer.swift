//
//  AnimationTimer.swift
//  IDDSwiftUI
//
//  Created by Klajd Deda on 12/22/22.
//  Copyright (C) 1997-2023 id-design, inc. All rights reserved.
//

import Foundation
import Log4swift

/**
 Given a particular non repeating animation sequence, repeat it after a given interval.
 This type exists to we can compose Animations.

 Sat we want to combine 2 animations.

 1 do something with a shortDuration.
 2 after that do something with longerDuration.

 Than we want to repeat this forever.
 */
public final class AnimationTimer: ObservableObject {
    // debug support
    var tag: Int = 0
    private var task: Task<Void, Never>?
    private var timer: Timer? = .none

    var objectID: String {
        ObjectIdentifier(self).debugDescription
    }

    deinit {
        if self.tag == 5 {
            Log4swift[Self.self].info("index: '\(self.tag)' self: '\(objectID)'")
        }
        self.task?.cancel()
        self.task = nil
        timer?.invalidate()
        timer = .none
    }

    /**
     This seems to stutter a bit more than the one implemented using a Timer
     */
    private func _task_repeatEvery(timeInterval: TimeInterval, _ animation: @escaping () -> Void) {
        let durationInMilliseconds = UInt64(timeInterval * 1000)

        // Log4swift[Self.self].info("start index: '\(self.tag)'")
        self.task?.cancel()
        self.task = Task {
            while !Task.isCancelled {
                var startDate = Date()

                await MainActor.run {
                    animation()
                }
                let scheduleTime = startDate.elapsedTimeInMilliseconds - Double(durationInMilliseconds)
                if scheduleTime > 25.0 {
                    Log4swift[Self.self].info("start index: '\(self.tag)' scheduled in: '\(scheduleTime.with2Digits) ms'")
                }
                try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * durationInMilliseconds)
                let extras = startDate.elapsedTimeInMilliseconds - Double(durationInMilliseconds)
                if extras > 100.0 {
                    // this can get large and than we stutter
                    // using timers and sleep is not a good idea
                    // the problem is in the nature of the animation function
                    //
                    Log4swift[Self.self].info("start index: '\(self.tag)' was supposed to sleep for: '\(durationInMilliseconds) ms' but slept an extra: '\(extras.with2Digits) ms'")
                }
                startDate = Date()
            }
        }
        // Log4swift[Self.self].info("index: '\(self.tag)' task: '\(task)' self: '\(objectID)'")
    }

    /**
     Will repeat the animation every timeInterval seconds.
     The timeInterval should be the sum of all the animation durations.
     This code depends on keeping the main thread not blocked for too long.
     If it is we will see the warning that we 'was supposed to sleep for ...'
     */
    public func repeatEvery(timeInterval: TimeInterval, _ animation: @escaping () -> Void) {
        guard timer == nil
        else { return }

        var startDate = Date()
        let durationInMilliseconds = UInt64(timeInterval * 1000)

        if self.tag == 5 {
            Log4swift[Self.self].info("start index: '\(self.tag)' self: '\(objectID)'")
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: Double(durationInMilliseconds) / 1000.0,
            repeats: true
        ) { [weak self] _ in
            // we are called in the main thread
            //
            guard let self = self
            else { return }

            // Log4swift[Self.self].info("tag: '\(self.tag)' self: '\(objectID)'")
            animation()
            let extras = (startDate.elapsedTimeInSeconds - timeInterval) * 1000.0
            if extras > 100.0 {
                // this can get large and than we stutter
                // using timers and sleep is not a good idea
                // the problem is in the nature of the animation function
                //
                if self.tag == 5 {
                    // warning
                    Log4swift[Self.self].info("start index: '\(self.tag)' self: '\(self.objectID)' was supposed to sleep for: '\(durationInMilliseconds) ms' but slept an extra: '\(extras.with2Digits) ms'")
                }
            }
            startDate = Date()
        }
        timer?.fire()
    }

    func stop() {
        if self.tag == 5 {
            Log4swift[Self.self].info("index: '\(self.tag)' self: '\(objectID)'")
        }
        self.task?.cancel()
        self.task = nil
        timer?.invalidate()
        timer = .none
    }
}
