//
//  GameViewController.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-04.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*
            Cast self.view to SKView
         */
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                
                /* Create GameScene and initialize it with MainMenuState */
                
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size: CGSize(width: 320, height: 320 * aspectRatio), stateClass: MainMenuState.self)
                
                skView.showsFPS=true
                skView.showsNodeCount=true
                skView.showsPhysics=true
                skView.ignoresSiblingOrder=true
                
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}