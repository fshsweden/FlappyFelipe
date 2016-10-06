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
    // HUH??
    // var node = SKSpriteNode()
    var node : SKSpriteNode!
    
    // huh???
    override init() {
       super.init()
    }
    
    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture, color: SKColor.white, size: size)
        node.entity = entity
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getNode() -> SKSpriteNode {
        return node
    }
}

