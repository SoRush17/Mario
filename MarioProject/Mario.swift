//
//  Mario.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit


class Mario: Updatable {
    
    static let standard = Mario(sprite: SKSpriteNode(texture: Mario.idleTexture))
    
    
    // MARK:- Computed Properties
    
    var movingTextures: [SKTexture] {
        return mode == .normal ? Mario.movingTextures : Mario.movingSuperTextures
    }
    
    var jumpTexture: SKTexture {
        return mode == .normal ? Mario.jumpTexture : Mario.jumpSuperTexture
    }
    
    var idleTexture: SKTexture {
        return mode == .normal ? Mario.idleTexture : Mario.idleSuperTexture
    }
    
    var physics: SKPhysicsBody {
        return mode == .normal ? Mario.normalPhysics : Mario.superPhysics
    }
    
    // MARK:- Sprite textures
    let sprite: SKSpriteNode
    private let head: SKNode
    private let foots: SKNode
    
    
    private var mode: MarioMode = .normal
    
    private var isInTheAir = false {
        didSet {
            if isInTheAir {
                sprite.removeAction(forKey: "moving")
                animateJumping()
            } else {
                if isMoving {
                    animateMoving()
                } else {
                    goIdle()
                }
            }
        }
    }
    
    private var isJumping = false
    
    private var isMoving = false {
        didSet {
            if !IsInTheAir {
                if isMoving {
                    self.animateMoving()
                } else {
                    sprite.removeAction(forKey: "moving")
                    goIdle()
                }
            }
        }
    }
    
    private var xDirection = Direction.right { didSet{ self.sprite.xScale *= -1 }}
    
    // MARK:- Computed Properties
    
    var IsInTheAir: Bool {
        get { return self.isInTheAir }
        set {
            if newValue != self.isInTheAir {
                self.isInTheAir = newValue
            }
        }
    }
    
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
    
    var XPosition: CGFloat {
        return self.sprite.position.x
    }
    
    // MARK:- Main Methods
    
    func update(_ currentTime: TimeInterval) {
        
        
        if sprite.physicsBody!.allContactedBodies().contains(where: { phy in
            if let node = phy.node {
                return node.intersects(foots)
            }; return false
        })
        
        {
            IsInTheAir = false
            self.sprite.physicsBody?.velocity.dy = 0
        }
        
        if isJumping && !isInTheAir {
            self.jump()
        }
        
        if IsMoving {
            self.move()
        }
    }
    
    private init(sprite: SKSpriteNode) {
        self.sprite = sprite
        self.sprite.physicsBody = Mario.normalPhysics
        self.sprite.name = "mario"
        self.head = SKSpriteNode(color: .yellow, size: CGSize(width: self.sprite.size.width - 10, height: 2))
        self.foots =  SKSpriteNode(color: .yellow, size: CGSize(width: self.sprite.size.width - 10, height: 2))
        
        head.position.y = 28.5
        foots.position.y = -28.5
        self.sprite.addChild(head)
        self.sprite.addChild(foots)
    }
    
    // MARK:- Methods
    
    func jump() {
        self.sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: jumpPower))
        let jumpSound = NSSound(named: "jump")!
        jumpSound.stop()
        jumpSound.play()
        self.isInTheAir = true
    }
    
    private func move() {
        if abs(self.sprite.physicsBody!.velocity.dx) < maxSpeed {
            self.sprite.physicsBody!.applyForce(CGVector(dx: XDirection.rawValue * 1000, dy: 0))
        }
    }
    
    func didHit(node: SKNode, with hitPoint: HitPoint) -> Bool {
        return hitPoint == .head ? head.intersects(node) : foots.intersects(node)
    }
    
    func changeMode(to mode: Mario.MarioMode) {
        if self.mode == mode && mode == .normal {
            self.sprite.removeFromParent()
        } else {
            self.goIdle()
            self.sprite.scene?.physicsWorld.speed = 0
            
            let anim1 =
                mode == .superMario ? SKAction.scaleY(to: 1.4, duration: 0) : SKAction.fadeOut(withDuration: 0)
            let anim2 =
                mode == .superMario ? SKAction.scaleY(to: 1, duration: 0) : SKAction.fadeIn(withDuration: 0)
            let wait = SKAction.wait(forDuration: 0.1)
            
            let actSequence = SKAction.sequence([anim1,wait,anim2,wait,anim1,wait,anim2])
            
            self.sprite.run(actSequence) {
                self.mode = mode
                self.goIdle()
                self.sprite.physicsBody?.velocity = CGVector.zero
                self.sprite.scene?.physicsWorld.speed = 1
                self.sprite.physicsBody = self.physics
                self.foots.position.y = -self.sprite.frame.height/2 - 3
                self.head.position.y = self.sprite.frame.height/2 + 3
            }
        }
    }
    
    // MARK:- Animations
    
    private func goIdle() {
        self.sprite.size = idleTexture.size()
        self.sprite.texture = idleTexture
    }
    
    private func animateMoving() {
        
        let moving = SKAction.animate(with: self.movingTextures, timePerFrame: 0.08,
                                                 resize: true, restore: true)
        self.sprite.run(SKAction.repeatForever(moving),
                        withKey: "moving")
    }
    
    private func animateJumping() {
        self.sprite.size = jumpTexture.size()
        self.sprite.texture = jumpTexture
    }
    
    private func animateClimbing() {
        let actClimbing = SKAction.animate(with: self.movingTextures, timePerFrame: 0.08,
                                                    resize: true, restore: true)
        self.sprite.run(SKAction.repeatForever(actClimbing),
                        withKey: "climbing")
    }
    
}
