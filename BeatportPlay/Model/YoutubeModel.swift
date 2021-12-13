//
//  YoutubeModel.swift
//  BeatportPlay
//
//  Created by Adrien Surugue on 04/10/2021.
//

import Foundation

struct YoutubeModel: Decodable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    let items: [Items]
}
struct PageInfo: Decodable {
    let totalResults: Int
    let resultsPerPage: Int
}
struct Items: Decodable {
    let kind: String
    let etag: String
    let id: Id
}
struct Id: Decodable {
    let kind: String
    let videoId: String
}
