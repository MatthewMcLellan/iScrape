import SwiftUI
import Photos

struct ImageDetailView: View {
    let image: ScrapedImage
    @State private var isSaving = false
    @State private var showSuccess = false
    
    var body: some View {
        VStack {
            Spacer()
            
            AsyncImage(url: image.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 20)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxHeight: 500)
            .padding()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(image.term)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Web Scraper Source")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                Divider()
                
                HStack {
                    Text("Dimensions")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(image.dimensions)
                        .font(.system(.body, design: .monospaced))
                }
                
                Spacer()
                
                Button(action: saveImage) {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .colorInvert()
                        } else if showSuccess {
                            Image(systemName: "checkmark")
                            Text("Saved to Photos")
                        } else {
                            Image(systemName: "square.and.arrow.down")
                            Text("Save to Photos")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(showSuccess ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .font(.headline)
                }
                .disabled(isSaving)
            }
            .padding(24)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(24)
            .padding()
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func saveImage() {
        isSaving = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: image.url),
               let uiImage = UIImage(data: data) {
                
                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                
                DispatchQueue.main.async {
                    isSaving = false
                    showSuccess = true
                    
                    // Reset success state after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSuccess = false
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    isSaving = false
                }
            }
        }
    }
}
#Preview("ImageDetailView") {
    let sample = ScrapedImage(
        id: UUID(),
        url: URL(string: "https://image.pollinations.ai/prompt/sample?width=800&height=600&nologo=true&seed=1")!,
        term: "Sample Term",
        dimensions: "800 x 600"
    )
    return NavigationStack { ImageDetailView(image: sample) }
}

