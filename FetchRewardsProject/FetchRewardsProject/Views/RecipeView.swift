//
//  RecipeView.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import SwiftUI

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ForEach(viewModel.recipes, id: \.uuid) { recipe in
            RecipeItem(recipe: recipe)
        }
    }
}

struct RecipeItem: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            Text(recipe.cuisine)
            Spacer()
            Text(recipe.name)
            Spacer()
            Text(recipe.uuid)
        }
    }
}
