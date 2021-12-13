//
//  CustomAlert.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 10/10/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct CustomAlert: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var listVM: ListViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    @State var title: String
    @State var message: String
    @Binding var showAlert: Bool
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.top, 10)
                    .foregroundColor(.red)
                Spacer()
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                Spacer()
                Text(message)
                    .font(.body)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? .white : Color.secondary)
                Spacer()
                Divider()
                Button(action: {
                    self.showAlert = false
                }, label: {
                    Text("OK")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? Color.primary : .black)
                        .frame(width: UIScreen.main.bounds.width/2-30, height: 40)
                })
            }
            .frame(width: UIScreen.main.bounds.width-50, height: 200)
            .background(Material.regular)
            .cornerRadius(12)
            .clipped()
        }
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 1)
    }
}

@available(iOS 15.0, *)
struct CustomAlert_Previews: PreviewProvider {
    @State static var showAlert = true
    static var previews: some View {
        CustomAlert(title: "Alerte", message: "message", showAlert: $showAlert)
    }
}
