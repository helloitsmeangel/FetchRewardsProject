//
//  AsyncCachedImageView.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/25/25.
//

import SwiftUI

@MainActor
struct AsyncCachedImageView<ImageView: View, PlaceholderView: View>: View {
    @StateObject var viewModel: AsyncCachedImageViewModel
    
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    var body: some View {
        VStack {
            if let uiImage = viewModel.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            await viewModel.downloadImage()
                        }
                    }
            }
        }
    }
}
