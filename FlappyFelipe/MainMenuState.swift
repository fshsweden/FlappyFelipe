//
//  MainMenuState.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-06.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class MainMenuState: GKState {
    unowned let scene: GameScene        // unowned ???
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
			
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        
        showMainMenu()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is TutorialState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    func showMainMenu() {
        
        // Logo
        let logo = SKSpriteNode(imageNamed: "Logo")
        logo.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.8)
        logo.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(logo)
        
        // Play Button background
        let playButton = SKSpriteNode(imageNamed: "Button")
        playButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height * 0.25)
        playButton.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(playButton)

        // Play Button
        let play = SKSpriteNode(imageNamed: "Play")
        play.position = CGPoint.zero
        playButton.addChild(play)
        

        // Rate Button background
        let rateButton = SKSpriteNode(imageNamed: "Button")
        rateButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height * 0.25)
        rateButton.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(rateButton)
        
        // Rate Button
        let rate = SKSpriteNode(imageNamed: "Rate")
        rate.position = CGPoint.zero
        rateButton.addChild(rate)
        
        
        // Learn Button
        let learnButton = SKSpriteNode(imageNamed: "button_learn")
        learnButton.position = CGPoint(x: scene.size.width * 0.5, y: learnButton.size.height/2 + scene.margin)
        learnButton.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(learnButton)
        
        // Bounce Button
        let scaleUp = SKAction.scale(to: 1.02, duration: 0.75)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SKAction.scale(to: 0.98, duration: 0.75)
        scaleUp.timingMode = .easeInEaseOut
        
        learnButton.run(SKAction.repeatForever(SKAction.sequence([scaleUp, scaleDown])))
    }
}
