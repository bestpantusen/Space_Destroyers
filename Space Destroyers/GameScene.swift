//
//  GameScene.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//
import SpriteKit
import GameplayKit
import CoreMotion

var motionManager: CMMotionManager = CMMotionManager()
var accelerationX: CGFloat = 0.0

var levelNum = 1

extension Array {
    func randomElement() -> Element? {
        return isEmpty ? nil : self[Int(arc4random_uniform(UInt32(count)))]
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(500)
    var invadersWhoCanFire: [Invader] = [Invader]()
    let player = Player()
    let maxLevels = 3
  
  func setupAccelerometer() {
      motionManager.startAccelerometerUpdates()
  }


    // MARK: - Invader Methods
    func setupInvaders() {
        var invaderRow = 0
        var invaderColumn = 0
        let numberOfInvaders = levelNum * 2 + 1
        for i in 1...rowsOfInvaders {
            invaderRow = i
            for j in 1...numberOfInvaders {
                invaderColumn = j
                let tempInvader = Invader()
                let invaderHalfWidth = tempInvader.size.width / 2
                let xPositionStart = size.width / 2 - invaderHalfWidth - (CGFloat(levelNum) * tempInvader.size.width) + 10
                tempInvader.position = CGPoint(x: xPositionStart + ((tempInvader.size.width + 10) * CGFloat(j - 1)), y: CGFloat(self.size.height - CGFloat(i) * 46))
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
                if i == rowsOfInvaders {
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }

    func moveInvaders() {
        var changeDirection = false
        enumerateChildNodes(withName: "invader") { node, _ in
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width / 2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth {
                changeDirection = true
            }
        }
        if changeDirection {
            self.invaderSpeed *= -1
            enumerateChildNodes(withName: "invader") { node, _ in
                let invader = node as! SKSpriteNode
                invader.position.y -= CGFloat(46)
            }
        }
    }
  // MARK: - Game Management Methods
  func levelComplete() {
      if levelNum <= maxLevels {
          let levelCompleteScene = LevelCompleteScene(size: size)
          levelCompleteScene.scaleMode = scaleMode
          let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
          view?.presentScene(levelCompleteScene, transition: transitionType)
      } else {
          levelNum = 1
          newGame()
      }
  }

  func newGame() {
      let gameOverScene = StartGameScene(size: size)
      gameOverScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
      view?.presentScene(gameOverScene, transition: transitionType)
  }


    // MARK: - Player Methods
    func setupPlayer() {
        player.position = CGPoint(x: self.frame.midX, y: player.size.height / 2 + 10)
        addChild(player)
    }

    // MARK: - Invader Fire Methods
    func invokeInvaderFire() {
        let fireBullet = SKAction.run { [weak self] in
            self?.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet, waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
    }

    func fireInvaderBullet() {
        if invadersWhoCanFire.isEmpty {
            levelNum += 1
        } else {
            let randomInvader = invadersWhoCanFire.randomElement()
            randomInvader?.fireBullet(scene: self)
        }
    }

    // MARK: - Implementing SKPhysicsContactDelegate protocol
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if (firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0) {
            
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            let newInvaderColumn = theInvader.invaderColumn

            if newInvaderRow >= 1 {
                enumerateChildNodes(withName: "invader") { node, _ in
                    let invader = node as! Invader
                    if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn {
                        self.invadersWhoCanFire.append(invader)
                    }
                }
            }

            if let invaderIndex = invadersWhoCanFire.firstIndex(of: theInvader) {
                invadersWhoCanFire.remove(at: invaderIndex)
            }

            theInvader.removeFromParent()
            secondBody.node?.removeFromParent()
        }

        if (firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0) {
            player.die()
        }

        if (firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0) {
            player.kill()
        }
    }

  override func didMove(to view: SKView) {
      backgroundColor = SKColor.black
      setupInvaders()
      setupPlayer()
      invokeInvaderFire()
      setupAccelerometer()
      
      self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
      self.physicsWorld.contactDelegate = self
      self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
      self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
  }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            player.fireBullet(scene: self)
        }
    }

  override func update(_ currentTime: TimeInterval) {
      moveInvaders()
      
      if let accelerometerData = motionManager.accelerometerData {
          accelerationX = CGFloat(accelerometerData.acceleration.x)
      }
  }
  override func didSimulatePhysics() {
      player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: 0)
  }
  
  


}
