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
        
    }
    
    func startAnimation() {
        
        /* only if it doesnt already have actions */
        if !spriteComponent.node.hasActions() {
            
        }
    }
}
