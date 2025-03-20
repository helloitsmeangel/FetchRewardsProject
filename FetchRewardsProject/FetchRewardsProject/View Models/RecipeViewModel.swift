//
//  RecipeViewModel.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    private let networkService: NetworkService
    
    @Published var recipes: [Recipe] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        getRecipes()
    }
    
    func getRecipes() {
        Task {
            let recipes = try await networkService.recipes()
            self.recipes = recipes.recipes
        }
    }
}
