
//
//  ViewController.swift
//  Eyes Tracking
//


//

import UIKit
import SceneKit
import ARKit
import AVKit
import AVFoundation

class ballTrackingViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var gameStartTime: TimeInterval = 0
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var playerControllerView: UIView!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyePositionIndicatorCenterView: UIView!
    @IBOutlet weak var blurBarView: UIVisualEffectView!
    @IBOutlet weak var lookAtPositionXLabel: UILabel!
    @IBOutlet weak var lookAtPositionYLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var faceNode: SCNNode = SCNNode()
    
    var eyeLNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var eyeRNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.2)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.blue
        let node = SCNNode()
        node.geometry = geometry
        node.eulerAngles.x = -.pi / 2
        node.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(node)
        return parentNode
    }()
    
    var lookAtTargetEyeLNode: SCNNode = SCNNode()
    var lookAtTargetEyeRNode: SCNNode = SCNNode()
    
    // actual physical size of iPhoneX screen
    let phoneScreenSize = CGSize(width: 0.0623908297, height: 0.135096943231532)
    
    // actual point size of iPhoneX screen
    let phoneScreenPointSize = CGSize(width: 375, height: 812)
    
    var virtualPhoneNode: SCNNode = SCNNode()
    
    var virtualScreenNode: SCNNode = {
        
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        
        return SCNNode(geometry: screenGeometry)
    }()
    
    var eyeLookAtPositionXs: [CGFloat] = []
    
    var eyeLookAtPositionYs: [CGFloat] = []
    var playerViewController: AVPlayerViewController!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    var player: AVPlayer?
        var timers: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerViewController = AVPlayerViewController()
                addChild(playerViewController)
        playerViewController.view.frame = playerControllerView.bounds
        playerControllerView.addSubview(playerViewController.view)
                playerViewController.didMove(toParent: self)
                
                // Load the video
        if let videoURL = Bundle.main.url(forResource: "eye_exercise", withExtension: "mp4") {
                    player = AVPlayer(url: videoURL)
                    playerViewController.player = player
            playerViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                        playerViewController.view.bounds = CGRect(x: 0, y: 0, width: playerControllerView.bounds.height, height: playerControllerView.bounds.width)
            
            playerViewController.showsPlaybackControls = false
            player?.pause()
          
                
                } else {
                    print("Video file not found.")
                }
        playerControllerView.bringSubviewToFront(playButton)
        playerControllerView.bringSubviewToFront(homeButton)
        playerControllerView.bringSubviewToFront(timer)
        
                
        
        // Setup Design Elements
        eyePositionIndicatorView.layer.cornerRadius = eyePositionIndicatorView.bounds.width / 2
        sceneView.layer.cornerRadius = 28
        eyePositionIndicatorCenterView.layer.cornerRadius = 4
        
        blurBarView.layer.cornerRadius = 36
        blurBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        // Setup Scenegraph
        sceneView.scene.rootNode.addChildNode(faceNode)
        sceneView.scene.rootNode.addChildNode(virtualPhoneNode)
        virtualPhoneNode.addChildNode(virtualScreenNode)
        faceNode.addChildNode(eyeLNode)
        faceNode.addChildNode(eyeRNode)
        eyeLNode.addChildNode(lookAtTargetEyeLNode)
        eyeRNode.addChildNode(lookAtTargetEyeRNode)
        
        // Set LookAtTargetEye at 2 meters away from the center of eyeballs to create segment vector
        lookAtTargetEyeLNode.position.z = 2
        lookAtTargetEyeRNode.position.z = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        
        update(withFaceAnchor: faceAnchor)
    }
    
    // MARK: - update(ARFaceAnchor)
    
    func update(withFaceAnchor anchor: ARFaceAnchor) {
        
        eyeRNode.simdTransform = anchor.rightEyeTransform
        eyeLNode.simdTransform = anchor.leftEyeTransform
        
        var eyeLLookAt = CGPoint()
        var eyeRLookAt = CGPoint()
        
        let heightCompensation: CGFloat = 312
        
        DispatchQueue.main.async {

            // Perform Hit test using the ray segments that are drawn by the center of the eyeballs to somewhere two meters away at direction of where users look at to the virtual plane that place at the same orientation of the phone screen
            
            let phoneScreenEyeRHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.lookAtTargetEyeRNode.worldPosition, to: self.eyeRNode.worldPosition, options: nil)
            
            let phoneScreenEyeLHitTestResults = self.virtualPhoneNode.hitTestWithSegment(from: self.lookAtTargetEyeLNode.worldPosition, to: self.eyeLNode.worldPosition, options: nil)
            
            for result in phoneScreenEyeRHitTestResults {
                
                eyeRLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeRLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            for result in phoneScreenEyeLHitTestResults {
                
                eyeLLookAt.x = CGFloat(result.localCoordinates.x) / (self.phoneScreenSize.width / 2) * self.phoneScreenPointSize.width
                
                eyeLLookAt.y = CGFloat(result.localCoordinates.y) / (self.phoneScreenSize.height / 2) * self.phoneScreenPointSize.height + heightCompensation
            }
            
            // Add the latest position and keep up to 8 recent position to smooth with.
            let smoothThresholdNumber: Int = 10
            self.eyeLookAtPositionXs.append((eyeRLookAt.x + eyeLLookAt.x) / 2)
            self.eyeLookAtPositionYs.append(-(eyeRLookAt.y + eyeLLookAt.y) / 2)
            self.eyeLookAtPositionXs = Array(self.eyeLookAtPositionXs.suffix(smoothThresholdNumber))
            self.eyeLookAtPositionYs = Array(self.eyeLookAtPositionYs.suffix(smoothThresholdNumber))
            
            let smoothEyeLookAtPositionX = self.eyeLookAtPositionXs.average!
            let smoothEyeLookAtPositionY = self.eyeLookAtPositionYs.average!
            
            // update indicator position
            self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: smoothEyeLookAtPositionX, y: smoothEyeLookAtPositionY)
            
            // update eye look at labels values
            self.lookAtPositionXLabel.text = "\(Int(round(smoothEyeLookAtPositionX + self.phoneScreenPointSize.width / 2)))"
            
            self.lookAtPositionYLabel.text = "\(Int(round(smoothEyeLookAtPositionY + self.phoneScreenPointSize.height / 2)))"
            
            // Calculate distance of the eyes to the camera
            let distanceL = self.eyeLNode.worldPosition - SCNVector3Zero
            let distanceR = self.eyeRNode.worldPosition - SCNVector3Zero
            
            // Average distance from two eyes
            let distance = (distanceL.length() + distanceR.length()) / 2
            
            // Update distance label value
            self.distanceLabel.text = "\(Int(round(distance * 100))) cm"
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        virtualPhoneNode.transform = (sceneView.pointOfView?.transform)!
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        update(withFaceAnchor: faceAnchor)
    }
    
    @IBAction func homeTapped(_ sender: UIButton) {
        gameProgressCalculate()
//        print("home")
        player?.pause()
        playButton.setTitle("Play", for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        guard let player = player else { return }
            if player.timeControlStatus == .playing {
                gameProgressCalculate()
//                print("paused")
                player.pause()
                playButton.setTitle("Play", for: .normal)
                timers?.invalidate()
            } else {
                gameStartTime = Date().timeIntervalSince1970
//                print("play start")
                player.play()
                playButton.setTitle("Pause", for: .normal)
                startTimer()
            }
            // Update timer immediately after pressing play button
            updateTimer()
    }
    func startTimer() {
        timers?.invalidate()
                timers = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
        @objc func updateTimer() {
            guard let player = player else { return }
                let currentTime = player.currentTime().seconds
                let duration = player.currentItem?.duration.seconds ?? 0
                let remainingTime = duration - currentTime
                timer.text = formatTime(remainingTime)
        }
        
        func formatTime(_ timeInterval: TimeInterval) -> String {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter.string(from: timeInterval) ?? ""
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
        let totalGameTime = DataController.shared.section2[2].timing * 60
        let progress = (Float(gameDuration) / Float(totalGameTime)) * 100

        // Update game progress in DataController
        DataController.shared.updateGameProgress(gameName: "Ball Tracking", progress: progress)
    }
    
}
