//
//  GameViewController.swift
//  FallyFelipeTV
//
//  Created by Peter Andersson on 08/10/16.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if let skView = self.view as? SKView {
			if skView.scene == nil {
				let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
				let scene = GameScene(size: CGSize(width:568 / aspectRatio, height:568), stateClass: MainMenuState.self, delegate: self)
				
				print("HEJ HEJ!!!")
				if let tv = scene as? TVControlsScene {
					print("We're running ON APPLE TV!")
				}
				print("DÅ DÅ")
				
//				skView.showsFPS=true
//				skView.showsNodeCount=true
//				skView.showsPhysics=true

				skView.ignoresSiblingOrder=true
				scene.scaleMode = .aspectFill
				skView.presentScene(scene)
				
			}
		}
	}
	
	func screenshot() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
		view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
	
	func shareString(string: String, url: URL, image: UIImage) {
		// not supported
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
}
