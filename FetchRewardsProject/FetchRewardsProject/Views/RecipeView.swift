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
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if !viewModel.recipes.isEmpty {
                        Group {
                            TabView {
                                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                                    RecipeItem(recipe: recipe)
                                }
                            }
                            .tint(.black)
                            .tabViewStyle(.page)
                            .padding(.horizontal, 20)
                            .sheet(isPresented: $viewModel.showRecipeUrls, content: {
                                RecipeUrlsSheet(sourceInfo: viewModel.recipeSourceInfo)
                                    .presentationDetents([.height(geometry.size.height * 0.3)])
                            })
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.8)
                    } else {
                        EmptyRecipeView()
                    }
                }
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                .refreshable {
                    viewModel.getRecipes()
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
            .environmentObject(viewModel)
        }
    }
}

struct RecipeItem: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    var recipe: Recipe
    
    var body: some View {
        VStack {
            if let photoPath = recipe.photoUrlLarge, let url = URL(string: photoPath) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "questionmark")
                        .resizable()
                        .scaledToFit()
                }
            } else {
                Image(systemName: "questionmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .overlay(alignment: .topLeading) {
            Capsule()
                .frame(width: 100, height: 30)
                .foregroundStyle(.white)
                .padding(10)
                .overlay(
                    Text(recipe.cuisine)
                )
        }
        .overlay(alignment: .topTrailing) {
            Button {
                print("Bookmarked")
            } label: {
                Image(systemName: "bookmark.circle")
            }
            .font(.system(size: 35))
            .foregroundStyle(.white)
            .padding(10)
        }
        .overlay(alignment: .bottom) {
            Text(recipe.name)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .black))
                .padding(10)
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 30)
        .padding(.vertical, 40)
        .onTapGesture {
            recipeViewModel.showRecipeSheet(recipe)
        }
    }
}

struct RecipeUrlsSheet: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    var sourceInfo: SourceInfo?
    
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
            Text("Source: \(sourceInfo?.sourceUrl ?? "N/A")")
            Text("YouTube: \(sourceInfo?.youtubeUrl ?? "N/A")")
            Spacer()
        }
    }
}
