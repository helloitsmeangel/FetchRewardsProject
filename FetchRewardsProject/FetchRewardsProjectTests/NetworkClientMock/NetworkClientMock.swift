//
//  NetworkClientMock.swift
//  FetchRewardsProjectTests
//
//  Created by Angel Castaneda on 3/23/25.
//

import Foundation

@testable import FetchRewardsProject

final class NetworkClientMock: Mockable, NetworkService, RecipeService {
    func getRecipes() async throws -> FetchRewardsProject.RecipeList {
        return try await fetch(path: "TestRecipesResponse")
    }
    
    func fetch<T: Codable>(path: String) async throws -> T {
        return loadJSON(filename: path, type: T.self)
    }
}
