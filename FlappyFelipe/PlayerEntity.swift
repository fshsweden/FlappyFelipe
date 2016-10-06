//
//  PlayerEntity.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-05.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {
    
    var spriteComponent : SpriteComponent!   // Note the ! - important!!
    var movementComponent: MovementComponent!
    
    init(imageName: String) {
        super.init()
        let texture = SKTexture(imageNamed:  imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size:  texture.size())
        addComponent(spriteComponent)
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
        
        
        // add physics
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
