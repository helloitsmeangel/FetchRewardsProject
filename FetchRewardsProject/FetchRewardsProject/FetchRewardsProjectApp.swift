//
//  FetchRewardsProjectApp.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import SwiftUI

@main
struct FetchRewardsProjectApp: App {
    var body: some Scene {
        WindowGroup {
            RecipeView(viewModel: RecipeViewModel(networkService: NetworkClient()))
        }
    }
}
