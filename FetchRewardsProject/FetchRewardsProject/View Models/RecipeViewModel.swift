//
//  RecipeViewModel.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import Foundation
import UIKit

class RecipeViewModel: ObservableObject {
    private let networkService: NetworkService
    
    @Published var recipes: [Recipe] = []
    @Published var showRecipeUrls: Bool = false
    @Published var error: Error?
    
    var recipeSourceInfo: SourceInfo?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        getRecipes()
    }
    
    func showRecipeSheet(_ recipe: Recipe) {
        recipeSourceInfo = SourceInfo(sourceUrl: recipe.sourceUrl, youtubeUrl: recipe.youtubeUrl)
        showRecipeUrls = true
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = .black
    }
    
    func getRecipes() {
        Task { @MainActor in
            do {
                let recipes = try await networkService.getRecipes()
                self.recipes = recipes.recipes
            } catch {
                self.error = error
            }
        }
    }
}
