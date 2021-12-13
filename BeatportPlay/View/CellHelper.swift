//
//  CellHelper.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct CellHelper: View {
    @EnvironmentObject var listVM: ListViewModel
    @State var rang: String
    @State var artist: String
    @State var title: String
    @State var imageURL: String
    var body: some View {
        // MARK: - CustomCell with image, rang, artist & title Label
            HStack {
                AsyncImage(url: URL(string: imageURL)) {image in
                    image
                        .resizable()
                        .frame(width: 75, height: 75)
                        .scaledToFit()
                        .cornerRadius(10)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.gray.opacity(0.2))
                        .frame(width: 75, height: 75)
                        .scaledToFit()
                        .cornerRadius(10)
                }
                // MARK: - Rang, artist & title Label
                HStack {
                    Text(rang)
                        .frame(width: 30)
                    // MARK: - Artist & title Label
                    VStack(alignment: .leading, spacing: 12) {
                        Text(artist.capitalized)
                            .fontWeight(.regular)
                            .lineLimit(2)
                        Text(title.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 12)
    }
}

@available(iOS 15.0, *)
struct CellHelper_Previews: PreviewProvider {
    @State static var rang =  "50"
    @State static var artist =  "Michael Jackson"
    @State static var title =  "Billie Jean"
    @State static var imageURL =  "1223"
    static var previews: some View {
        CellHelper(rang: rang, artist: artist, title: title, imageURL: imageURL)
    }
}
