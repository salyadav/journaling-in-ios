//
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
        if trackedTouch?.type != UITouch.TouchType.stylus {
            state = .cancelled
            return
        }
        if trackedTouch == nil {
            trackedTouch = touches.first
            strokePhase = .initialPoint
            initialTouchPoint = (trackedTouch?.location(in: self.view))!
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        state = .changed
        let newTouch = touches.first
        let newPoint = (newTouch?.location(in: view))!
        let previousPoint = (newTouch?.previousLocation(in: view))!
        if strokePhase == .initialPoint {
          if (((newPoint.x == initialTouchPoint.x)
            || (abs(newPoint.x - previousPoint.x) < xErrorMargin))
            && initialTouchPoint.y <= newPoint.y ) {
             strokePhase = .downStroke
          } else {
              state = .failed
          }
        } else if strokePhase == .downStroke {
           if ((newPoint.x == previousPoint.x || (abs(newPoint.x - previousPoint.x) < xErrorMargin)) && ((newPoint.y - initialTouchPoint.y)<20)) {
             if newPoint.y < previousPoint.y {
                strokePhase = .upStroke
             }
          } else {
               if((newPoint.y - initialTouchPoint.y)>20) {
                   if((newPoint.x - previousPoint.x)>xErrorMargin){
                        strokePhase = .rightStroke
                        cornerTouchPoint = newPoint
                      }
                }
           }
        } else if strokePhase == .upStroke {
             if newPoint.y > previousPoint.y {
                state = .failed
             }
        } else if strokePhase == .rightStroke {
            if ( newPoint.y == previousPoint.y ||  (abs(newPoint.y - previousPoint.y) < yErrorMargin) ) {
              if  newPoint.x < previousPoint.x {
                 state = .failed
              }
            } else {
                state = .failed
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let newTouch = touches.first
        let newPoint = (newTouch?.location(in: self.view))!
        guard newTouch == trackedTouch else {
          state = .failed
          return
        }
        if (state == .possible || state == .changed
            && (strokePhase == .rightStroke) && (newPoint.x > initialTouchPoint.x)) {
           state = .recognized
           finalTouchPoint = newPoint
        } else {
          state = .failed
        }
    }

    open override func reset() {
        trackedTouch = nil
        strokePhase = .notStarted
        super.reset()
    }
}
