//
//  DataSourceModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 30/09/2021.
//

import Foundation

struct DataSourceModel: Identifiable, Decodable {
    let id: Int
    let genre: String
    let website: String
    let api: String
}
