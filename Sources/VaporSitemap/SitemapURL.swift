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
        
        return "<url>\n\(elements.joined(separator: "\n"))\n</url>"
    }
    
}
