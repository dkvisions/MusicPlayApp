//
//  MusicControllAVPlayer.swift
//  SameSpaceMusicsApp
//
//  Created by Aditya Vinay Juvekar on 21/01/24.
//

import Foundation
import AVFoundation


enum PlayBackError: Error {
    case fileNotExists
    case canNotPlay
}


class MusicControllAVPlayer: NSObject, AVAudioPlayerDelegate {
    
    
    static let shared = MusicControllAVPlayer()

    var didFinishPlaying:((Bool) -> ()) = { _ in }
    
    var avPlayer: AVAudioPlayer!
    override init() {
        super.init()
    }
    
    
    func startMusicAvPlayer(path: String) throws {
        
        let url = URL(fileURLWithPath: path)
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                avPlayer = try AVAudioPlayer(contentsOf: url)
                
                avPlayer.delegate = self
                avPlayer?.play()
                
            } catch let error {
                print(error.localizedDescription)
                throw error
            }
        } else {
            throw PlayBackError.fileNotExists
        }
        
    }
    
    func pause() {
        guard let avPlayer = avPlayer else { return }
        avPlayer.pause()
    }
    
    func play() {
        guard let avPlayer = avPlayer else { return }
        avPlayer.play()
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying(flag)
    }
    
}
