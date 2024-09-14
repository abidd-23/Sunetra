//
//  TetrisMainViewController.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import UIKit

class TetrisMainViewController: UIViewController, GameServiceDelegate {
    
    var gameStartTime: TimeInterval = 0
    
    private var boardViewController = BoardViewController()
    private var nextTetrominoViewController = NextTetrominoViewController()
    private var mediaPlayerService : MediaPlayerServiceProtocol! = nil
    private var gameService : GameServiceProtocol! = nil
    private var buttonFireModeTimer: Timer?
    private var fireTimerInterval: Float = 0.1
    private let defaults = UserDefaults.standard
    
    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var gameView: UIView!
    
    @IBOutlet var rightButton: UIButton!
    
    @IBOutlet var downButton: UIButton!
    
    @IBOutlet var leftButton: UIButton!
    
    @IBOutlet var currentScoreLabel: UILabel!
    
    @IBOutlet var bestScoreLabel: UILabel!
    
    
    @IBOutlet var nextTetrominoView: UIView!
    
    @IBOutlet var gameOverButton: UIButton!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.add(boardViewController, view: gameView)
        self.add(nextTetrominoViewController, view: nextTetrominoView)
        
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        
        if defaults.object(forKey: StoreKeys.audioIsEnabled) == nil{
            defaults.set(true, forKey: StoreKeys.audioIsEnabled)
        }


        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        addServicesToLocator()
        loadDependencies()
        setScoreLabels()
    }
    private func addServicesToLocator(){
        ServiceLocator.shared.addService(service: TimerService())
        ServiceLocator.shared.addService(service: BoardService())
        ServiceLocator.shared.addService(service: TetrominoHelper())
        ServiceLocator.shared.addService(service: MediaPlayerService())
        ServiceLocator.shared.addService(service: GameService())
    }
    public func loadDependencies(mediaPlayerService : MediaPlayerServiceProtocol? = nil,
                                 gameService : GameServiceProtocol? = nil){
        self.mediaPlayerService = mediaPlayerService ?? ServiceLocator.shared.getService()! as MediaPlayerServiceProtocol
        self.gameService = gameService ?? ServiceLocator.shared.getService()! as GameServiceProtocol
        self.gameService.delegate = self
    }
    private func setScoreLabels(){
        bestScoreLabel.text = String(defaults.integer(forKey: StoreKeys.bestScore))
        currentScoreLabel.text = String(0)
    }
    @objc private func leftButtonPressed(_ sender: UIButton) {
        askMovement(.left)
    }
    
    @objc private func rightButtonPressed(_ sender: UIButton) {
        askMovement(.right)
    }
    
    @objc private func downButtonPressed(_ sender: UIButton) {
        askMovement(.down)
    }
    private func askMovement(_ direction: MovementDirectionEnum){
        var selector: Selector?
        switch direction {
        case .left:
            askLeftMovement()
            selector = #selector(askLeftMovement)
        case .right:
            askRightMovement()
            selector = #selector(askRightMovement)
        case .down:
            askDownMovement()
            selector = #selector(askDownMovement)
        case .rotation:
            askRotation()
        }
        
        if selector != nil {
            buttonFireModeTimer = Timer.scheduledTimer(timeInterval: TimeInterval(fireTimerInterval), target: self, selector: selector!, userInfo: nil, repeats: true)
        }
    }
    @objc private func askLeftMovement() {
        gameService.moveLeft()
    }
    
    @objc private func askRightMovement() {
        gameService.moveRight()
    }
    
    @objc private func askDownMovement() {
        gameService.moveDown()
    }
    
    private func askRotation(){
        gameService.rotate()
    }

    @objc private func buttonReleased() {
        buttonFireModeTimer?.invalidate()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        gameStartTime = Date().timeIntervalSince1970
        if gameService.currentState == .stopped{
            gameOverButton.isHidden = true
            if defaults.bool(forKey: StoreKeys.audioIsEnabled){
                mediaPlayerService.play(songName: SongKeys.backgroundSong, resourceExtension: MediaPlayerService.mp3Extension)
            }
            setScoreLabels()
            gameService.startGame()
            nextTetrominoViewController.drawNextTetromino(gameService.nextTetromino!)
            boardViewController.clearBoard()
            boardViewController.startBoard()
        }
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        gameProgressCalculate()
        mediaPlayerService.stop()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "mainHome")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)

    }
    
    @IBAction func rotateButtonPressed(_ sender: UIButton) {
        askMovement(.rotation)
    }
    func tetrominoHasMoved() {
        boardViewController.drawTetrominoMovement()
    }
    
    func newTetrominoAdded() {
        nextTetrominoViewController.drawNextTetromino(gameService.nextTetromino!)
        boardViewController.drawNewTetrominoAdded()
    }
    
    func gameOver() {
        gameOverButton.isHidden = false
        mediaPlayerService.stop()
        if gameService.currentScore > defaults.integer(forKey: StoreKeys.bestScore){
            defaults.set(gameService.currentScore, forKey: StoreKeys.bestScore)
        }
    }
    
    func fullRowCleared() {
        boardViewController.drawEntireBoard()
        currentScoreLabel.text = String(gameService.currentScore)
    }
    
    // Function called when game is over/paused
    func gameProgressCalculate() {
        let gameEndTime = Date().timeIntervalSince1970
        var gameDuration = Int(gameEndTime - gameStartTime)
        // handling the case when user never started the game
        if gameStartTime == 0 {
            gameDuration = 0
        }

        // Calculate new progress
        let totalGameTime = DataController.shared.section2[1].timing * 60
        let progress = (Float(gameDuration) / Float(totalGameTime)) * 100

        // Update game progress in DataController
        DataController.shared.updateGameProgress(gameName: "Tetris", progress: progress)
    }
}
