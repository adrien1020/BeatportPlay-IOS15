//
//  LoginViewModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 10/11/2021.
//

import Foundation
import Security

class LoginViewModel: ObservableObject {
    @Published var token: String = ""
    @Published var isAuth = false
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorLogin = LoginModel.Error()
    @Published var error = ""
    func auth(_ url: String, _ username: String, _ password: String) {
        let authBody = "username=\(username)&password=\(password)"
        if let url = URL(string: url) {
            self.isLoading = true
            self.error = ""
            self.errorLogin = LoginModel.Error()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = authBody.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if error == nil {
                    do {
                        let result = try JSONDecoder().decode(LoginModel.self, from: data!)
                        DispatchQueue.main.async {
                            self.token = result.token
                            self.isAuth = true
                            self.isLoading = false
                            self.error = ""
                        }
                    } catch {
                        let errorResult = try? JSONDecoder().decode(LoginModel.Error.self, from: data!)
                        DispatchQueue.main.async {
                            self.errorLogin = errorResult!
                            self.showAlert = true
                            self.isLoading = false
                            self.error = ""
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.error = error!.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                    }
                }
            }
            task.resume()
        }
    }
}
