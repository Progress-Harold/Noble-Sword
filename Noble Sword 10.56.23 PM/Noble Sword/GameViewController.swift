//
//  GameViewController.swift
//  Noble Sword
//
//  Created by Lee Davis on 5/8/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let gameView = SKView(frame: view.frame)
        view = gameView
        
        if let sceneView = view as? SKView,
           let scene = ForestScene(fileNamed: "Forest") {
            
//            scene.size = CGSize(width: 2048, height: 1536)
            scene.scaleMode = .aspectFill

            sceneView.presentScene(scene, transition: .crossFade(withDuration: 3))
        }
    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
