//
//  GameViewController.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()
      let scene = StartGameScene(size: view.bounds.size)
      let skView = view as! SKView
      skView.showsFPS = true
      skView.showsNodeCount = true
      skView.ignoresSiblingOrder = true
      scene.scaleMode = .resizeFill
      skView.presentScene(scene)
    }


}
