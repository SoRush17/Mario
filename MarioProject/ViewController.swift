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

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            
            if let scene = SKScene(fileNamed: "LevelOneScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            //view.ignoresSiblingOrder = true
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
}

