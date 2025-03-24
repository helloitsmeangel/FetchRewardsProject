//
//  Recipe.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import Foundation

struct RecipeList: Codable {
    var recipes: [Recipe]
}

struct Recipe: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
