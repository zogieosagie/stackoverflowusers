//
//  StackOverflowUser.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 20/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

struct StackOverflowUser : Codable {
    let userName :String
    let imageUrl :String
    let reputation :Int?
    
    var isFollowed = false
    var isBlocked = false
    var isExpanded = false
    var localImageUrl :String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "display_name"
        case imageUrl = "profile_image"
        case reputation
    }
}




