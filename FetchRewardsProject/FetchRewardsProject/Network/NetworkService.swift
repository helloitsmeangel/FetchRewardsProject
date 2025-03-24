//
//  NetworkService.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/19/25.
//

import Foundation

protocol NetworkService {
    func fetch<T: Codable>(path: String) async throws -> T
}
