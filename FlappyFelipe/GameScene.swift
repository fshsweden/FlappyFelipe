//
//  GameScene.swift
//  FlappyFelipe
//
//  Created by Peter Andersson on 2016-10-04.
//  Copyright © 2016 Peter Andersson. All rights reserved.
//

import SpriteKit
import GameplayKit

/*
Z - layers
*/
enum Layer: CGFloat {
	case Background
	case Obstacle
	case Foreground
	case Player
	case UI
}

struct PhysicsCategory {
	static let None: UInt32 =       0       // 0
	static let Player: UInt32 =     0b1     // 1
	static let Obstacle: UInt32 =   0b10    // 2
	static let Ground: UInt32 =     0b100   // 4
}

// interface
protocol GameSceneDelegate {
	func screenshot() -> UIImage
	func shareString(string: String, url: URL, image: UIImage)
}


/*
	------------------------------------------------------------------------






	------------------------------------------------------------------------
*/
class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var gameSceneDelegate: GameSceneDelegate
	let appStoreID = 1122334455
	
	/* create a single world node */
	let worldNode = SKNode()
	
	var playableStart : CGFloat = 0
	var playableHeight: CGFloat = 0
	
	let numberOfForegrounds = 2
	let groundSpeed: CGFloat = 150
	
	var deltaTime: TimeInterval = 0
	var lastUpdateTime: TimeInterval = 0
	
	let player = Player(imageName: "Bird0")
	
	let bottomObstacleMinFraction: CGFloat = 0.1
	let bottomObstacleMaxFraction: CGFloat = 0.6
	
	let gapMultiplier: CGFloat = 3.5
	
	let firstSpawnDelay: TimeInterval = 1.75
	let everySpawnDelay: TimeInterval = 1.5
	
	var scoreLabel: SKLabelNode!
	var score = 0
	var fontName = "AmericanTypewriter-Bold"
	var margin: CGFloat = 20.0
	
	/* Lazy?? */
	lazy var gameState: GKStateMachine = GKStateMachine(states: [
		MainMenuState(scene:self) ,
		TutorialState(scene:self),
		PlayingState(scene: self),
		FallingState(scene: self),
		GameOverState(scene: self)
		])
	
	let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
	let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
	
	var initialState: AnyClass
	
	/*
		GameScene constructor
	*/
	init(size: CGSize, stateClass: AnyClass, delegate: GameSceneDelegate) {
		gameSceneDelegate = delegate
		initialState = stateClass
		super.init(size: size)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/*
		------------------------------------------------------------------------
		Scene moved to View
		------------------------------------------------------------------------
	*/
	override func didMove(to view: SKView) {
		
		physicsWorld.gravity = CGVector(dx:0, dy:0)
		physicsWorld.contactDelegate = self
		
		/* Setup Your Scene Here */
		addChild(worldNode)
		//setupBackground()
		//setupForeground()
		//setupPlayer()
		//setupScoreLabel()
		// spawnObstacle()
		// startSpawning()
		gameState.enter(initialState)
	}
	
	/*
		------------------------------------------------------------------------
	
		------------------------------------------------------------------------
	*/
	func setupBackground() {
		
		let background = SKSpriteNode(imageNamed: "Background")
		background.anchorPoint=CGPoint(x: 0.5, y: 1.0)
		background.position = CGPoint(x: size.width/2, y: size.height)
		background.zPosition = Layer.Background.rawValue
		
		worldNode.addChild(background)
		
		playableStart = size.height - background.size.height
		playableHeight = background.size.height
		
		
		let lowerLeft = CGPoint(x:0, y:playableStart)
		let lowerRight = CGPoint(x: size.width, y: playableStart)
		
		// add physics
		physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
		physicsBody?.categoryBitMask = PhysicsCategory.Ground
		physicsBody?.collisionBitMask = 0
		physicsBody?.contactTestBitMask = PhysicsCategory.Player
	}
	
	/*
	
	*/
	func setupForeground() {
		
		for i in 0..<numberOfForegrounds {
			let foreground = SKSpriteNode(imageNamed: "Ground")
			foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
			foreground.position = CGPoint(x: CGFloat(i) * size.width, y: playableStart)
			foreground.zPosition = Layer.Foreground.rawValue
			foreground.name = "foreground"
			worldNode.addChild(foreground)
		}
	}
	
	/*
	
	*/
	func setupPlayer() {
		
		// Get Node from inside Player Entity...
		
		let playerNode = player.spriteComponent.getNode()
		playerNode.position = CGPoint(x: size.width * 0.2, y: playableHeight * 0.4 + playableStart)
		playerNode.zPosition = Layer.Player.rawValue
		
		worldNode.addChild(playerNode)
		player.movementComponent.playableStart = playableStart // ???
	}
	
	/*
	
	*/
	func setupScoreLabel() {
		scoreLabel = SKLabelNode(fontNamed: fontName)
		scoreLabel.fontColor = SKColor(red: 101.0/255.0, green:71.0/255.0, blue:73.0/255.0, alpha: 1.0)
		scoreLabel.position = CGPoint(x: size.width/2, y: size.height - margin)
		scoreLabel.verticalAlignmentMode = .top
		scoreLabel.zPosition = Layer.UI.rawValue
		scoreLabel.text = "\(score)"
		
		worldNode.addChild(scoreLabel)
	}
	
	/*
	
	*/
	func startSpawning() {
		let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
		let spawn = SKAction.run(spawnObstacle)
		let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
		
		let spawnSequence = SKAction.sequence([spawn, everyDelay])
		let foreverSpawn = SKAction.repeatForever(spawnSequence)
		let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
		
		// run(overallSequence)
		run(overallSequence, withKey: "spawn")
	}
	
	/*
	
	*/
	func stopSpawning() {
		removeAction(forKey: "spawn")
		worldNode.enumerateChildNodes(withName: "obstacle", using: {
			node, stop in
			node.removeAllActions()
		})
	}
	
	/*
	
	*/
	func createObstacle() -> SKSpriteNode {
		let obstacle = Obstacle(imageName: "Cactus")
		
		let obstacleNode = obstacle.spriteComponent.getNode()
		obstacleNode.zPosition = Layer.Obstacle.rawValue
		
		obstacleNode.name = "obstacle"
		obstacleNode.userData = NSMutableDictionary()
		
		return obstacle.spriteComponent.node
	}
	
	/*
	
	*/
	func spawnObstacle () {
		// Bottom obstacle
		let bottomObstacle = createObstacle()
		let startX = size.width + bottomObstacle.size.width/2
		let bottomObstacleMin = (playableStart - bottomObstacle.size.height/2) + playableHeight * bottomObstacleMinFraction
		let bottomObstacleMax = (playableStart - bottomObstacle.size.height/2) + playableHeight * bottomObstacleMaxFraction
		
		//let randomValue = CGFloat.random(min: bottomObstacleMin, max: bottomObstacleMax)
		
		let randomSource = GKARC4RandomSource()
		let randomDistribution = GKRandomDistribution(
			randomSource: randomSource,
			lowestValue: Int(round(bottomObstacleMin)),
			highestValue: Int(round(bottomObstacleMax))
		)
		let randomValue = randomDistribution.nextInt()
		bottomObstacle.position = CGPoint(x: startX, y: CGFloat(randomValue))
		worldNode.addChild(bottomObstacle)
		
		
		// Top obstacle
		let topObstacle = createObstacle()
		topObstacle.zRotation = CGFloat(180).degreesToRadians()
		topObstacle.position = CGPoint(
			x: startX,
			y: bottomObstacle.position.y + bottomObstacle.size.height/2 +
				topObstacle.size.height/2 +
				player.spriteComponent.node.size.height * gapMultiplier)
		worldNode.addChild(topObstacle)
		
		let moveX = size.width + topObstacle.size.width
		let moveDuration = moveX / groundSpeed
		
		
		
		// Sequences!
		let sequence = SKAction.sequence([
			SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
			SKAction.removeFromParent()
			])
		
		topObstacle.run(sequence)
		bottomObstacle.run(sequence)
		
	}
	
	func touchDown(atPoint pos : CGPoint) {
	}
	
	func touchMoved(toPoint pos : CGPoint) {
	}
	
	func touchUp(atPoint pos : CGPoint) {
	}
	
	/*
		------------------------------------------------------------------------
		Really BAD way of handling button clicks!
		------------------------------------------------------------------------
	*/
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		// for t in touches { self.touchDown(atPoint: t.location(in: self)) }
		
		if let touch = touches.first {
			
			let touchLocation = touch.location(in: self)
			
			switch (gameState.currentState) {
			case is MainMenuState:
				print("CURRENT STATE IS MAINMENU")
				// if this and that -> learn() eller rate()
				restartGame(stateClass: TutorialState.self)
			case is TutorialState:
				print("CURRENT STATE IS TUTORIAL")
				gameState.enter(PlayingState.self)
			case is PlayingState:
				print("CURRENT STATE IS PLAYING")
				player.movementComponent.applyImpulse(lastUpdateTime: lastUpdateTime)
			case is GameOverState:
				print("CURRENT STATE IS GAMEOVER")
				if (touchLocation.x < size.width * 0.6) {
					restartGame(stateClass: TutorialState.self)
				}
				else {
					shareScore()
				}
			default:
				print ("UNKNOWN STATE! ")
				print (gameState.currentState)
				break
			}
			
		}
	}

	/*
	
	*/
	func restartGame(stateClass: AnyClass) {
		run(popAction)
		
		// new Scene
		let newScene = GameScene(size: size, stateClass: stateClass, delegate: gameSceneDelegate)
		let transition = SKTransition.fade(with: SKColor.black, duration: 0.5)
		
		// present new Scene
		view?.presentScene(newScene, transition: transition)
		
	}
	
	/*
		------------------------------------------------------------------------
		CONTACT!
		------------------------------------------------------------------------
	*/

	func didBegin(_ contact: SKPhysicsContact) {
		let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
		
		if other.categoryBitMask == PhysicsCategory.Ground {
			print("Hit Ground!")
			gameState.enter(GameOverState.self)
		}
		
		if other.categoryBitMask == PhysicsCategory.Obstacle {
			print("Hit Obstacle!")
			gameState.enter(FallingState.self)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	/*
		------------------------------------------------------------------------
		Complicated way of keeping score IMHO
		------------------------------------------------------------------------
	*/
	func updateScore() {
		worldNode.enumerateChildNodes(withName: "obstacle", using: {
			node, stop in
			if let obstacle = node as? SKSpriteNode {
				
				// check this!
				if let passed = obstacle.userData?["Passed"] as? NSNumber {
					if passed.boolValue {
						return
					}
				}
				
				// strange code....
				if (self.player.spriteComponent.node.position.x > obstacle.position.x + obstacle.size.width / 2) {
					self.score += 1
					self.scoreLabel.text = "\(self.score/2)"  // how bout that...
					
					obstacle.userData?["Passed"] = NSNumber(value: true)
					self.run(self.coinAction)
				}
			}
		})
	}
	
	
	/*
		------------------------------------------------------------------------

		------------------------------------------------------------------------
	*/
	func updateForeground() {
		
		// moves foreground sprite(s)
		worldNode.enumerateChildNodes(withName: "foreground", using: {
			node, stop in
			
			if let foreground = node as? SKSpriteNode {
				
				let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y:0)
				
				foreground.position.x += moveAmount.x
				foreground.position.y += moveAmount.y
				
				if foreground.position.x < -foreground.size.width {
					foreground.position.x += foreground.size.width * CGFloat(self.numberOfForegrounds)
				}
				
			}
		})
	}
	
	/*
		------------------------------------------------------------------------
	
		------------------------------------------------------------------------
	*/
	override func update(_ currentTime: TimeInterval) {
		if lastUpdateTime == 0 {
			lastUpdateTime = currentTime
		}
		
		deltaTime = currentTime - lastUpdateTime
		lastUpdateTime = currentTime
		
		// Begin updates
		// updateForeground()  now done from state machine!
		gameState.update(deltaTime: deltaTime)
		
		//Per-Entity Updates
		player.update(deltaTime: deltaTime)
	}
	
	
	func shareScore() {
		let urlString = "https://itune4s.apple.com/app/flappy-adsadassd/id\(appStoreID)?mt=8"
		let url = URL(string: urlString)
		let screenshot = gameSceneDelegate.screenshot()
		let initialtextString = "OMG! I scored \(score/2) points in Flappy-kgfdslkhhg!"
		gameSceneDelegate.shareString(string: initialtextString, url: url!, image: screenshot)
		
	}
	
	func rateApp() {
		let urlString = "https://itunes/apple.com/app/flappy-lkjjhdfslkh/id\(appStoreID)?mt=8"
		let url = URL(string: urlString)
		UIApplication.shared.open(url!)
	}
	
	func learn() {
		let urlString = "https://www.fshsweden.se/flappy"
		let url = URL(string: urlString)
		UIApplication.shared.open(url!)
	}
}
