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
    
    var velocity = CGPoint.zero
    let gravity : CGFloat = -1500
    let impulse : CGFloat = 400
    
    var playableStart: CGFloat = 0
    
    init(entity: GKEntity) {
        super.init()
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyImpulse() {
        velocity = CGPoint(x:0, y:impulse)
    }
    
    func applyMovement(seconds: TimeInterval) {
        let spriteNode = spriteComponent.getNode()
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
        velocity += gravityStep
        let velocityStep = velocity * CGFloat(seconds)
        spriteNode.position += velocityStep
        
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart  + spriteNode.size.height / 2)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        applyMovement(seconds: seconds)
    }
}
