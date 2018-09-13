//
//  ApiURL.swift
//  NewsFlyp
//
//  Created by Lohen Yumnam on 05/09/18.
//  Copyright © 2018 Lohen Yumnam. All rights reserved.
//

import Foundation

enum ApiURL: String {
    case homeFeed = "http://www.newsflyp.com/mobile/searchFeed"
    //case homeFeed = "http://www.newsflyp.com/mobile/searchFeed?user=1172186799481825&type=news&q=0,18,12,10,8,6,4,1&page=1&p="
//    http://www.newsflyp.com/mobile/getFeedbyId?id=1213
    case getFeedByID =  "http://www.newsflyp.com/mobile/getFeedbyId"
    case getFeedByIDForWeb = "http://www.newsflyp.com/home/getnews"
}
