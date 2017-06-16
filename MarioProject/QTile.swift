//
//  QTile.swift
//  MarioProject
//
//  Created by SoRush on 2/11/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit
import CoreMedia


class QTile: SKSpriteNode, Updatable, Animatable {
    

    private var hittedTimes: Int = 0
    private var hasPoint = true
    
    func beginInitAnimations() {
        startGlow()
    }
    
    func update(_ currentTime: TimeInterval) {
        
        
        if hasPoint && Mario.standard.didHit(node: self, with: .head) {
            
            hittedTimes += 1
            
            
            let act1 = SKAction.move(by: CGVector(dx: 0, dy: 20), duration: 0.1)
            let act2 = SKAction.move(by: CGVector(dx: 0, dy: -20), duration: 0.1)
            
            let actCollection = SKAction.sequence([act1,act2])
            
            if self.userData?.object(forKey: "tileContent") as? Int == 1 {
                SoundManager.getItem.stop()
                SoundManager.getItem.play()
                self.run(actCollection) {
                    self.makeMushroom()
                }
            } else {
                
                SoundManager.coin.stop()
                SoundManager.coin.play()
                self.makeCoin()
                (self.scene! as! WorldDelegate).increasePoints(by: 200)
                self.run(actCollection)
            }
            
            if hittedTimes == 1 {
                hasPoint = false
                self.removeAction(forKey: "glowing")
                self.texture = SKTexture(imageNamed: "coinBlock-hitted")
            }
        }
    }
    
    func makeMushroom() {
        let mushroom = Mushroom(isBad: false, initDirection: .right)
        mushroom.position = self.position
        self.scene!.addChild(mushroom)
    }
    
    func makeCoin() {
        
        let actThrow1 = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.2)
        let actThrow2 = SKAction.move(by: CGVector(dx: 0, dy: -70), duration: 0.2)
        let actThrow = SKAction.sequence([actThrow1,actThrow2])
        
        let rotation = SKAction.animate(with: QTile.coinRotationTextures, timePerFrame: 0.1, resize: true, restore: true)
        let coinAnimation = SKAction.group([actThrow,rotation])
        
        let coin = SKSpriteNode(texture: QTile.coinRotationTextures[0])
        coin.zPosition = -1
        self.addChild(coin)
        coin.run(coinAnimation) {
            let pos = CGPoint(x: self.frame.midX, y: self.frame.maxY)
            
            (self.scene! as! WorldDelegate).showLabelPoint(point: 200, at: pos)
            coin.removeAllActions()
            coin.removeFromParent()
        }
    }
    
    
    
    private func startGlow() {
        let action = SKAction.animate(with: QTile.glowTextures, timePerFrame: 0.15)
        self.run(SKAction.repeatForever(action), withKey: "glowing")
    }
}
