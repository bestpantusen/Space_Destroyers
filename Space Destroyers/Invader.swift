//
//  Invader.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//

import UIKit
import SpriteKit

class Invader: SKSpriteNode {

  var invaderRow = 0
  var invaderColumn = 0

  init() {
   
    let randNum = Int(arc4random_uniform(3) + 1)
    let texture = SKTexture(imageNamed: "invader\(randNum)")
    super.init(texture: texture, color: SKColor.clear, size: texture.size())
    self.name = "invader"

    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
    self.physicsBody?.isDynamic = true
    self.physicsBody?.usesPreciseCollisionDetection = false
    self.physicsBody?.categoryBitMask = CollisionCategories.Invader
    self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
    self.physicsBody?.collisionBitMask = 0x0

  }

  required init?(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }


  func fireBullet(scene: SKScene) {
      let bullet = InvaderBullet(imageName: "laser", bulletSound: nil)
      bullet.position = CGPoint(x: self.position.x, y: self.position.y - self.size.height / 2)
      scene.addChild(bullet)
      
      let moveBulletAction = SKAction.move(to: CGPoint(x: self.position.x, y: 0 - bullet.size.height), duration: 2.0)
      let removeBulletAction = SKAction.removeFromParent()
      bullet.run(SKAction.sequence([moveBulletAction, removeBulletAction]))
  }

}
