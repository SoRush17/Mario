//
//  LevelOneScene.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    
    private let mario = Mario.standard
    var backGround: SKSpriteNode!
    let music = NSSound(named: "level-01")!
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
//        music.play()
        
        
        
        self.backGround = self.childNode(withName: "//backGround")! as! SKSpriteNode
        self.mario.sprite.position = CGPoint(x: -150, y: -272)
        self.addChild(mario.sprite)
        
        
        for node in self.children {
            if node.name!.contains("tileSet") {
                let tileSet = node as! SKSpriteNode
                let phys = SKPhysicsBody(texture: tileSet.texture!, alphaThreshold: 10, size: tileSet.size)
                
                phys.restitution = 0
                phys.pinned = true
                phys.affectedByGravity = false
                phys.allowsRotation = false
                phys.isDynamic = false
                tileSet.physicsBody = phys
                
            }
            
            (node as? Animatable)?.beginInitAnimations()
        }
        
        
    }
    
    override func addChild(_ node: SKNode) {
        super.addChild(node)
        (node as? Animatable)?.beginInitAnimations()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        mario.update(currentTime)
        
        if mario.XPosition + 1023/2 < backGround.frame.maxX {
            if mario.XPosition > self.camera!.position.x {
                self.camera!.position.x = self.mario.XPosition
            }
        }
        
        for node in self.children {
            (node as? Updatable)?.update(currentTime)
            
            if node.frame.maxX < mario.XPosition - 1025/2 {
                node.removeFromParent()
            }
        }
        
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
