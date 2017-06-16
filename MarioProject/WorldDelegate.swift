//
//  WorldDelegate.swift
//  GameProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import SpriteKit

class WorldDelegate: SKScene {
    
    private let mario = Mario.standard
    private var backGround: SKSpriteNode!
    private var castleFlag: SKSpriteNode!
    private var castleDoor: SKSpriteNode!
    private var flagPole: SKSpriteNode!
    private var isLevelEnded = false
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        (view.delegate as! ViewController).startTimer()
        SoundManager.superMarioSound.loops = true
        SoundManager.superMarioSound.stop()
        SoundManager.superMarioSound.play()
        
        self.isLevelEnded = false
        self.mario.reset()
        
        self.backGround = self.childNode(withName: "//backGround")! as! SKSpriteNode
        self.castleFlag = self.childNode(withName: "//castleFlag")! as! SKSpriteNode
        self.castleDoor = self.childNode(withName: "//castleDoor")! as! SKSpriteNode
        self.flagPole = self.childNode(withName: "//flagPole")! as! SKSpriteNode
        
        self.mario.sprite.position = CGPoint(x: -150, y: -272)
//        self.mario.sprite.position = CGPoint(x: 9500, y: -272)
        self.addChild(mario.sprite)
        
        
        for node in self.children where node.name != nil {
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
        
        
        
        guard !isLevelEnded else { return }
        
        if mario.canUpdate {
            self.didTouchFlagPole()
        }
        
        self.didTouchCastle()
        
        for node in self.children {
            (node as? Updatable)?.update(currentTime)
        }
        
    }
    
    
    func didTouchCastle() {
        let point = self.convert(castleDoor.position, from: castleDoor.parent!)
        if abs(point.x.subtracting(mario.sprite.position.x)) < 1 {
            mario.sprite.removeFromParent()
            if !isLevelEnded {
                calculateAllPoints()
            }
            isLevelEnded = true
        }
    }
    
    func didTouchFlagPole() {
        let xSide = mario.sprite.position.x + (mario.sprite.frame.width/2 * CGFloat(mario.XDirection.rawValue)) - CGFloat(mario.XDirection.rawValue * 10)
        let side = CGPoint(x: xSide, y: mario.sprite.frame.midY)
        if flagPole.frame.contains(side) && mario.IsInTheAir {
            
            let height = flagPole.frame.minY - side.y
            let labelPos = CGPoint(x: flagPole.frame.maxX + 50, y: flagPole.frame.minY)
            let duration = TimeInterval(abs(height))/200.0
            let polePoint = calculatePolePoint(at: side.y)
            
            (self.view!.delegate as! ViewController).stopTimer()
            self.mario.canUpdate = false
            SoundManager.superMarioSound.stop()
            
            self.mario.beginEndAnimationFromPole(at: height, to: self.convert(castleDoor.position, from: castleDoor.parent!))
            
            self.showLabelPoint(point: polePoint, at: labelPos, sendTo: flagPole.frame.maxY - labelPos.y , duration: duration, endsWithFade: false)
            self.increasePoints(by: polePoint)
            
            let flagAct = SKAction.moveTo(y: flagPole.frame.minY, duration: duration )
            flagPole.childNode(withName: "flag")!.run(flagAct)
        }
    }
    
    func calculatePolePoint(at height: CGFloat) -> Int {
        switch flagPole.frame.maxY - height {
        case 0...50:
            return 5000
        case 51...150:
            return 2000
        default:
            return Int(height * 5000/flagPole.frame.width)
        }
    }
    
    func calculateAllPoints() {
        (self.view!.delegate as! ViewController).calculateAllPoints(completion: showCastleFlag)
    }
    
    func showCastleFlag() {
        let moveUp = SKAction.moveBy(x: 0, y: 70, duration: 1)
        self.castleFlag.run(moveUp)
    }
    
    func increasePoints(by point: Int, isCoin: Bool = true) {
        (self.view!.delegate as! ViewController).increasePoints(by: point, isCoin: isCoin)
    }
    
    func showLabelPoint(point: Int, at position: CGPoint, sendTo height: CGFloat = 100, duration: TimeInterval = 1, endsWithFade: Bool = true) {
        let label = SKLabelNode(text: String(point))
        label.fontName = "Minecraft"
        label.fontSize = 25
        label.position = position
        
        self.addChild(label)
        var acts = [SKAction]()
        let moveUp = SKAction.moveBy(x: 0, y: height, duration: duration)
        acts.append(moveUp)
        if endsWithFade {
            acts.append(SKAction.fadeOut(withDuration: duration))
        }
        
        label.run(SKAction.group(acts)) {
            label.removeFromParent()
        }
        
    }

    override func keyUp(with event: NSEvent) {
        guard mario.canUpdate else { return }
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
        
        guard mario.canUpdate else { return }
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
