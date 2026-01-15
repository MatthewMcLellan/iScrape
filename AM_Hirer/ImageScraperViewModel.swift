import SwiftUI
import Combine

class ImageScraperViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var results: [ScrapedImage] = []
    @Published var isSearching = false
    
    func performSearch(quantity: Int = 12, aspectRatio: String = "Portrait", format: String? = nil, quality: String? = nil) {
        guard !searchText.isEmpty else { return }
        
        isSearching = true
        results = []
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            var newImages: [ScrapedImage] = []
            for i in 0..<quantity {
                newImages.append(ScrapedImage(term: self.searchText, index: i, aspectRatio: aspectRatio, format: format, quality: quality))
            }
            
            withAnimation(.spring()) {
                self.results = newImages
                self.isSearching = false
            }
        }
    }
}

