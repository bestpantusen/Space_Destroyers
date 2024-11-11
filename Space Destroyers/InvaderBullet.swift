//
//  InvaderBullet.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//

import SpriteKit

class InvaderBullet: Bullet {
    override init(imageName: String, bulletSound: String?) {
        super.init(imageName: imageName, bulletSound: bulletSound)

        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.InvaderBullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
