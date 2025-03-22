//
//  NetworkClient.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/19/25.
//

import Foundation

class NetworkClient: NetworkService {
    
    enum NetworkError: Error {
        case invalidURL
        case apiError
    }
    
    enum APIPath: String {
        case recipe = "/recipes.json"
        case malformed = "/recipes-malformed.json"
        case empty = "/recipes-empty.json"
    }
    
    private static let basePath = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    private func buildUrl(_ urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    private func getRequest(path: String) throws -> URLRequest {
        let requestUrl = try buildUrl(path)
        let request = URLRequest(url: requestUrl)
        
        return request
    }
    
    func getRecipes() async throws -> RecipeList {
        let recipeRequest = try getRequest(path: Self.basePath + APIPath.recipe.rawValue)
        let (data, response) = try await URLSession.shared.data(for: recipeRequest)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 300 else {
            throw NetworkError.apiError
        }
        
        let jsonDecoder = JSONDecoder()
        let recipeList = try jsonDecoder.decode(RecipeList.self, from: data)
        
        return recipeList
    }
}
