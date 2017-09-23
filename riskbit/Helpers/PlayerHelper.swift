////
////  PlayerHelper.swift
////  proto
////
////  Created by Alexander Murphy on 11/10/16.
////  Copyright © 2016 Alexander Murphy. All rights reserved.
////
//
//import Player
//import UIKit
//
//class PlayerHelper {
//    func configureVideoPlayer(playerInstance: Player) {
//        self.view.autoresizingMask = ([UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight])
//        playerInstance.delegate = self
//        playerInstance.view.frame = self.optionOneVideoView.bounds
//        self.addChildViewController(playerInstance)
//        self.optionOneImageView.addSubview(playerInstance.view)
//        playerInstance.didMove(toParentViewController: self)
//        playerInstance.playbackLoops = false
//        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
//        tapGestureRecognizer.numberOfTapsRequired = 1
//        playerInstance.view.addGestureRecognizer(tapGestureRecognizer)
//    }
//    
//    func playVideo(videoURL: URL, playerInstance: Player) {
//        print("now playing video", videoURL)
//        playerInstance.setUrl(videoURL)
//        playerInstance.playFromBeginning()
//    }
//    
//    // MARK: UIGestureRecognizer
//    
//    func handleTapGestureRecognizer(_ gestureRecognizer: UITapGestureRecognizer) {
//        switch (self.player.playbackState.rawValue) {
//        case PlaybackState.stopped.rawValue:
//            self.player.playFromBeginning()
//        case PlaybackState.paused.rawValue:
//            self.player.playFromCurrentTime()
//        case PlaybackState.playing.rawValue:
//            self.player.pause()
//        case PlaybackState.failed.rawValue:
//            self.player.pause()
//        default:
//            self.player.pause()
//        }
//    }
//    
//    // MARK: PlayerDelegate
//    
//    func playerReady(_ player: Player) {
//    }
//    
//    func playerPlaybackStateDidChange(_ player: Player) {
//    }
//    
//    func playerBufferingStateDidChange(_ player: Player) {
//    }
//    
//    func playerPlaybackWillStartFromBeginning(_ player: Player) {
//    }
//    
//    func playerPlaybackDidEnd(_ player: Player) {
//    }
//    
//    func playerCurrentTimeDidChange(_ player: Player) {
//    }
//    
//    func playerWillComeThroughLoop(_ player: Player) {
//        
//    }
//}
