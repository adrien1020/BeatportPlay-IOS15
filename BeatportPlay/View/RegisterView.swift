//
//  RegisterView.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 11/11/2021.
//

import SwiftUI

@available(iOS 15.0, *)
struct RegisterView: View {
    @ObservedObject private var registerVM = RegisterViewModel()
    @State private var userName: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top), content: {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                        .padding(.leading, 10)
                }).zIndex(1)
                ZStack {
                    VStack {
                        Image("beatport.logo.title")
                            .resizable()
                            .scaledToFit()
                            .padding()
                        VStack(spacing: 25) {
                            TextField("Username", text: $userName)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 40)
                                .multilineTextAlignment(.center)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            TextField("First Name", text: $firstName)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 40)
                                .multilineTextAlignment(.center)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            TextField("Last Name", text: $lastName)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 40)
                                .multilineTextAlignment(.center)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            TextField("Email", text: $email)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 40)
                                .multilineTextAlignment(.center)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            SecureField("Password", text: $password)
                                .textCase(.lowercase)
                                .padding()
                                .frame(height: 40)
                                .multilineTextAlignment(.center)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: -5)
                            Button(action: {
                                registerVM.register("https://beatportapi.herokuapp.com/api/register/",
                                                    userName, firstName, lastName, email, password)
                                hideKeyboard()
                            }, label: {
                                ZStack {
                                    if registerVM.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
                                    } else {
                                        Text("Sign Up")
                                            .fontWeight(.bold)
                                    }
                                }
                                .frame(width: 150, height: 32, alignment: .center)
                                .foregroundColor(Color.white)
                                .font(.title3)
                                .background(Color("top.100.color"))
                                .cornerRadius(10)
                            })
                                .disabled(registerVM.isLoading)
                        }
                        .padding(.horizontal, 30)
                        Spacer()
                    }
                }
                .navigationBarHidden(true)
            })
                .disabled(registerVM.showAlert)
                .blur(radius: registerVM.showAlert ? 10 : 0)
            if registerVM.showAlert {
                if registerVM.errorData.username != nil {
                    CustomAlert(title: "Username:", message: registerVM.errorData.username![0],
                                showAlert: $registerVM.showAlert)
                } else if registerVM.errorData.first_name != nil {
                    CustomAlert(title: "First Name:", message: registerVM.errorData.first_name![0],
                                showAlert: $registerVM.showAlert)
                } else if registerVM.errorData.last_name != nil {
                    CustomAlert(title: "Last Name:", message: registerVM.errorData.last_name![0],
                                showAlert: $registerVM.showAlert)
                } else if registerVM.errorData.email != nil {
                    CustomAlert(title: "Email:", message: registerVM.errorData.email![0],
                                showAlert: $registerVM.showAlert)
                } else if registerVM.errorData.password != nil {
                    CustomAlert(title: "Password:", message: registerVM.errorData.password![0],
                                showAlert: $registerVM.showAlert)
                } else if registerVM.error != "" {
                    CustomAlert(title: "Connection Error", message: registerVM.error,
                                showAlert: $registerVM.showAlert)
                } else if registerVM.isRegister {
                    CustomAlert(title: "Success", message: "Your account is created",
                                showAlert: $registerVM.showAlert)
                }
            }
        }
        .onChange(of: registerVM.isRegister && !registerVM.showAlert, perform: { _ in

            presentationMode.wrappedValue.dismiss()
        })
        .onTapGesture {
            hideKeyboard()
        }
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

@available(iOS 15.0, *)
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
