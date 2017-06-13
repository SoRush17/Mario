//
//  Utils.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit


protocol Updatable {
    func update(_ currentTime: TimeInterval)
}

protocol Animatable {
    func beginInitAnimations()
}

enum Key: UInt16 {
    case arrLeft = 123
    case arrRight = 124
    case arrDown = 125
    case arrUp = 126
    case a = 0
}

enum Direction: Int {
    case right = 1
    case left = -1
}




extension CGSize {
    func scaled(to: CGFloat) -> CGSize {
        return CGSize(width: self.width * to, height: self.height * to)
    }
    
}

extension SKTexture {
    convenience init(imageNamed: String, scale: CGFloat) {
        let image = NSImage(named: imageNamed)!
        image.size = image.size.scaled(to: scale)
        self.init(image: image)
    }
}


extension Mario {
    
    enum HitPoint {
        case head
        case foot
    }
    
    enum MarioMode {
        case normal
        case superMario
    }
    
    static let superPhysics: SKPhysicsBody = {
        let phys = SKPhysicsBody(rectangleOf: Mario.idleSuperTexture.size())
        phys.affectedByGravity = true
        phys.isDynamic = true
        phys.allowsRotation = false
        phys.pinned = false
        phys.mass = 1
        phys.restitution = 0
        phys.friction = 0.4
        phys.linearDamping = 0.2
        return phys
        }()
    
    static let normalPhysics: SKPhysicsBody = {
        let phys = SKPhysicsBody(rectangleOf: Mario.idleTexture.size())
        phys.affectedByGravity = true
        phys.isDynamic = true
        phys.allowsRotation = false
        phys.pinned = false
        phys.mass = 1
        phys.restitution = 0
        phys.friction = 0.2
        phys.linearDamping = 0.3
        return phys
    }()
    
    
    static let idleTexture = SKTexture(imageNamed: "mario-idle", scale: texturesScale)
    static let idleSuperTexture = SKTexture(imageNamed: "superMario-idle", scale: texturesScale)
    
    static let jumpTexture = SKTexture(imageNamed: "mario-jump", scale: texturesScale)
    static let jumpSuperTexture = SKTexture(imageNamed: "superMario-jump", scale: texturesScale)
    
    static let movingTextures =
        [SKTexture(imageNamed: "mario-walk1", scale: texturesScale),
         SKTexture(imageNamed: "mario-walk2", scale: texturesScale),
         SKTexture(imageNamed: "mario-walk3", scale: texturesScale)]
    
    static let movingSuperTextures =
        [SKTexture(imageNamed: "superMario-walk1", scale: texturesScale),
         SKTexture(imageNamed: "superMario-walk2", scale: texturesScale),
         SKTexture(imageNamed: "superMario-walk3", scale: texturesScale)]
    
    
    
    static let climbingTextures =
        [SKTexture(imageNamed: "mario-climb1", scale: texturesScale),
         SKTexture(imageNamed: "mario-climb2", scale: texturesScale)]
    
    static let climbingSuperTextures =
        [SKTexture(imageNamed: "superMario-climb1", scale: texturesScale),
         SKTexture(imageNamed: "superMario-climb2", scale: texturesScale)]
}


extension Mushroom {
    static let goodMushtexture = SKTexture(imageNamed: "mushroom-1", scale: texturesScale)
    static let badMushMovingTextures = [SKTexture(imageNamed: "badMush-move01", scale: texturesScale),
                                        SKTexture(imageNamed: "badMush-move02", scale: texturesScale)]
}

extension QTile {
    static let coinRotationTextures =
        [SKTexture(imageNamed: "coin-rotation1", scale: 2.5),
         SKTexture(imageNamed: "coin-rotation2", scale: 2.5),
         SKTexture(imageNamed: "coin-rotation3", scale: 2.5),
         SKTexture(imageNamed: "coin-rotation4", scale: 2.5)]
    
    static let glowTextures =
        [SKTexture(imageNamed: "qTile1"),
         SKTexture(imageNamed: "qTile2"),
        SKTexture(imageNamed: "qTile3")]
}
