//
//  Mario.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class Mario {
    
    
    // MARK:- Stored Properties
    
    private let sprite: SKSpriteNode
    private let idleTexture: SKTexture
    private let movingTextures: [SKTexture]
    private let climbingTextures: [SKTexture]
    private let jumpTexture: SKTexture
    
    private var isInTheAir = false
    private var isJumping = false {
        didSet{
            updateAnimation()
        }
    }
    private var isMoving = false {
        didSet{
            updateAnimation()
        }
    }
    
    private var xDirection = Direction.right { didSet{ self.sprite.xScale *= -1 }}
    
    // MARK:- Computed Properties
    
    var IsJumping: Bool {
        get { return self.isJumping }
        set {
            if newValue != self.isJumping {
                self.isJumping = newValue
            }
        }
    }
    
    var IsMoving: Bool {
        get { return self.isMoving }
        set {
            if newValue != self.isMoving {
                self.isMoving = newValue
            }
        }
    }
    var XDirection: Direction {
        get { return self.xDirection }
        set {
            if newValue != self.xDirection {
                self.xDirection = newValue
            }
        }
    }
    
    // MARK:- Main Methods
    
    func update(_ currentTime: TimeInterval) {
        
        if self.sprite.physicsBody!.velocity.dy == 0 && isInTheAir {
            isInTheAir = false
            sprite.removeAction(forKey: "jumping")
            if isMoving {
                animateMoving()
            }
        }
        
        if isJumping {
            if !isInTheAir {
                jump()
            } else {
                
            }
        }
        
        if IsMoving {
            move()
        }
    }
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        var walkingText: [SKTexture] = []
        var climbingText: [SKTexture] = []
        let jumpImage = NSImage(named: "mario-jump")!
        let idleImage = NSImage(named: "mario-idle")!
        
        jumpImage.size.scale(i: scale)
        jumpImage.size.scale(i: scale)
        
        
        
        for i in 1...3 {
            let image = NSImage(named: "mario-walk\(i)")!
            
            image.size.scale(i: scale)
            let texture = SKTexture(image: image)
            walkingText.append(texture)
        }
        for i in 1...2 {
            let image = NSImage(named: "mario-climb\(i)")!
            
            image.size.scale(i: scale)
            let texture = SKTexture(image: image)
            climbingText.append(texture)
        }
        
        self.jumpTexture = SKTexture(image: jumpImage)
        self.idleTexture = SKTexture(image: idleImage)
        self.movingTextures = walkingText
        self.climbingTextures = climbingText
        
    }
    
    // MARK:- Methods
    
    private func jump() {
        self.sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 500))
        self.isInTheAir = true
    }
    
    private func move() {
        if abs(self.sprite.physicsBody!.velocity.dx) < maxSpeed {
            self.sprite.physicsBody!.applyForce(CGVector(dx: XDirection.rawValue * 1000, dy: 0))
        }
    }
    
    
    // MARK:- Animations
    private func animateMoving() {
        let moving = SKAction.animate(with: movingTextures,
                                      timePerFrame: 0.08,
                                      resize: true,
                                      restore: true)
        self.sprite.run(SKAction.repeatForever(moving),
                        withKey: "moving")
        
        
    }
    
    private func animateJumping() {
        self.sprite.texture = jumpTexture
    }
    
    func updateAnimation() {
        switch true {
        case IsMoving && !isInTheAir:
            self.sprite.removeAllActions()
            animateMoving()
        case IsMoving && isInTheAir:
            self.sprite.removeAllActions()
            animateJumping()
        case !IsMoving && isInTheAir:
            self.sprite.removeAllActions()
            animateJumping()
        default:
            self.sprite.removeAllActions()
            self.sprite.texture = idleTexture
            
        }
    }
    

    
}
