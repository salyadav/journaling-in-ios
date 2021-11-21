```
//  UILGestureRecognizer.swift
//  PencilKitDraw
//
//  Created by Saranya Arun Menon on 11/13/21.
//  Copyright © 2021 Apple. All rights reserved.
//
import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

enum LmarkPhases {
    case notStarted
    case initialPoint
    case downStroke
    case upStroke
    case rightStroke
}

open class LGestureRecognizer : UIGestureRecognizer {

    var initialTouchPoint : CGPoint = CGPoint.zero
    var cornerTouchPoint: CGPoint = CGPoint.init(x: 0, y: 0)
    var finalTouchPoint: CGPoint = CGPoint.init(x: 0, y: 0)
    var trackedTouch : UITouch? = nil
    var strokePhase : LmarkPhases = .notStarted
    var xErrorMargin : CGFloat = 3
    var yErrorMargin : CGFloat = 10

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
       // state = .began
        print("began")
//        if touches.count != 1 {
//                    self.state = .failed
//                }

          // Capture the first touch and store some information about it.
          if self.trackedTouch == nil {
            // print("hellooo")
             self.trackedTouch = touches.first
             self.strokePhase = .initialPoint
             self.initialTouchPoint = (self.trackedTouch?.location(in: self.view))!

          }


    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {

        super.touchesMoved(touches, with: event)
        state = .changed
        print("moving")
           let newTouch = touches.first
           // There should be only the first touch.
//           guard newTouch == self.trackedTouch else {
//              self.state = .failed
//               print("failed")
//              return
//           }
           let newPoint = (newTouch?.location(in: self.view))!
           let previousPoint = (newTouch?.previousLocation(in: self.view))!
           if self.strokePhase == .initialPoint {
//               print("initial")
//               print("X")
//               print(newPoint.x)
//               print(initialTouchPoint.x)
//               print("Y")
//               print(newPoint.y)
//               print(initialTouchPoint.y)
//
              // Make sure the initial movement is down vertically
              if (((newPoint.x == initialTouchPoint.x) || (abs(newPoint.x - previousPoint.x) < xErrorMargin)) && initialTouchPoint.y <= newPoint.y ) {
                 self.strokePhase = .downStroke
//                  print("in here")
//                  print(initialTouchPoint.x)
//                  print(initialTouchPoint.y)
              } else {
//                  print("failed!")
//                  print("X")
//                  print(initialTouchPoint.x)
//                  print(newPoint.x)
//                  print("Y")
//                  print(initialTouchPoint.y)
//                  print(newPoint.y)
                  self.state = .failed
              }
           } else if self.strokePhase == .downStroke {
              // Always keep moving left to right.
               if ((newPoint.x == previousPoint.x || (abs(newPoint.x - previousPoint.x) < xErrorMargin)) && ((newPoint.y - initialTouchPoint.y)<20)) {
               //  print("in downstroke")
//                 print(newPoint.x)
//                 print(newPoint.y)
                 
                 // If the y direction changes, the gesture is moving up again.
                 // Otherwise, the down stroke continues.
                 if newPoint.y < previousPoint.y {
                    self.strokePhase = .upStroke
                 }

              }
               else {
                   print("hereee")
                   print(newPoint.x)
                   print(newPoint.y)
                   if((newPoint.y - initialTouchPoint.y)>20){

                       if((newPoint.x - previousPoint.x)>xErrorMargin){

                            self.strokePhase = .rightStroke
                            self.cornerTouchPoint = newPoint
                          }
//                           else {
//                              self.state = .failed
//                         }
                    }


               }

           } else if self.strokePhase == .upStroke {
                 // If the new x value is to the left, or the new y value
                 // changed directions again, the gesture fails.]
                 if  newPoint.y > previousPoint.y {
                    self.state = .failed
                 }
              }
           else if self.strokePhase == .rightStroke {
              // If the new x value is to the left, or the new y value
              // changed directions again, the gesture fails.]
               print("right strokee")
//               print(newPoint.x)
//               print(newPoint.y)
            if ( newPoint.y == previousPoint.y ||  (abs(newPoint.y - previousPoint.y) < yErrorMargin) ) {
              if  newPoint.x < previousPoint.x {
                 print("failing 1")
                 self.state = .failed
              }
            }
            else {
                // If the new x value is to the left, the gesture fails.
                self.state = .failed
           }
        }

    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        print("heya")

           let newTouch = touches.first
           let newPoint = (newTouch?.location(in: self.view))!
//        print(newPoint.x)
//        print(initialTouchPoint.x)
//        print(self.strokePhase)
           // There should be only the first touch.
           guard newTouch == self.trackedTouch else {
           // print("oh no")
              self.state = .failed
              return
           }

           // If the stroke was moving up and the final point is
           // above the initial point, the gesture succeeds.
        if ((self.state == .possible)||(self.state == .changed) && (self.strokePhase == .rightStroke) && (newPoint.x > initialTouchPoint.x)) {
               print("hey!")
               self.state = .recognized
               self.finalTouchPoint = newPoint
            } else {
              self.state = .failed
        }
    }

    open override func reset() {
        trackedTouch = nil
        strokePhase = .notStarted
        super.reset()
    }
}
```
