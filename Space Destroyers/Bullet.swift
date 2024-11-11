//
//  Bullet.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//

import SpriteKit

class Bullet: SKSpriteNode {
    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        if let sound = bulletSound {
            run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
