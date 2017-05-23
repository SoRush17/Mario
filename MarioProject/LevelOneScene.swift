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
    var backGround: SKSpriteNode!
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backGround = self.childNode(withName: "//backGround")! as! SKSpriteNode
        let marioSprite = self.childNode(withName: "//mario")! as! SKSpriteNode
        
        mario = Mario(sprite: marioSprite)
        
        
        for item in self.children {

            if let item = item as? SKSpriteNode {
                        if item.name!.contains("tileSet")  {
                    let phys = SKPhysicsBody(texture: item.texture!, size: item.size)
                    phys.pinned = true
                    phys.affectedByGravity = false
                    phys.allowsRotation = false
                    phys.isDynamic = false
                    if item.xScale < 0 {
                        item.xScale *= -1
                        item.physicsBody = phys
                        item.xScale *= -1
                    } else {
                        item.physicsBody = phys
                    }
                    
                }
            }
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        mario.update(currentTime)
        
        
        
        if mario.XPosition + 1023/2 < backGround.frame.maxX {
            if mario.XPosition > self.camera!.position.x {
                self.camera!.position.x = self.mario.XPosition
            }
        }
        
        
        
        for node in self.children {
            if node.name == "pointTile" {
                (node as! pointTile).update(currentTime)
            }
            
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
