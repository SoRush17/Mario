//
//  Mario.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class Mario {
    
    let speed: CGFloat = 200
    let sprite: SKSpriteNode
    
    var isInTheAir = false
    
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
    }
    
    func Jump() {
        if !isInTheAir {
            self.sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 500))
            isInTheAir = true
        }
    }
    
    func move(in direction: Direction) {
        self.sprite.physicsBody!.velocity.dx = speed * CGFloat(direction.rawValue)
    }
    
    func update(_ currentTime: TimeInterval) {
        if self.sprite.physicsBody!.velocity.dy == 0 {
            isInTheAir = false
        }
    }
}
