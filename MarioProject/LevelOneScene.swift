//
//  LevelOneScene.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    
    var mario: Mario!
    var heldKeys: [Key] = []
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        let marioSprite = self.childNode(withName: "//mario")! as! SKSpriteNode
        mario = Mario(sprite: marioSprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        mario.update(currentTime)
    }
    
    override func keyUp(with event: NSEvent) {
        if let key = Key(rawValue: event.keyCode) {
            switch key {
            case .arrUp:
                mario.IsJumping = false
            case .arrRight:
                mario.IsMoving = false
            case .arrLeft:
                mario.IsMoving = false
            default:
                break
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if let key = Key(rawValue: event.keyCode) {
            switch key {
            case .arrUp:
                mario.IsJumping = true
            case .arrRight:
                mario.XDirection = .right
                mario.IsMoving = true
            case .arrLeft:
                mario.XDirection = .left
                mario.IsMoving = true
            default:
                break
                
            }
        }
    }
}
