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

class GameViewController: UIViewController, GameSceneDelegate {
	
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
				
				let scene = GameScene(
					size: CGSize(width: 320, height: 320 * aspectRatio),
					stateClass: MainMenuState.self,
					delegate: self)
				
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
	
	
	func screenshot() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
		view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image!
	}
	
	func shareString(string:String, url:URL, image:UIImage) {
		let vc = UIActivityViewController(activityItems: [string, url, image], applicationActivities: nil)
		present(vc, animated: true, completion: nil)
	}
}
