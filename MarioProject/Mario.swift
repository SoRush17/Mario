//
//  Mario.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class Mario {
    
    private let maxSpeed: CGFloat = 250
    private let sprite: SKSpriteNode
    
    private var xDirection: Direction
    private var isInTheAir = false
    
    private var XDirection: Direction {
        set {
            if newValue != self.xDirection {
                self.xDirection = newValue
            }
        }
        get { return self.xDirection }
    }
    
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        self.xDirection = .right
    }
    
    private func jump() {
        self.sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 500))
        isInTheAir = true
    }
    
    private func move() {
        self.sprite.physicsBody!.applyForce(CGVector(dx: xDirection.rawValue * 1000, dy: 0))
    }
    
    
    
    func update(_ currentTime: TimeInterval, heldKeys: [Key]) {
        
        if self.sprite.physicsBody!.velocity.dy == 0 {
           isInTheAir = false
        }
        
        if abs(sprite.physicsBody!.velocity.dx) > 200 {
            self.sprite.physicsBody!.velocity.dx = maxSpeed * CGFloat(XDirection.rawValue)
        }
        
        if heldKeys.contains(.right) {
            self.XDirection = .right
            self.move()
        }
        
        if heldKeys.contains(.left) {
            self.XDirection = .left
            self.move()
        }
        
        if heldKeys.contains(.up) && !isInTheAir {
            self.jump()
        }
        
    }
}
