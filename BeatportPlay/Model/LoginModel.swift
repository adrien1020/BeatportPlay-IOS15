//
//  LoginModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 10/11/2021.
//

import Foundation

struct LoginModel: Decodable {
    var user_id: Int
    var token: String
    var email: String
    struct Error: Decodable {
        var username: [String]?
        var  password: [String]?
        var non_field_errors: [String]?
    }
    struct Credentials {
        var username: String
        var password: String
    }
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
