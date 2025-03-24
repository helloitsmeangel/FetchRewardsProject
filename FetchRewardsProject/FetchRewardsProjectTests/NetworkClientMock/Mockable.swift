//
//  Mockable.swift
//  FetchRewardsProjectTests
//
//  Created by Angel Castaneda on 3/23/25.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Codable>(filename: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Codable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let object = try JSONDecoder().decode(T.self, from: data)
            
            return object
        } catch {
            print("\(error)")
            fatalError("Failed to decode JSON")
        }
    }
}
