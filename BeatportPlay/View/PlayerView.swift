//
//  PlayerView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 02/10/2021.
//

import SwiftUI
import UIKit
import youtube_ios_player_helper
import AVKit

@available(iOS 15.0, *)
struct PlayerView: View {
    @EnvironmentObject var listVM: ListViewModel
    @ObservedObject private var playerVM = PlayerViewModel()
    @Binding var index: Int
    @Binding var artist: String
    @Binding var title: String
    @Binding var remixers: String
    @Binding var image: String
    @Binding var isPlaying: Bool
    @State private var isExpanded = false
    @State private var value: CGFloat = 50
    @State private var slideDown: CGFloat = 1
    @State private var sliderAction = false
    @State private var playTime: Float = 0.0
    @State private var playDuration: Float = 0.0
    @State private var videoId: String = ""
    var playerView: YTPlayerView
    var height = UIScreen.main.bounds.height/2.5
    var body: some View {
        VStack {
            HStack {
                if isExpanded {
                    Spacer(minLength: 0)
                }
                ZStack {
                    YouTubePlayer(playerView: playerView, playTime: { playTime in
                        self.playTime = playTime
                    }, playDuration: { playDuration in
                        self.playDuration = Float(playDuration)
                    })
                        .frame(width: 0, height: 0)
                    AsyncImage(url: URL(string: image)) {image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: isExpanded ? height: 55, height: isExpanded ? height: 55)
                            .cornerRadius(10)
                            .padding(.top, isExpanded ? 50 : 8)
                            .scaleEffect(slideDown)
                    } placeholder: {
                        Image(systemName: "dot.radiowaves.left.and.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: isExpanded ? height: 55, height: isExpanded ? height: 55)
                            .cornerRadius(10)
                    }
                }
                if !isExpanded {
                    // MARK: - Label artist & title when isn't expanded
                    VStack(alignment: .leading, spacing: 8) {
                        Text(artist)
                            .font(.caption)
                            .fontWeight(.bold)
                        Text(title)
                            .font(.caption)
                    }
                    .frame(width: 220, height: 50, alignment: .leading)
                }
                Spacer(minLength: 8)
                if !isExpanded {
                    // MARK: - Play & go forward 30" buttons when isn't expanded
                    HStack(spacing: 20) {
                        Button(action: {
                            if isPlaying {
                                self.isPlaying = false
                                playerView.pauseVideo()
                            } else {
                                self.isPlaying = true
                                playerView.playVideo()
                            }
                        }, label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.primary )
                        })
                        Button(action: {
                            if isPlaying {
                                playerView.cueVideo(byId: videoId, startSeconds: playTime + 30)
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    playerView.playVideo()
                                })
                            }
                        }, label: {
                            Image(systemName: "goforward.30")
                                .font(.title2)
                                .foregroundColor(.primary )
                        })
                    }
                }
            }
            if isExpanded {
                VStack(alignment: .center, spacing: 8) {
                    // MARK: - Label artist & title when is expanded
                    VStack(spacing: 8) {
                        Text(artist)
                            .font(.title)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Text(title)
                            .font(.title3)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 8)
                    // MARK: - Player buttons when is expanded
                    HStack(spacing: 50) {
                        Button(action: {
                            if isPlaying {
                                playerView.cueVideo(byId: videoId, startSeconds: playTime - 15)
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    playerView.playVideo()
                                })
                            }
                        }, label: {
                            Image(systemName: "gobackward.15")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .frame(width: 50, height: 50)
                        })
                        Button(action: {
                            if isPlaying {
                                self.isPlaying = false
                                playerView.pauseVideo()
                            } else {
                                self.isPlaying = true
                                playerView.playVideo()
                            }
                        }, label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .frame(width: 50, height: 50)
                        })
                        Button(action: {
                            if isPlaying {
                                playerView.cueVideo(byId: videoId, startSeconds: playTime + 30)
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    playerView.playVideo()
                                })
                            }
                        }, label: {
                            Image(systemName: "goforward.30")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .frame(width: 50, height: 50)
                        })
                    }
                    .padding(.top, 30)
                    // MARK: - Slider for playTime & playDuration when is expanded
                    VStack {
                        Slider(value: $playTime, in: 0.0...playDuration, onEditingChanged: { sliderAction in
                            if sliderAction {
                                self.isPlaying = false
                                playerView.pauseVideo()
                                withAnimation {
                                    self.sliderAction = true
                                    self.slideDown = 0.95
                                }
                            } else {
                                self.isPlaying = true
                                    playerView.cueVideo(byId: videoId, startSeconds: playTime)
                                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                        playerView.playVideo()
                                    })
                                withAnimation {
                                    self.sliderAction = false
                                    self.slideDown = 1
                                }
                            }
                        })
                            .accentColor(sliderAction ? .red : Color("top.100.color"))
                            .padding(.top, 30)
                            .padding(.horizontal, 30)
                        // MARK: - PlayTime & playDuration label
                        HStack {
                            Text(String(playerVM.convertTime(playTime)))
                                .font(.caption2)
                                .foregroundColor(.primary)
                            Spacer(minLength: 0)
                            Text(String(playerVM.convertTime(playDuration)))
                                .font(.caption2)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                Spacer()
            }
        }
        // Expandind to full screen when click
        .frame(maxHeight: isExpanded ? .infinity : 50)
        .padding(isExpanded ? 0 : 8)
        .background(Material.ultraThinMaterial)
        .onTapGesture {
            withAnimation(.spring()) {
                self.isExpanded.toggle()
            }
        }
        .onChange(of: artist+title+remixers, perform: { value in
            loadCueVideo(value, index, completionHandler: { value in
                    self.isPlaying = false
                    if value {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.isPlaying = true
                        playerView.playVideo()
                    })
                    }
                })
        })
    }
    func loadCueVideo(_ query: String, _ index: Int, completionHandler: @escaping(Bool) -> Void) {
        if listVM.beatportData[index].video_id == ""{
            // if videoId isn't available on Server, request on youtube API
            playerVM.loadYoutubeVideoId(query, completionHandler: { youtube in
            videoId = youtube.items[0].id.videoId
            playerView.cueVideo(byId: videoId, startSeconds: 0.0)
            completionHandler(true)
        })
        } else {
            print("server")
            // if videoId is available on Server
            videoId = listVM.beatportData[index].video_id
            print(index)
            print(videoId)
            playerView.cueVideo(byId: videoId, startSeconds: 0.0)
            completionHandler(true)
        }
    }
}

@available(iOS 15.0, *)
struct PlayerView_Previews: PreviewProvider {
    @State static var index: Int = 1
    @State static var artist: String = "1"
    @State static var title: String = "2"
    @State static var remixers: String = "3"
    @State static var image: String = "4"
    @State static var isPlaying: Bool = false
    static var previews: some View {
        PlayerView(index: $index, artist: $artist,
                   title: $title, remixers: $remixers,
                   image: $image, isPlaying: $isPlaying, playerView: YTPlayerView())
            .environmentObject(ListViewModel())
    }
}
