//
//  AsyncCachedImageViewModel.swift
//  FetchRewardsProject
//
//  Created by Angel Castaneda on 3/25/25.
//

import UIKit
import Combine

class AsyncCachedImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    var url: URL?
    var id: String
    
    init(url: URL? = nil, id: String) {
        self.url = url
        self.id = id
    }
    
    func downloadImage() async {
        do {
            guard let url else { return }
            
            // check if image is cached before starting download
            if let cachedResponse = getSavedImage(name: "\(id).jpg") {
                await setImageToRetrievedImage(uiImage: cachedResponse)
            } else {
                // image is not cached, start download here
                let (data, _) = try await URLSession.shared.data(from: url)
                
                guard let image = UIImage(data: data) else { return }
                
                // once successfully downloaded, save image to disk
                let _ = saveImage(imageFileName: "\(id).jpg", image: image)
                
                await setImageToRetrievedImage(uiImage: image)
            }
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    private func saveImage(imageFileName: String?, image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData(), let imageFileName else { return }
        guard let directory = getDocumentsDirectory() else { return }
        
        do {
            // write to documents directory
            let path = directory.appendingPathComponent(imageFileName)
            try data.write(to: path)
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    // returns UIImage from saved file in documents directory, nil if it doesn't exist.
    private func getSavedImage(name: String?) -> UIImage? {
        if let name, let directory = getDocumentsDirectory() {
            return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
    
    // finds documents directory, nil if can't find.
    private func getDocumentsDirectory() -> URL? {
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    @MainActor
    private func setImageToRetrievedImage(uiImage: UIImage) {
        image = uiImage
    }
}
