//
//  SpriteComponent.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-05.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    var node : SKSpriteNode!
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        node.entity = entity // back pointer
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
		// Is this OK?
    func getNode() -> SKSpriteNode {
        return node
    }
		func getEntity() -> GKEntity {
			return node.entity!
		}
}

