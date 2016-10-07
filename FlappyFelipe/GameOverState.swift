//
//  GameOverState.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-06.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene        // unowned ???
    
    let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let animationDelay = 0.3
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.run(hitGroundAction)
        scene.stopSpawning() // Stop spawning Obstacles
        
        scene.player.movementAllowed = false  // HACK
        
        showScoreCard()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
	
	
	
    func setBestScore(bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey:"BestScore")
        UserDefaults.standard.synchronize()
    }
    
    func getBestScore() -> Int {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
    
    func showScoreCard() {
        if scene.score > getBestScore() {
            setBestScore(bestScore: scene.score)
        }
        
        let scorecard = SKSpriteNode(imageNamed: "ScoreCard")
        scorecard.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scorecard.name = "Tutorial"
        scorecard.zPosition = Layer.UI.rawValue
        
        scene.worldNode.addChild(scorecard)
        
        // Last Score Label
        let lastScore = SKLabelNode(fontNamed: scene.fontName)
        lastScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        lastScore.position = CGPoint(x: -scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
        lastScore.text = "\(scene.score/2)"
        lastScore.zPosition = Layer.UI.rawValue
        
        scorecard.addChild(lastScore)
        
        // Best Score Label
        let bestScore = SKLabelNode(fontNamed: scene.fontName)
        bestScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        bestScore.position = CGPoint(x: scorecard.size.width * 0.25, y: -scorecard.size.height * 0.2)
        bestScore.text = "\(getBestScore()/2)"
        bestScore.zPosition = Layer.UI.rawValue
        
        scorecard.addChild(bestScore)

        // Game Over Sprite
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2 + scorecard.size.height/2 + scene.margin +  gameOver.size.height/2)
//        gameOver.name = "Tutorial"
        gameOver.zPosition = Layer.UI.rawValue
        
        scene.worldNode.addChild(gameOver)
        
        
        // OK Button
        let okButton = SKSpriteNode(imageNamed: "Button")
        okButton.position = CGPoint(x: scene.size.width*0.25,
                                    y: scene.size.height/2 - scorecard.size.height/2 - scene.margin - okButton.size.height/2)
        okButton.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(okButton)
        
        let ok = SKSpriteNode(imageNamed: "OK")
        ok.position = CGPoint.zero
        ok.zPosition = Layer.UI.rawValue
        okButton.addChild(ok)
        
        
        // Share Button
        let shareButton = SKSpriteNode(imageNamed: "Button")
        shareButton.position = CGPoint(x: scene.size.width*0.75,
                                    y: scene.size.height/2 - scorecard.size.height/2 - scene.margin - okButton.size.height/2)
        shareButton.zPosition = Layer.UI.rawValue
        scene.worldNode.addChild(shareButton)
        
        let share = SKSpriteNode(imageNamed: "Share")
        share.position = CGPoint.zero
        share.zPosition = Layer.UI.rawValue
        shareButton.addChild(share)
        
        
        // Juice
        gameOver.setScale(0)
        gameOver.alpha = 0
        let group = SKAction.group([
            SKAction.fadeIn(withDuration: animationDelay),
            SKAction.scale(to: 1.0, duration: animationDelay)
            ])
        group.timingMode = .easeInEaseOut
        gameOver.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            group
            ]))
        
        scorecard.position = CGPoint(x: scene.size.width * 0.5, y: -scorecard.size.height/2)
        let moveTo  = SKAction.move(to: CGPoint(x: scene.size.width/2, y: scene.size.height/2), duration: animationDelay)
        moveTo.timingMode = .easeInEaseOut
        
        
        scorecard.run(
            SKAction.sequence(
                [
                SKAction.wait(forDuration: animationDelay * 2),
                moveTo
                ]
            )
        )
        
        
        okButton.alpha = 0
        shareButton.alpha = 0
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 3),
            SKAction.fadeIn(withDuration: animationDelay)
            ])
        okButton.run(fadeIn)
        shareButton.run(fadeIn)
        
        let pops = SKAction.sequence(
            [
                SKAction.wait(forDuration: animationDelay),
                scene.popAction,
                SKAction.wait(forDuration: animationDelay),
                scene.popAction,
                SKAction.wait(forDuration: animationDelay),
                scene.popAction
            ]
        )
        
        scene.run(pops)
        
    }
}
