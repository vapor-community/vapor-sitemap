/*
*  Copyright (C) 2022 Nathan FALLET
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
*/

import Vapor

public class SitemapMiddleware: Middleware {
    
    private let isSitemap: (Request) -> Bool
    private let generateURLs: (Request) -> [SitemapURL]
    
    public init(
        isSitemap: @escaping (Request) -> Bool,
        generateURLs: @escaping (Request) -> [SitemapURL]
    ) {
        self.isSitemap = isSitemap
        self.generateURLs = generateURLs
    }
    
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        // Only handle if url corresponds to a sitemap
        guard isSitemap(request) else {
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
                \(generateURLs(request).map(\.xml).joined(separator: "\n"))
                </urlset>
                """
            )
        ))
    }
    
}

