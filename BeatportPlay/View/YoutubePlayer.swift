//
//  YoutubePlayer.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 04/10/2021.
//

import Foundation
import youtube_ios_player_helper
import SwiftUI

struct YouTubePlayer: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return YouTubePlayer.Coordinator(parent: self)
    }
    var playerView: YTPlayerView
    var playTime: (Float) -> Void
    var playDuration: (Double) -> Void
    init(playerView: YTPlayerView, playTime: @escaping(Float) -> Void, playDuration: @escaping(Double) -> Void) {
        self.playerView = playerView
        self.playTime = playTime
        self.playDuration = playDuration
    }
    func makeUIView(context: Context) -> YTPlayerView {
        playerView.delegate = context.coordinator
        return playerView
    }
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
    }
    class Coordinator: NSObject, YTPlayerViewDelegate {
        var parent: YouTubePlayer
        init(parent: YouTubePlayer) {
            self.parent = parent
        }
        func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
            DispatchQueue.main.async {
                self.parent.playTime(playTime)
                playerView.duration { (duration, _) in
                    self.parent.playDuration(duration)
                }
            }
        }
    }
}
