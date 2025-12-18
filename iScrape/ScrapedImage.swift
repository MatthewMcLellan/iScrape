import Foundation

public struct ScrapedImage: Identifiable, Hashable, Codable {
    public let id: UUID
    public let url: URL
    // Core metadata used across the app
    public var term: String
    public var dimensions: String
    // Optional metadata
    public var title: String?
    public var source: String?

    public init(id: UUID = UUID(), url: URL, term: String, dimensions: String, title: String? = nil, source: String? = nil) {
        self.id = id
        self.url = url
        self.term = term
        self.dimensions = dimensions
        self.title = title
        self.source = source
    }
}
