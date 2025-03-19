//
//  RecipeViewModel.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe]
    
    init() {
        self.recipes = [
            Recipe(cuisine: "Test Cuisine 1", name: "Test Recipe 1", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "1", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Test Cuisine 2", name: "Test Recipe 2", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "2", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Test Cuisine 3", name: "Test Recipe 3", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "3", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Test Cuisine 4", name: "Test Recipe 4", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "4", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Test Cuisine 5", name: "Test Recipe 5", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "5", sourceUrl: nil, youtubeUrl: nil),
            Recipe(cuisine: "Test Cuisine 6", name: "Test Recipe 6", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "6", sourceUrl: nil, youtubeUrl: nil)
        ]
    }
}
