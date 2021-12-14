//
//  ContentView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import SwiftUI
import youtube_ios_player_helper

@available(iOS 15.0, *)
struct ContentView: View {
    @EnvironmentObject var listVM: ListViewModel
    @Binding var isPlaying: Bool
    @State var slideMenuBackgroundBlank: CGFloat = 110
    @State var navigationTitle: String = "Main"
    @State var isOpen: Bool = false
    @State var x: CGFloat = 0.0
    @State var width: CGFloat = 0.0
    @State var index: Int = 0
    @State var isSwitched = false
    @State var isIconSwitch = false
    @State var artist = ""
    @State var title = ""
    @State var remixers = ""
    @State var image = ""
    var playerView: YTPlayerView
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                        HStack(spacing: 12) {
                            Button(action: {
                                withAnimation {
                                    self.isOpen.toggle()
                                    self.x = 0
                                }
                            }, label: {
                                Image(systemName: "list.bullet")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.1))
                                    .clipShape(Circle())
                            })
                            Spacer(minLength: 0)
                            Text(navigationTitle)
                                .font(.title3)
                                .fontWeight(.heavy)
                                .lineLimit(1)
                            Spacer(minLength: 0)
                            Button(action: {
                                isIconSwitch.toggle()
                                DispatchQueue.main.async {
                                    withAnimation(.spring(response: 2, dampingFraction: 0.5 )) {
                                        isSwitched.toggle()
                                    }
                                }
                            }, label: {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(isIconSwitch ? Color("top.100.color") : Color.black.opacity(0.1))
                                    .clipShape(Circle())
                            })
                        }
                        .zIndex(1)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .background(Material.ultraThin)
                        ListView(index: $index, artist: $artist,
                                 title: $title, remixers: $remixers,
                                 image: $image, isSwitched: $isSwitched, navigationTitle: $navigationTitle)
                            .offset(x: isOpen ? geometry.size.width - slideMenuBackgroundBlank :0)
                    })
                    PlayerView(index: $index, artist: $artist,
                               title: $title, remixers: $remixers,
                               image: $image, isPlaying: $isPlaying, playerView: playerView)
                    SliderMenuView(slideMenuBackgroundBlank: $slideMenuBackgroundBlank,
                                   navigationTitle: $navigationTitle,
                                   x: $x,
                                   width: $width, isOpen: $isOpen)
                        .offset(x: self.x)
                        .background(Color.black.opacity(x == 0 ? 0.5 :0))
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.isOpen = false
                                self.x = -width
                            }
                        }
                        .onAppear {
                            self.isOpen = false
                            self.x = -geometry.size.width + slideMenuBackgroundBlank
                            self.width = geometry.size.width - slideMenuBackgroundBlank
                        }
                        .onChange(of: geometry.size.width, perform: { value in
                            if isOpen {
                                self.x = 0
                                self.width = value - slideMenuBackgroundBlank
                            } else {
                                self.x = -value + slideMenuBackgroundBlank
                                self.width = value - slideMenuBackgroundBlank
                            }
                        })
                })
                    .blur(radius: listVM.showAlert ? 10 : 0)
                    .disabled(listVM.showAlert)
            }
            if listVM.showAlert {
                CustomAlert(title: "Connection Error:", message: listVM.error, showAlert: $listVM.showAlert)
                    .task {
                        self.listVM.isdownload = false
                    }
            }
            if listVM.isdownload {
                CustomProgressView()
            }
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    @State static var isPlaying = false
    static var previews: some View {
        ContentView(isPlaying: $isPlaying, playerView: YTPlayerView())
            .environmentObject(ListViewModel())
    }
}
