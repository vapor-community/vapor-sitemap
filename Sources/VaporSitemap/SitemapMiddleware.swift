import Vapor

public class SitemapMiddleware: Middleware {
    
    private let isSitemap: (String) -> Bool
    private let generateURLs: (String) -> [SitemapURL]
    
    public init(
        isSitemap: @escaping (String) -> Bool,
        generateURLs: @escaping (String) -> [SitemapURL]
    ) {
        self.isSitemap = isSitemap
        self.generateURLs = generateURLs
    }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Only handle if url corresponds to a sitemap
        guard isSitemap(request.url.path) else {
            return next.respond(to: request)
        }
        
        // Return the response
        return request.eventLoop.makeSucceededFuture(Response(
            status: .ok,
            version: request.version,
            headers: [
                "content-type": "text/xml; charset=utf-8"
            ],
            body: Response.Body(
                stringLiteral: """
                <?xml version="1.0" encoding="UTF-8"?>
                <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
                \(generateURLs(request.url.path).map(\.xml).joined(separator: "\n"))
                </urlset>
                """
            )
        ))
    }
    
}

