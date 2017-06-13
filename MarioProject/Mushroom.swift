//
//  Mushroom.swift
//  MarioProject
//
//  Created by SoRush on 3/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit


class Mushroom: SKSpriteNode, Updatable, Animatable {
    
    
    
    private var direction: Direction = .right
    var isBad: Bool = true
    
    convenience init(isBad: Bool, initDirection: Direction) {
        
        if isBad {
            self.init(texture: Mushroom.badMushMovingTextures.first)
        } else {
            self.init(texture: Mushroom.goodMushtexture)
            self.zPosition = -1
        }
        self.isBad = isBad
        self.direction = initDirection
    }

    func update(_ currentTime: TimeInterval) {
        
        guard self.physicsBody != nil else {
            return
        }
        
        let right = CGPoint(x: self.frame.maxX+5, y: self.frame.midY)
        let left = CGPoint(x: self.frame.minX-5, y: self.frame.midY)
        
        for body in self.physicsBody!.allContactedBodies() {
            
            if body.node!.contains(right) || body.node!.contains(left) {
                direction = Direction(rawValue: direction.rawValue * -1)!
                self.position.x += CGFloat(direction.rawValue * 5)
                self.autoMove(direction: direction)
            }
            
            if body.node!.name == "mario" {
                let collisionSound: NSSound
                
                if isBad {
                    if Mario.standard.didHit(node: self, with: .foot) {
                        collisionSound = NSSound(named: "kick")!
                        Mario.standard.IsJumping = true
                        self.removeFromParent()
                    } else {
                        collisionSound = NSSound(named: "warp")!
                        Mario.standard.changeMode(to: .normal)
                        
                    }
                    collisionSound.play()
                    
                } else {
                    collisionSound = NSSound(named: "item")!
                    collisionSound.play()
                    Mario.standard.changeMode(to: .superMario)
                    self.removeFromParent()
                }
            }
        }
    }
    
    
    
    //MARK:- Animations
    
    func beginInitAnimations() {
        if isBad {
            badMushMovingAnimation()
        } else {
            moveUpAnimation()
        }
    }
    
    private func autoMove(direction: Direction) {
        let actMove = SKAction.repeatForever(SKAction.move(by: CGVector(dx: 10 * direction.rawValue, dy: 0), duration: 0.1))
        self.run(actMove, withKey: "moving")
    }
    
    private func badMushMovingAnimation() {
        let actMove = SKAction.animate(with: Mushroom.badMushMovingTextures, timePerFrame: 0.1)
        self.run(SKAction.repeatForever(actMove))
        self.autoMove(direction: direction)
    }
    
    private func moveUpAnimation() {
        let actMoveUp = SKAction.move(by: CGVector(dx: 0, dy: self.frame.size.height), duration: 1)
        self.run(actMoveUp) {
            let phyics = SKPhysicsBody(rectangleOf: self.frame.size)
            phyics.restitution = 0
            phyics.isDynamic = true
            phyics.affectedByGravity = true
            phyics.allowsRotation = false
            self.physicsBody = phyics
            self.autoMove(direction: self.direction)
        }
    }
}
