//
//  UIDogEarGestureRecognizer.swift
//  PencilKitDraw
//
//  Created by Saloni Yadav on 11/7/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

open class UIDogEarGestureRecognizer : UIGestureRecognizer {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        print(touches.count)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        print(touches.count)
    }
}
