//
//  AnimationComponent.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-06.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
	
	let spriteComponent: SpriteComponent!
	
	var textures: Array<SKTexture> = []
	
	init(entity: GKEntity, textures: Array<SKTexture>) {
		self.textures = textures
		
		/* WHY: entity? */
		self.spriteComponent = entity.component(ofType: SpriteComponent.self)
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		
		
		if (spriteComponent.node.action(forKey: "Flap") == nil) {
			let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
			let repeatAction = SKAction.repeatForever(playerAnimation)
			spriteComponent.node.run(repeatAction, withKey: "Flap")
		}
		
		
		if let player = entity as? Player {
			if player.movementAllowed {
				startAnimation()
			}
			else {
				stopAnimation(name: "Flap")
			}
		}
	}
	
	func startWobble() {
		let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.4)
		moveUp.timingMode = .easeInEaseOut
		let moveDown = moveUp.reversed()
		let sequence = SKAction.sequence([moveUp, moveDown])
		let repeatWobble = SKAction.repeatForever(sequence)
		spriteComponent.node.run(repeatWobble, withKey: "Wobble")
		
		let flapWings = SKAction.animate(with: textures, timePerFrame: 0.07)
		let repeatFlap = SKAction.repeatForever(flapWings)
		spriteComponent.node.run(repeatFlap, withKey: "Wobble-Flap")
		
	}
	
	func stopWobble() {
		stopAnimation(name: "Wobble")
		stopAnimation(name: "Wobble-Flap")
	}
	
	func startAnimation() {
		
		/* only if it doesnt already have actions */
		if !spriteComponent.getNode().hasActions() {
			let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
			spriteComponent.getNode().run(SKAction.repeatForever(playerAnimation))
		}
	}
	
	func stopAnimation(name: String) {
		spriteComponent.getNode().removeAction(forKey: "Flap")}
}
