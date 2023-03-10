//
//  Show.swift
//  Test1
//
//  Created by yash pindiwala on 2023-02-18.
//

import Foundation

struct TVShow: Codable,Hashable{
    var trackName: String
    var collectionName: String
    var shortDescription: String
    var longDescription: String
    var trackPrice: Double
    var collectionPrice: Double
    var contentAdvisoryRating: String?
    var artworkUrl100: String
}
