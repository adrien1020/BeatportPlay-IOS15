//
//  BeatportPlayApp.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import SwiftUI
import youtube_ios_player_helper

@main
@available(iOS 15.0, *)
struct BeatportPlayApp: App {
    var playerView = YTPlayerView()
    @StateObject var loginVM = LoginViewModel()
    @StateObject var listVM = ListViewModel()
    @State var isPlaying: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            if !loginVM.isAuth {
                LoginView()
                    .environmentObject(loginVM)
            } else {
                ContentView(isPlaying: $isPlaying, playerView: playerView)
                    .environmentObject(listVM)
                    .environmentObject(loginVM)
                    .task {
                        playerView.load(withVideoId: "", playerVars: ["playsinline": 1])
                        listVM.getBeatPortData("https://beatportapi.herokuapp.com/api/beatport-top100-main/",
                                               loginVM.token)
                    }
                    .onChange(of: scenePhase) { phase in
                        if phase == .active {
                            print("active")
                        } else if phase == .background {
                            print("background")
                            self.isPlaying = false
                        } else if phase == .inactive {
                            print("is inactive")
                        } else {
                            print("error")
                        }
                    }
            }
        }
    }
}
