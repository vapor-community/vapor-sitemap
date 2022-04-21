import Foundation

public struct SitemapURL: ExpressibleByStringLiteral {
    
    public let location: String
    public let lastModification: Date?
    public let changeFrequency: SitemapChangeFrequency?
    public let priority: Float?
    
    public init(
        location: String,
        lastModification: Date?,
        changeFrequency: SitemapChangeFrequency?,
        priority: Float?
    ) {
        self.location = location
        self.lastModification = lastModification
        self.changeFrequency = changeFrequency
        self.priority = priority
    }
    
    public init(stringLiteral value: String) {
        self.init(
            location: value,
            lastModification: nil,
            changeFrequency: nil,
            priority: nil
        )
    }
    
    public var xml: String {
        var elements = [
            "<loc>\(location)</loc>"
        ]
        
        if let lastModification = lastModification {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            elements.append("<lastmod>\(formatter.string(from: lastModification))</lastmod>")
        }
        if let changeFrequency = changeFrequency {
            elements.append("<changefreq>\(changeFrequency.rawValue)</changefreq>")
        }
        if let priority = priority {
            elements.append("<priority>\(priority)</priority>")
        }
        
        return "<url>\n\(elements.joined(separator: "\n"))\n<url>"
    }
    
}
