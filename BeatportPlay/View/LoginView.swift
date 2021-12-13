//
//  LoginView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 10/11/2021.
//

import SwiftUI
import youtube_ios_player_helper

@available(iOS 15.0, *)
struct LoginView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var listVM = ListViewModel()
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 60) {
                        Image("beatport.logo.title")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        VStack(spacing: 35) {
                            VStack(spacing: 25) {
                                TextField("Username", text: $username)
                                    .textContentType(.username)
                                    .textCase(.lowercase)
                                    .padding()
                                    .frame(height: 40)
                                    .multilineTextAlignment(.center)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                                SecureField("Password", text: $password)
                                    .textContentType(.password)
                                    .textCase(.lowercase)
                                    .padding()
                                    .frame(height: 40)
                                    .multilineTextAlignment(.center)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            }
                            .padding(.horizontal, 30)
                            VStack(spacing: 25) {
                                Button(action: {
                                    loginVM.auth("https://beatportapi.herokuapp.com/api/auth/", username, password)
                                }, label: {
                                    ZStack {
                                        if loginVM.isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                                        } else {
                                            Text("Log In")
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .frame(width: 150, height: 32, alignment: .center)
                                    .foregroundColor(Color.white)
                                    .font(.title3)
                                    .background(Color("top.100.color"))
                                    .cornerRadius(10)
                                })
                                    .disabled(loginVM.isLoading)
                                HStack {
                                    Text("Don't have an account?")
                                        .foregroundColor(.secondary)
                                    NavigationLink(destination: RegisterView()) {
                                        Text("Sign Up")
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            .disabled(loginVM.showAlert)
                        }
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
                .blur(radius: loginVM.showAlert ? 10 : 0)
            }
            if loginVM.showAlert {
                if loginVM.errorLogin.username != nil {
                    CustomAlert(title: "Username:", message: loginVM.errorLogin.username![0],
                                showAlert: $loginVM.showAlert)
                } else if loginVM.errorLogin.password != nil {
                    CustomAlert(title: "Password:", message: loginVM.errorLogin.password![0],
                                showAlert: $loginVM.showAlert)
                } else if loginVM.errorLogin.non_field_errors != nil {
                    CustomAlert(title: "Error:", message: loginVM.errorLogin.non_field_errors![0],
                                showAlert: $loginVM.showAlert)
                } else {
                    CustomAlert(title: "Connection Error:", message: loginVM.error,
                                showAlert: $loginVM.showAlert)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}
