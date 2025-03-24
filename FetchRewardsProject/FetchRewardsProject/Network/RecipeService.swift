//
//  RecipeService.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/23/25.
//

import Foundation

protocol RecipeService {
    func getRecipes() async throws -> RecipeList
}
