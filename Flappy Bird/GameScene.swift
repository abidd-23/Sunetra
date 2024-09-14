import SpriteKit
import GameplayKit

protocol GameSceneDelegate: AnyObject {
    func didTapHomeButton()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameStartTime: TimeInterval = 0
    
    weak var sceneDelegate: GameSceneDelegate?
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var scoreOver = SKLabelNode()
    var tryAgainLabel = SKLabelNode()
    var homeButton = SKLabelNode()
    var score = 0
    var timer = Timer()
    
    enum ColliderTypes: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    var gameOver = false
    
    @objc func makePipes() {
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.height / 4
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffSet)
        pipe1.run(movePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        pipe1.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        pipe1.zPosition = -1
        self.addChild(pipe1)
        
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture.size().height / 2 - gapHeight / 2 + pipeOffSet)
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        pipe2.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        pipe2.zPosition = -1
        self.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffSet)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipes)
        gap.physicsBody!.contactTestBitMask = ColliderTypes.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderTypes.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderTypes.Gap.rawValue
        self.addChild(gap)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            if contact.bodyA.categoryBitMask == ColliderTypes.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderTypes.Gap.rawValue {
                score += 1
                scoreLabel.text = String(score)
            } else {
                gameOver = true
                self.speed = 0
                timer.invalidate()
                
                gameProgressCalculate()
                
                // Show "Score Over" text
                scoreOver.fontName = "Helvetica-Bold"
                scoreOver.fontSize = 80
                scoreOver.fontColor = UIColor.red
                scoreOver.text = "Game Over"
                scoreOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
                self.addChild(scoreOver)
                
                // Show "Try Again" button
                tryAgainLabel.fontName = "Helvetica-Bold"
                tryAgainLabel.fontSize = 50
                tryAgainLabel.fontColor = UIColor.black
                tryAgainLabel.text = "Try Again"
                tryAgainLabel.position = CGPoint(x: 0, y: -50)
                tryAgainLabel.name = "tryAgainButton"
                self.addChild(tryAgainLabel)
                
                // Show "Home" button
                homeButton.fontName = "Helvetica-Bold"
                homeButton.fontSize = 50
                homeButton.fontColor = UIColor.black
                homeButton.text = "Home"
                homeButton.position = CGPoint(x: 0, y: -130)
                homeButton.name = "homeButton"
                self.addChild(homeButton)
                
            }
        }
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupGame()
    }
    
    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        while i < 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBGForever)
            bg.zPosition = -2
            self.addChild(bg)
            i += 1
        }
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        bird.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderTypes.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderTypes.Bird.rawValue
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            if bird.physicsBody!.isDynamic == false {
                gameStartTime = Date().timeIntervalSince1970
            }
            bird.physicsBody!.isDynamic = true
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
        } else {
            for touch in touches {
                let location = touch.location(in: self)
                let touchedNode = atPoint(location)
                
                if touchedNode.name == "homeButton" {
                    sceneDelegate?.didTapHomeButton()
                } else if touchedNode.name == "tryAgainButton" {
                    gameOver = false
                    score = 0
                    self.speed = 1
                    self.removeAllChildren()
                    setupGame()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // Function called when game is over/paused
    func gameProgressCalculate() {
        let gameEndTime = Date().timeIntervalSince1970
        var gameDuration = Int(gameEndTime - gameStartTime)
        // handling the case when user never started the game
        if gameStartTime == 0 {
            gameDuration = 0
        }
            
        // Update progress
        let totalGameTime = DataController.shared.section2[0].timing * 60
        let progress = Float(gameDuration) / Float(totalGameTime) * 100
        DataController.shared.updateGameProgress(gameName: "Flappy Bird", progress: progress)
    }
}
