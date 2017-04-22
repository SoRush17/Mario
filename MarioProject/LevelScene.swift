//
//  LevelScene.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class LevelScene: SKScene {
    
    var mario: Mario!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        print(self.physicsWorld.gravity)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        let marioSprite = self.childNode(withName: "//mario")! as! SKSpriteNode
        mario = Mario(sprite: marioSprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        mario.update(currentTime)
    }
    
    override func keyUp(with event: NSEvent) {
        
        if let key = Keys(rawValue: event.keyCode) {
            switch key {
            case .up:
                isUpHolded = false
            default:
                xDirectionHolded = .idle
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if let key = Keys(rawValue: event.keyCode) {
            switch key {
            case .up:
                isUpHolded = true
                mario.Jump()
            case .right:
                xDirectionHolded = .right
            case .left:
                xDirectionHolded = .left
            }
        }
    }
}
