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
            TabView {
                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                    RecipeItem(recipe: recipe)
                }
            }
            .tabViewStyle(.page)
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct RecipeItem: View {
    var recipe: Recipe
    @State var show: Bool = false
    
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
                .font(.system(size: 20))
                .fontWeight(.black)
                .padding(10)
        }
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: 400)
        .padding(.horizontal, 30)
        .onTapGesture {
            show = true
        }
        .sheet(isPresented: $show, content: {
            VStack {
                Text("Source: \(recipe.sourceUrl ?? "N/A")")
                Text("YouTube: \(recipe.youtubeUrl ?? "N/A")")
            }
            .presentationDetents([.height(200)])
        })
    }
}
