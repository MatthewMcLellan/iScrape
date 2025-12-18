import Foundation

extension ScrapedImage {
    /// Convenience initializer used to generate sample/scraped images
    /// based on a search term and index. Preserves existing dimensions logic.
    /// This mirrors the legacy behavior (fixed width 800 and height alternating 1000/600).
    public init(term: String, index: Int, format: String? = nil, quality: String? = nil) {
        let height = index % 2 == 0 ? 1000 : 600
        let width = 800
        var urlString = "https://image.pollinations.ai/prompt/\(term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")%20\(index)?width=\(width)&height=\(height)&nologo=true&seed=\(index)"
        if let format = format {
            urlString += "&format=\(format)"
        }
        if let quality = quality {
            urlString += "&quality=\(quality)"
        }
        let url = URL(string: urlString)!
        self.init(id: UUID(), url: url, term: term, dimensions: "\(width) x \(height)")
    }

    /// Convenience initializer supporting aspect ratio variants used by the grid.
    /// - Parameters:
    ///   - term: Search term used to build the image URL
    ///   - index: Index used for alternating sizes and seeding
    ///   - aspectRatio: "Portrait" (default), "Landscape", or "Square"
    public init(term: String, index: Int, aspectRatio: String, format: String? = nil, quality: String? = nil) {
        var width = 800
        var height = 1000

        if aspectRatio == "Landscape" {
            width = 1000
            height = 600
        } else if aspectRatio == "Square" {
            width = 1000
            height = 1000
        } else {
            // Portrait fallback/variation
            height = index % 2 == 0 ? 1000 : 800
        }

        var urlString = "https://image.pollinations.ai/prompt/\(term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")%20\(index)?width=\(width)&height=\(height)&nologo=true&seed=\(index)"
        if let format = format {
            urlString += "&format=\(format)"
        }
        if let quality = quality {
            urlString += "&quality=\(quality)"
        }
        let url = URL(string: urlString)!
        self.init(id: UUID(), url: url, term: term, dimensions: "\(width) x \(height)")
    }
}
