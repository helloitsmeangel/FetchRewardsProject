//
//  RecipeView.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/18/25.
//

import SwiftUI

struct RecipeView: View {
    @StateObject var viewModel: RecipeViewModel
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if !viewModel.recipes.isEmpty {
                        VStack(alignment: .center) {
                            TabView {
                                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                                    RecipeItem(recipe: recipe)
                                }
                            }
                            .tabViewStyle(.page)
                            .padding(.horizontal, 20)
                            .sheet(isPresented: $viewModel.showRecipeUrls, content: {
                                RecipeUrlsSheet(recipe: viewModel.tappedRecipe)
                                    .presentationDetents([.height(geometry.size.height * 0.3)])
                            })
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        EmptyRecipeView()
                    }
                }
                .background(Color(uiColor: UIColor.tertiarySystemFill))
                .refreshable {
                    viewModel.getRecipes()
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .environmentObject(viewModel)
            .onAppear {
                viewModel.getRecipes()
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil), actions: {
                Button {
                    viewModel.error = nil
                } label: {
                    Text("Ok")
                }
            }, message: {
                Text(viewModel.error?.localizedDescription ?? "")
            })
        }
    }
}

struct RecipeItem: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    var recipe: Recipe
    
    var body: some View {
        Group {
            AsyncCachedImageView(viewModel: AsyncCachedImageViewModel(url: URL(string: recipe.photoUrlLarge ?? ""), id: recipe.uuid), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                Image(systemName: "questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            })
        }
        .overlay(alignment: .topLeading) {
            Capsule()
                .frame(width: 100, height: 30)
                .foregroundStyle(Color(uiColor: UIColor.systemBackground))
                .padding(10)
                .overlay(
                    Text(recipe.cuisine)
                        .foregroundStyle(Color(uiColor: UIColor.label))
                )
        }
        .overlay(alignment: .bottom) {
            Text(recipe.name)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .black))
                .padding(10)
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 30)
        .padding(.vertical, 40)
        .onTapGesture {
            recipeViewModel.didTapOnRecipe(recipe)
        }
    }
}

struct RecipeUrlsSheet: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    var recipe: Recipe?
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.gray)
                .frame(width: 30, height: 6)
                .padding(5)
            HStack {
                Spacer()
                Text("Sources")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .overlay(alignment: .topTrailing) {
                Button {
                    recipeViewModel.showRecipeUrls = false
                } label: {
                    Image(systemName: "x.circle")
                        .tint(.black)
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 10)
            }
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            
            Spacer()
            if let sourceUrl = URL(string: recipe?.sourceUrl ?? "") {
                Link("View website", destination: sourceUrl)
                    .padding(.vertical, 10)
            }
            if let youtubeUrl = URL(string: recipe?.youtubeUrl ?? "") {
                Link("View YouTube video", destination: youtubeUrl)
                    .padding(.vertical, 10)
            }
            Spacer()
        }
    }
}
