//
//  RegisterModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 11/11/2021.
//

import Foundation

struct RegisterModel: Decodable {
    var username: String
    var password: String
    var email: String
    var first_name: String
    var last_name: String
    struct Error: Decodable {
        var username: [String]?
        var password: [String]?
        var email: [String]?
        var first_name: [String]?
        var last_name: [String]?
    }
}
