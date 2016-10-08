//
//  MovementComponent.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-05.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent : GKComponent {
	
	var spriteComponent: SpriteComponent!
	var player: Player!
	
	var velocity = CGPoint.zero
	let gravity : CGFloat = -1500
	let impulse : CGFloat = 400
	
	var velocityModifier: CGFloat = 1000.0
	var angularVelocity: CGFloat = 0.1
	let minDegrees: CGFloat = -90
	let maxDegrees: CGFloat = 25
	
	var lastTouchTime: TimeInterval = 0
	var lastTouchY: CGFloat = 0.0
	
	var playableStart: CGFloat = 0
	
	let flapAction = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
	
	init(entity: GKEntity) {
		super.init()
		self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
		self.player = entity as? Player
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func applyInitialImpulse() {
		velocity = CGPoint(x: 0, y: impulse * 2)
	}
	
	func spriteAction(action:SKAction) {
		spriteComponent.node.run(action)
	}
	
	func sombreroAction(action: SKAction) {
		player.sombrero.run(action)
	}
	
	func moveSombrero() {
		if let player = entity as? Player {
			let moveUp = SKAction.moveBy(x: 0, y: 12, duration: 0.15)
			moveUp.timingMode = .easeInEaseOut
			let moveDown = moveUp.reversed()
			
			sombreroAction(action: SKAction.sequence([moveUp, moveDown]))
		}
	}
	
	func applyImpulse(lastUpdateTime: TimeInterval) {
		
		spriteAction(action: flapAction)
		moveSombrero()
		
		velocity = CGPoint(x:0, y:impulse)
		
		angularVelocity = velocityModifier.degreesToRadians()
		lastTouchTime = lastUpdateTime
		lastTouchY = spriteComponent.getNode().position.y
	}
	
	func applyMovement(seconds: TimeInterval) {
		let spriteNode = spriteComponent.getNode()
		
		// apply gravity
		let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
		velocity += gravityStep
		
		// apply velocity
		let velocityStep = velocity * CGFloat(seconds)
		spriteNode.position += velocityStep
		
		if (spriteNode.position.y < lastTouchY) {
			angularVelocity = -velocityModifier.degreesToRadians()
		}
		
		// Rotate
		let angularStep = angularVelocity * CGFloat(seconds)
		spriteNode.zRotation += angularStep
		spriteNode.zRotation = min(max(spriteNode.zRotation, minDegrees.degreesToRadians()), maxDegrees.degreesToRadians())
		
		// temp ground hit
		if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
			spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart  + spriteNode.size.height / 2)
		}
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		applyMovement(seconds: seconds)
	}
}
