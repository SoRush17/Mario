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
    
    private var movingTextures: [SKTexture] {
        return mode == .normal ? Mario.movingTextures : Mario.movingSuperTextures
    }
    
    private var jumpTexture: SKTexture {
        return mode == .normal ? Mario.jumpTexture : Mario.jumpSuperTexture
    }
    
    private var idleTexture: SKTexture {
        return mode == .normal ? Mario.idleTexture : Mario.idleSuperTexture
    }
    
    private var climbingTextures: [SKTexture] {
        return mode == .normal ? Mario.climbingTextures : Mario.climbingSuperTextures
    }
    
    private var physics: SKPhysicsBody {
        return mode == .normal ? Mario.normalPhysics : Mario.superPhysics
    }
    
    // MARK:- Sprite textures
    let sprite: SKSpriteNode
    var canUpdate = true
    
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
        
        guard canUpdate else { return }
        
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
        self.head = SKSpriteNode(color: .clear, size: CGSize(width: self.sprite.size.width - 10, height: 2))
        self.foots =  SKSpriteNode(color: .clear, size: CGSize(width: self.sprite.size.width - 10, height: 2))
        
        head.position.y = 28.5
        foots.position.y = -28.5
        self.sprite.addChild(head)
        self.sprite.addChild(foots)
    }
    
    // MARK:- Methods
    
    func jump(withPower power: CGFloat = jumpPower) {
        self.sprite.physicsBody!.applyImpulse(CGVector(dx: 0, dy: power))
        SoundManager.Jump.stop()
        SoundManager.Jump.play()
        self.isInTheAir = true
    }
    
    private func move() {
        if abs(self.sprite.physicsBody!.velocity.dx) < maxSpeed {
            self.sprite.physicsBody!.applyForce(CGVector(dx: XDirection.rawValue * 1000, dy: 0))
        }
    }
    
    func beginEndAnimationFromPole(at height: CGFloat, to position: CGPoint) {
        self.sprite.removeAllActions()
        self.sprite.physicsBody!.pinned = true
        self.sprite.physicsBody!.isDynamic = false
        let act1 = SKAction.moveBy(x: 0, y: height, duration: TimeInterval(abs(height))/200.0)
        let act2 = SKAction.repeatForever(SKAction.animate(with: self.climbingTextures, timePerFrame: 0.1, resize: true, restore: true))
        
        self.sprite.run(act2, withKey: "climbing")
        self.sprite.run(act1) {
            self.sprite.removeAction(forKey: "climbing")
            self.goIdle()
            self.sprite.physicsBody!.isDynamic = true
            self.sprite.physicsBody!.pinned = false
            let wait = SKAction.wait(forDuration: 0.3)
            self.sprite.run(wait) {
                if self.XDirection == .left {
                    self.XDirection = .right
                }
                SoundManager.levelEnd.stop()
                SoundManager.levelEnd.play()
                self.sprite.run(SKAction.move(to: position, duration: 2)) {
                }
                self.animateMoving()
            }
        }
    }
    
    func die() {
        
    }
    
    func reset() {
        self.sprite.removeAllActions()
        self.canUpdate = true
        self.isMoving = false
        self.isJumping = false
        self.isInTheAir = false
        self.mode = .normal
        self.goIdle()
        self.sprite.physicsBody = self.physics
    }
    
    func didHit(node: SKNode, with hitPoint: HitPoint) -> Bool {
        return hitPoint == .head ? head.intersects(node) : foots.intersects(node)
    }
    
    func changeMode(to mode: Mario.MarioMode) {
        if self.mode == mode && mode == .normal {
            self.die()
        } else {
            self.IsInTheAir = false
            self.IsMoving = false
            self.IsJumping = false
            self.canUpdate = false
            self.goIdle()
            self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            self.sprite.position.y -= self.sprite.frame.height/2
            self.sprite.physicsBody = nil
            
            let anim1 =
                mode == .superMario ? SKAction.resize(toHeight: self.sprite.frame.height + 20, duration: 0) : SKAction.fadeOut(withDuration: 0)

            let anim2 =
                mode == .superMario ? SKAction.resize(toHeight: self.sprite.frame.height, duration: 0) : SKAction.fadeIn(withDuration: 0)
            
            let wait = SKAction.wait(forDuration: 0.1)
            
            let actSequence = SKAction.sequence([anim1,wait,anim2,wait,anim1,wait,anim2,wait,anim1,wait,anim2,wait,anim1,wait,anim2])
            
            
            self.sprite.run(actSequence) {
                self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.mode = mode
                self.goIdle()
                self.sprite.physicsBody?.velocity = CGVector.zero
                self.sprite.physicsBody = self.physics
                self.foots.position.y = -self.sprite.frame.height/2 - 3
                self.head.position.y = self.sprite.frame.height/2 + 3
                self.canUpdate = true
            }
        }
    }
    
    // MARK:- Animations
    
    private func goIdle() {
        self.sprite.size = idleTexture.size()
        self.sprite.texture = idleTexture
    }
    
    private func animateMoving() {
        
        let moving = SKAction.animate(with: self.movingTextures, timePerFrame: 0.07,
                                                 resize: true, restore: true)
        self.sprite.run(SKAction.repeatForever(moving),
                        withKey: "moving")
    }
    
    private func animateJumping() {
        self.sprite.size = jumpTexture.size()
        self.sprite.texture = jumpTexture
    }
}
