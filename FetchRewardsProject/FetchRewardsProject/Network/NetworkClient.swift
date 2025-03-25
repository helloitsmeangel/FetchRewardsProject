//
//  NetworkClient.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/19/25.
//

import Foundation

class NetworkClient: NetworkService, RecipeService {
    
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case apiError
        case decodeError
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .apiError:
                return "There was a problem with the server."
            case .decodeError:
                return "There was an error with the data."
            }
        }
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
    
    private func buildRequest(path: String) throws -> URLRequest {
        let requestUrl = try buildUrl(path)
        let request = URLRequest(url: requestUrl)
        
        return request
    }
    
    func fetch<T: Codable>(path: String) async throws -> T {
        let request = try buildRequest(path: path)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 300 else {
            throw NetworkError.apiError
        }
        
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }
    
    func getRecipes() async throws -> RecipeList {
        let recipeList: RecipeList = try await fetch(path: Self.basePath + APIPath.recipe.rawValue)
        
        return recipeList
    }
}
