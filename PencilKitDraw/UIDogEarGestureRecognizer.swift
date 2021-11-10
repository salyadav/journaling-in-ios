//
//  UIDogEarGestureRecognizer.swift
//  PencilKitDraw
//
//  Created by Saloni Yadav on 11/7/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

/**
 TODO: Right now we are not distinguishing between pen/touch. Need to ignore this gesture for pencil events.
 */
open class UIDogEarGestureRecognizer : UIGestureRecognizer {
    private var touchedPoints = [CGPoint]()
    private var trackedTouches: Set<UITouch> = []
    private var dogEaredFlag: Bool = false
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        for touch in touches {
           if self.trackedTouches.count < 2 {
               self.trackedTouches.insert(touch)
           }
        }
        state = .began
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)g
        if self.trackedTouches.count == 2 {
            dogEaredFlag = true
            state = .changed
        }

    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        if dogEaredFlag {
            state = .ended
        } else {
            state = .failed
        }
        self.trackedTouches = []
    }
}
