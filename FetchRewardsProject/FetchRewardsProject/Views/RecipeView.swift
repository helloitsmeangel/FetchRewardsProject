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
                        VStack(alignment: .center) {
                            TabView {
                                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                                    RecipeItem(recipe: recipe)
                                }
                            }
                            .tint(.black)
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
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
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
            AsyncCachedImage(url: URL(string: recipe.photoUrlLarge ?? ""), id: recipe.uuid, content: { image in
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
            Text("Source: \(recipe?.sourceUrl ?? "N/A")")
            Text("YouTube: \(recipe?.youtubeUrl ?? "N/A")")
            Spacer()
        }
    }
}

@MainActor
struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    
    var url: URL?
    var id: String
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    @State var image: UIImage? = nil
    
    init(url: URL?, id: String, @ViewBuilder content: @escaping (Image) -> ImageView, @ViewBuilder placeholder: @escaping () -> PlaceholderView) {
        self.url = url
        self.id = id
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                    }
            }
        }
    }
    
    private func downloadPhoto() async -> UIImage? {
        do {
            guard let url else { return nil }
            // Check if the image is cached already
            if let cachedResponse = getSavedImage(named: "\(id).jpg") {
                return cachedResponse
            } else {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                let _ = saveImage(imagePath: "\(id).jpg", image: image)
                
                return image
            }
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
    
    private func saveImage(imagePath: String?, image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData(), let imagePath else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(imagePath)!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    private func getSavedImage(named: String?) -> UIImage? {
        if let named, let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
