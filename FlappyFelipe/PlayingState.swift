//
//  PlayingState.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-06.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
	
	unowned let scene: GameScene        // unowned ???
	
	init(scene: SKScene) {
		self.scene = scene as! GameScene
		super.init()
	}
	
	override func didEnter(from previousState: GKState?) {
		print("ENTER STATE PLAYING")
		scene.startSpawning()
		
		// FIX!
		scene.player.movementAllowed = true
		scene.player.animationComponent.startAnimation()
		
		scene.player.animationComponent.stopWobble()
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
	}
	
	override func update(deltaTime seconds: TimeInterval) {

		// When playing: update foreground, update score
		scene.updateForeground()
		scene.updateScore()
	}
}
