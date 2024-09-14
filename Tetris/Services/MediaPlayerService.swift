//
//  MediaPlayerService.swift
//  Sunetra
//
//  Created by Abid Ali    on 27/05/24.
//

import Foundation
import AVFoundation

class MediaPlayerService : MediaPlayerServiceProtocol{
    private var audioPlayer : AVAudioPlayer!
    
    static var mp3Extension = "mp3"
    
    func play(songName: String, resourceExtension: String) {
        let url = Bundle.main.url(forResource: songName, withExtension: resourceExtension)
        audioPlayer = try! AVAudioPlayer(contentsOf: url!)
        if audioPlayer != nil {
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        }
    }
    
    func stop(){
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
    }

}
