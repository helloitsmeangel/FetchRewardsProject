//
//  RecipeViewModel.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import Foundation
import UIKit

class RecipeViewModel: ObservableObject {
    private let recipeNetworkService: RecipeService
    
    @Published var recipes: [Recipe] = []
    @Published var showRecipeUrls: Bool = false
    @Published var error: Error?
    
    var tappedRecipe: Recipe?
    
    init(recipeNetworkService: RecipeService) {
        self.recipeNetworkService = recipeNetworkService
        
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = .gray
    }
    
    func didTapOnRecipe(_ recipe: Recipe) {
        tappedRecipe = recipe
        showRecipeUrls = true
    }
    
    func getRecipes() {
        Task { @MainActor in
            do {
                let recipes = try await recipeNetworkService.getRecipes()
                self.recipes = recipes.recipes
            } catch {
                self.error = error
            }
        }
    }
}
