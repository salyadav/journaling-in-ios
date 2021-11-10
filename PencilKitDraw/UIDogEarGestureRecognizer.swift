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
import simd
 
/**
 TODO: Right now we are not distinguishing between pen/touch. Need to ignore this gesture for pencil events.
 */
open class UIDogEarGestureRecognizer : UIGestureRecognizer {
    private var touchedPoints = [CGPoint]()
    private var trackedTouches: Set<UITouch> = []
    private var dogEaredFlag: Bool = false
    
    
    var start:(location:CGPoint, time:TimeInterval)?
    let minDistance:CGFloat = 25
    let minSpeed:CGFloat = 1000
    let maxSpeed:CGFloat = 6000
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print(self.trackedTouches.count)
       
        for touch in touches {
           if self.trackedTouches.count < 2 {
               self.trackedTouches.insert(touch)
           }
            
            if self.trackedTouches.count == 2 {
                state = .began
                if let touch = touches.first {
                  start = (touch.location(in:view), touch.timestamp)
              }
            }
    
        }
       
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
 
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
      super.touchesEnded(touches, with: event)

        
      if self.trackedTouches.count == 2 {
        var swiped = false
            if let touch = touches.first, let startTime = self.start?.time,
                let startLocation = self.start?.location {
                let location = touch.location(in:view)
                let dx = location.x - startLocation.x
                let dy = location.y - startLocation.y
                let distance = sqrt(dx*dx+dy*dy)
                // Check if the user's finger moved a minimum distance
                if distance > minDistance {
                    let deltaTime = CGFloat(touch.timestamp - startTime)
                    let speed = distance / deltaTime

                    // Check if the speed was consistent with a swipe
                    if speed >= minSpeed && speed <= maxSpeed {

                        // Determine the direction of the swipe
                        let x = abs(dx/distance) > 0.4 ? Int(sign(Float(dx))) : 0
                        let y = abs(dy/distance) > 0.4 ? Int(sign(Float(dy))) : 0
                    swiped = true
                    if x == -1, y == 1 {
                        state = .ended
                    }
                    else {
                        state = .failed
                    }
                 }
                }
            }
         
            start = nil
       
    }
        self.trackedTouches = []
    }
}
