//
//  BeatportModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 29/09/2021.
//

import Foundation

struct BeatPortModel: Decodable, Hashable {
    let id: Int
    let artist: String
    let title: String
    let remixers: String
    let video_id: String
    let image: String
    let label: String
    let genre: String
    let release_date: String
}
