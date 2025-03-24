//
//  RecipeViewModelTests.swift
//  FetchRewardsProjectTests
//
//  Created by Angel Castaneda on 3/23/25.
//

import Combine
import XCTest
@testable import FetchRewardsProject

final class RecipeViewModelTests: XCTestCase {
    
    var recipeViewModel: RecipeViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        recipeViewModel = RecipeViewModel(recipeNetworkService: NetworkClientMock())
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        
        recipeViewModel = nil
        cancellables = []
    }
    
    func testFetchRecipesSuccessfully() async throws {
        let expectation = XCTestExpectation(description: "Recipes")
        
        recipeViewModel.getRecipes()
        
        recipeViewModel
            .$recipes
            .dropFirst()
            .sink { recipes in
                XCTAssertEqual(recipes.count, 6)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1)
    }
    
    func testSetInfoOnTapSuccessfully() async throws {
        let testRecipe = Recipe(cuisine: "Test Cuisine", name: "Test Name", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "00000000-0000-0000-0000-000000000000", sourceUrl: nil, youtubeUrl: nil)
        
        recipeViewModel.didTapOnRecipe(testRecipe)
        
        XCTAssert(recipeViewModel.tappedRecipe != nil && recipeViewModel.tappedRecipe?.uuid == "00000000-0000-0000-0000-000000000000")
    }
}
