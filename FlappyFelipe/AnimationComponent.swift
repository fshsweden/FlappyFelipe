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
		
		/* in every frame update??? Really? */
		
		if let player = entity as? Player {
			if player.movementAllowed {
				startAnimation()
			}
			else {
				stopAnimation()
			}
		}
	}
	
	func startAnimation() {
		
		/* only if it doesnt already have actions */
		if !spriteComponent.getNode().hasActions() {
			let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
			spriteComponent.getNode().run(SKAction.repeatForever(playerAnimation))
		}
	}
	
	func stopAnimation() {
		spriteComponent.getNode().removeAllActions()
	}
}
