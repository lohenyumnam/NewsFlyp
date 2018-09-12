//
//  HomeFeed.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import Foundation

struct HomeFeed: Codable {
    let feed: [Feed]
    
    enum CodingKeys: String, CodingKey {
        case feed = "feed"
    }
}

struct Feed: Codable {
    let id: String
    let source: String
    let title: String
    let description: String
    let mURL: String
    let likes: String
    let type: String
    let category: String
    let createdOn: String
    let fav: String
    let lk: String
    let xUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case source = "source"
        case title = "title"
        case description = "description"
        case mURL = "mUrl"
        case likes = "likes"
        case type = "type"
        case category = "category"
        case createdOn = "created_on"
        case fav = "fav"
        case lk = "lk"
        case xUrl = "xUrl"
    }
}
