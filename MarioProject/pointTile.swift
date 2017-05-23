//
//  pointTile.swift
//  MarioProject
//
//  Created by SoRush on 2/11/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class pointTile: SKSpriteNode {
    
    func update(_ currentTime: TimeInterval) {
        for body in (self.physicsBody?.allContactedBodies())! {
            
            let bodyNode = body.node!
//            let nodeUpBorder = CGRect(x: node.frame.minX - 5, y: node.frame.maxY, width: node.frame.width, height: 5)
            
            let nodePoint = CGPoint(x: bodyNode.frame.midX, y: bodyNode.frame.maxY+2)
            
            if bodyNode.name == "mario" && self.contains(nodePoint) {
                
                //let act1 = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 0.1)
                let act2 = SKAction.rotate(byAngle: CGFloat(M_PI)/6, duration: 0.1)
                let act3 = SKAction.rotate(byAngle: -CGFloat(M_PI)/3, duration: 0.1)
                let act4 = SKAction.rotate(byAngle: CGFloat(M_PI)/6, duration: 0.1)
                //let act5 = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 0.1)
                
                let actCollection = SKAction.sequence([act2,act3,act4])
                self.run(actCollection)
                
                print("ok")
            }
        }
    }
    
}
