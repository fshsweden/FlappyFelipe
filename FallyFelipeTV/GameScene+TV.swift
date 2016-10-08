//
//  GameScene+TV.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 08/10/16.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit

extension GameScene: TVControlsScene {
	
	func setupTVControls() {
		print ("Setting up TV Controls")
		let tap = UITapGestureRecognizer(target: self, action: #selector(GameScene.didTapOnRemote))
		// tap.delegate = self
		view!.addGestureRecognizer(tap)
	}
	
	func didTapOnRemote(tap: UITapGestureRecognizer) {
		
		switch(gameState.currentState) {
		case is MainMenuState:
			restartGame(stateClass: TutorialState.self)
		case is TutorialState:
			gameState.enter(PlayingState.self)
		case is PlayingState:
			player.movementComponent.applyImpulse(lastUpdateTime: lastUpdateTime)
		case is GameOverState:
			restartGame(stateClass: TutorialState.self)
		default:
			break
		}
		
		print("APPLE TV : TAP!")
	}
}
