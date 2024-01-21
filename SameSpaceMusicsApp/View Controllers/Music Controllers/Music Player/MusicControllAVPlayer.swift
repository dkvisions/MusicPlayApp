//
//  MusicControllAVPlayer.swift
//  SameSpaceMusicsApp
//
//  Created by Aditya Vinay Juvekar on 21/01/24.
//

import Foundation
import AVFoundation
import UIKit


enum PlayBackError: Error {
    case fileNotExists
    case canNotPlay
}


class MusicControllAVPlayer: NSObject, AVAudioPlayerDelegate {
    
    
    static let shared = MusicControllAVPlayer()
    
    
    var isMusicStillPlaying:((UIImage, String, Bool, UIColor) -> ()) = { _,_,
        _,_ in }
    var didFinishPlaying:((Bool) -> ()) = { _ in }
    var didFinishPlayingDash:(() -> ()) = { }
    
    var avPlayer: AVAudioPlayer!
    override init() {
        super.init()
    }
    
    
    func startMusicAvPlayer(path: String) throws -> String {
        
        let url = URL(fileURLWithPath: path)
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                avPlayer = try AVAudioPlayer(contentsOf: url)
                
                avPlayer.delegate = self
    
                avPlayer?.play()
                
                return getDuration()
                
            } catch let error {
                print(error.localizedDescription)
                throw error
            }
        } else {
            throw PlayBackError.fileNotExists
        }
        
    }
    
    
    func getDuration(currenTime: Bool = false) -> String {
        let durartionSecond = Int(currenTime ? avPlayer.currentTime : avPlayer.duration)
        let second = durartionSecond % 60
        let secondString = second < 10 ? "0\(second)" : "\(second)"
        let minute = durartionSecond / 60
        return "\(minute):\(secondString)"
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
        didFinishPlayingDash()
    }
    
}
