# Vapor Sitemap

A dynamic sitemap generator for Vapor.

## Setup

Add the package to your `Package.swift` file:

```swift
let package = Package(
    // ...
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/NathanFallet/vapor-sitemap.git", from: "1.0.0"), // Add this line
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "VaporSitemap", package: "vapor-sitemap"), // Add this line
            ]
        ),
    ],
    // ...
)
```

## Usage

First, we need to create some functions to tell to the middleware what to do:

### `isSitemap(_ path: String) -> Bool`

The goal of this function is to tell the middleware if it should handle a path or not.
A basic implementation is this one:

```swift
func isSitemap(_ path: String) -> Bool {
    return path == "/sitemap.xml"
}
```

With this implementation, you tell to the middleware to handle only `/sitemap.xml`.

In some cases, you may want to generate multiple sitemaps.
To do so, just handle all the path you want in this function.

### `generateURLs(_ path: String) -> [SitemapURL]`

The goal of this function is to give all the URLs to put in the specified sitemap.
An example implementation is this one:

```swift
func generateURLs(_ path: String) -> [SitemapURL] {
    let prefix = "https://www.example.com/"
    let paths = ["home", "page1", "folder/page2"]
        
    return paths.map { path in
        prefix + path
    }
    .map(SitemapURL.init)
}
```

### Final step

In your `configure.swift`, add the corresponding middleware:

```swift
app.middleware.use(SitemapMiddleware(
    isSitemap: isSitemap,
    generateURLs: generateURLs
))
```

And you're ready to go!

## About

This package is developed and maintained by [Nathan Fallet](https://www.nathanfallet.me/).
