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
        
        
        let sign = CGFloat(direction.rawValue)
        let side = CGPoint(x: (self.position.x + sign * self.frame.width + sign * 10), y: self.frame.midY)
        
        
        for body in self.physicsBody!.allContactedBodies() {
            
            if body.node!.contains(side) {
                direction = Direction(rawValue: direction.rawValue * -1)!
                self.position.x += CGFloat(direction.rawValue * 6)
                self.autoMove(direction: direction)
            }
            
            if body.node!.name == "mario" {
                let collisionSound: NSSound
                
                if isBad {
                    if Mario.standard.didHit(node: self, with: .foot) {
                        collisionSound = SoundManager.kick
                        Mario.standard.jump(withPower: 600)
                        (self.scene! as! WorldDelegate).increasePoints(by: 100,isCoin: false)
                        (self.scene! as! WorldDelegate).showLabelPoint(point: 100, at: self.position)
                        self.removeFromParent()
                    } else {
                        collisionSound = SoundManager.warp
                        Mario.standard.changeMode(to: .normal)
                    }
                    collisionSound.play()
                    
                } else {
                    collisionSound = SoundManager.powerUp
                    collisionSound.play()
                    (self.scene! as! WorldDelegate).increasePoints(by: 1000,isCoin: false)
                    (self.scene! as! WorldDelegate).showLabelPoint(point: 1000, at: self.position)
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
        let actMove = SKAction.repeatForever(SKAction.move(by: CGVector(dx: mushSpeed * direction.rawValue, dy: 0), duration: 0.1))
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
