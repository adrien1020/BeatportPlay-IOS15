//
//  ListView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct ListView: View {
    @EnvironmentObject var listVM: ListViewModel
    @Binding var index: Int
    @Binding var artist: String
    @Binding var title: String
    @Binding var remixers: String
    @Binding var image: String
    @Binding var isSwitched: Bool
    @Binding var navigationTitle: String
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var body: some View {
        ScrollView {
            if !isSwitched {
                LazyVStack(spacing: 8) {
                    ForEach(listVM.beatportData.sorted { $0.id < $1.id }, id: \.self) {item in
                        CellHelper(rang: String(item.id), artist: item.artist, title: item.title, imageURL: item.image)
                            .onTapGesture {
                                self.index = item.id-1
                                self.artist = item.artist
                                self.title = item.title
                                self.remixers = item.remixers
                                self.image = item.image
                            }
                        Divider()
                    }
                }
                .padding(.top, 70)
                .padding(.bottom, 80)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(listVM.beatportData, id: \.self) { item in
                        AsyncImage(url: URL(string: item.image)) {image in
                            image
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width-50)/2, height: 160)
                                .cornerRadius(15)
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: (UIScreen.main.bounds.width-50)/2, height: 180)
                                .cornerRadius(15)
                                .foregroundColor(Color.gray.opacity(0.2))
                        }
                        .onTapGesture {
                            self.index = item.id-1
                            self.artist = item.artist
                            self.title = item.title
                            self.remixers = item.remixers
                            self.image = item.image
                        }
                    }
                }
                .padding(.top, 70)
                .padding(.bottom, 80)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
            }
        }
    }
}
