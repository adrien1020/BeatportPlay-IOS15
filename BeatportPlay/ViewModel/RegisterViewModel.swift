//
//  RegisterViewModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 11/11/2021.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var token: String = ""
    @Published var isRegister = false
    @Published var isLoading = false
    @Published var errorData = RegisterModel.Error()
    @Published var showAlert = false
    @Published var error = ""
    func register(_ url: String, _ username: String,
                  _ firstName: String, _ lastName: String,
                  _ email: String, _ password: String) {
        let authBody = "username=\(username)&first_name=\(firstName)&last_name=\(lastName)&email=\(email)&password=\(password)"
        if let url = URL(string: url) {
            self.isLoading = true
            self.isRegister = false
            self.errorData = RegisterModel.Error()
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = authBody.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if error == nil {
                    do {
                        let result = try JSONDecoder().decode(RegisterModel.self, from: data!)
                        DispatchQueue.main.async {
                            print(result)
                            self.isRegister = true
                            self.isLoading = false
                            self.showAlert = true
                            self.error = ""
                        }
                    } catch {
                        let resultError = try? JSONDecoder().decode(RegisterModel.Error.self, from: data!)
                        DispatchQueue.main.async {
                            self.errorData = resultError!
                            self.showAlert = true
                            self.isLoading = false
                            self.error = ""
                            self.isRegister = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        print(error!.localizedDescription)
                        self.error = error!.localizedDescription
                        self.showAlert = true
                        self.isLoading = false
                        self.isRegister = false
                    }
                }
            }
            task.resume()
        }
    }
}
