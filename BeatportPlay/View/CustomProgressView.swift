//
//  CustomProgressView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 10/12/2021.
//

import SwiftUI

struct CustomProgressView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
            ProgressView("Chargement...")
                .progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .dark ? Color.white : Color.secondary))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.secondary)
                .padding([.leading, .trailing], 1)
                .scaleEffect(1)
        }
    }
}
struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
