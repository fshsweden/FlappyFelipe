//
//  PlayerEntity.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-05.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

/*
	------------------------------------------------------------------------

	------------------------------------------------------------------------
*/
class Player: GKEntity {
	
	var spriteComponent : SpriteComponent!   // Note the ! - important!!
	var movementComponent: MovementComponent!
	var animationComponent: AnimationComponent!
	var numberOfFrames = 3
	
	// temp
	var movementAllowed = false
	let sombrero = SKSpriteNode(imageNamed: "Sombrero")
	
	/*
		------------------------------------------------------------------------
	
		------------------------------------------------------------------------
	*/
	init(imageName: String) {
		super.init()

		// Sprite Component
		let texture = SKTexture(imageNamed:  imageName)
		spriteComponent = SpriteComponent(entity: self, texture: texture, size:  texture.size())
		addComponent(spriteComponent)
		
		// Sombrero Sprite - Child of Player
		sombrero.position = CGPoint(x: 31 - sombrero.size.width/2, y: 29-sombrero.size.height/2)
		spriteComponent.getNode().addChild(sombrero)
		
		// Movement Component
		movementComponent = MovementComponent(entity: self)
		addComponent(movementComponent)
		movementComponent.applyInitialImpulse()

		// Animation Component
		var textures: Array<SKTexture> = []
		for i in 0..<numberOfFrames {
			textures.append(SKTexture(imageNamed: "Bird\(i)"))
		}
		for i in stride(from: numberOfFrames, through: 0, by: -1) {
			textures.append(SKTexture(imageNamed: "Bird\(i)"))
		}
		animationComponent = AnimationComponent(entity: self, textures: textures)
		addComponent(animationComponent)
		
		
		// Add physics body to Sprite Node
		let spriteNode = spriteComponent.getNode()
		
		let offsetX = spriteNode.frame.size.width * spriteNode.anchorPoint.x
		let offsetY = spriteNode.frame.size.height * spriteNode.anchorPoint.y
		
		let path = CGMutablePath()
		
		path.move(to: CGPoint(x: 21 - offsetX, y: 29 - offsetY))
		path.addLine(to: CGPoint(x: 13 - offsetX, y: 22 - offsetY))
		path.addLine(to: CGPoint(x: 1 - offsetX, y: 22 - offsetY))
		path.addLine(to: CGPoint(x: 1 - offsetX, y: 4 - offsetY))
		path.addLine(to: CGPoint(x: 7 - offsetX, y: 0 - offsetY))
		path.addLine(to: CGPoint(x: 24 - offsetX, y: 0 - offsetY))
		path.addLine(to: CGPoint(x: 33 - offsetX, y: 2 - offsetY))
		path.addLine(to: CGPoint(x: 39 - offsetX, y: 10 - offsetY))
		path.addLine(to: CGPoint(x: 39 - offsetX, y: 24 - offsetY))
		path.addLine(to: CGPoint(x: 35 - offsetX, y: 29 - offsetY))
		
		path.closeSubpath()
		
		spriteNode.physicsBody = SKPhysicsBody(polygonFrom: path)
		spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Player
		spriteNode.physicsBody?.collisionBitMask = 0
		spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
