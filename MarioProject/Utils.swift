//
//  Utils.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit




enum Key: UInt16 {
    case arrLeft = 123
    case arrRight = 124
    case arrDown = 125
    case arrUp = 126
    case a = 0
}

enum Direction: Int {
    case right = 1
    case left = -1
}

extension CGSize {
    mutating func scale(i: CGFloat) {
        self.height *= i
        self.width *= i
    }
}
