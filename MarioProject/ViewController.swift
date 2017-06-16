//
//  ViewController.swift
//  MarioProject
//
//  Created by SoRush on 1/15/1396 AP.
//  Copyright © 1396 SoRush. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController,SKViewDelegate {

    @IBOutlet private var skView: SKView!
    @IBOutlet private var points: NSTextField!
    @IBOutlet private var coins: NSTextField!
    @IBOutlet private var time: NSTextField!
    @IBOutlet private var world: NSTextField!
    private var remindedTime = 400
    private var timer: Timer!
    private var point = 0
    private var coin = 0
    private var health = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView.delegate = self
        
        if let view = self.skView {
            
            if let scene = SKScene(fileNamed: "World1-2") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            //view.ignoresSiblingOrder = true
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func calculateAllPoints(completion: @escaping ()->()) {
        SoundManager.allPoints.volume = 0.2
        SoundManager.allPoints.loops = true
        SoundManager.allPoints.volume = 0.2
        SoundManager.allPoints.stop()
        SoundManager.allPoints.play()
        let interval = TimeInterval(3)/TimeInterval(remindedTime)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: {_ in
            self.increasePoints(by: 50, isCoin: false)
            self.updateTimeLabel()
            if !self.timer.isValid {
                SoundManager.allPoints.stop()
                completion()
            }
        })

    }
    
    func increasePoints(by point: Int, isCoin: Bool) {
        
        self.point += point
        var stringPoint = String(self.point)
        let zerosBeforePoint = 5 - stringPoint.characters.count
        self.points.stringValue = ""
        for _ in 0...zerosBeforePoint {
            stringPoint.insert("0", at: stringPoint.startIndex)
        }
        self.points.stringValue = stringPoint
        
        if isCoin {
            self.coin += 1
            var stringCoin = String(self.coin)
            if self.coin < 10 {
                stringCoin.insert("0", at: stringCoin.startIndex)
            }
            
            self.coins.stringValue = "x " + stringCoin
        }
        
    }
    
    
    
    
    @objc private func updateTimeLabel() {
        self.remindedTime -= 1
        time.stringValue = String(self.remindedTime)
        if remindedTime == 0 {
            health -= 1
            timer.invalidate()
        }
    }
    
    @IBAction func reset(button: NSButton) {
        
        self.coin = 0
        self.point = 0
        self.remindedTime = 400
        self.time.stringValue = "400"
        self.coins.stringValue = "x 00"
        self.points.stringValue = "000000"
        
        let scene = SKScene(fileNamed: "World\(world.stringValue)")!
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
    }
    
}

