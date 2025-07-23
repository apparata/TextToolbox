//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - Fuzzy Searcher

/// A generic fuzzy searcher that matches elements in a collection based on the
/// Levenshtein distance of a string key path.
///
/// This struct preprocesses a list of items and allows efficient fuzzy search
/// by comparing a search term against normalized string keys extracted using a key path.
///
/// **Example:**
///
/// ```swift
/// struct Country {
///     let name: String
///     let code: String
/// }
///
/// let countries = [
///     Country(name: "Germany", code: "DE"),
///     Country(name: "France", code: "FR"),
///     Country(name: "España", code: "ES"),
///     Country(name: "Italy", code: "IT")
/// ]
///
/// let searcher = FuzzySearcher(items: countries, keyPath: \.name, maxDistance: 2)
///
/// let matches = searcher.search("Espana")
///
/// for country in matches {
///     print("Matched: \(country.name) (\(country.code))")
/// }
/// ```
///
/// - Note: The strings are normalized (case- and diacritic-insensitive) before comparison.
///
public struct FuzzySearcher<T> {
    private let items: [T]
    private let candidates: [(index: Int, normalizedKey: String)]
    private let maxDistance: Int
    
    /// Creates a new fuzzy searcher for a collection of items.
    ///
    /// - Parameters:
    ///   - items: The array of items to search.
    ///   - keyPath: A key path to the string property to compare.
    ///   - maxDistance: The maximum allowed Levenshtein distance to consider a match. Default 2
    ///
    public init(items: [T], keyPath: KeyPath<T, String>, maxDistance: Int = 2) {
        self.items = items
        self.maxDistance = maxDistance
        self.candidates = items.enumerated().map { (index, item) in
            (index, item[keyPath: keyPath].normalized)
        }
    }
    
    /// Searches for items whose normalized key is within
    /// the allowed Levenshtein distancefrom the search term.
    ///
    /// - Parameter term: The string to search for.
    /// - Returns: An array of matched items, sorted by ascending distance.
    ///
    public func search(_ term: String) -> [T] {
        let normalizedTerm = term.normalized
        
        return candidates
            .compactMap { (index, normalizedKey) in
                let distance = levenshteinAssumingNormalized(normalizedKey, normalizedTerm)
                return distance <= maxDistance ? (index, distance) : nil
            }
            .sorted { $0.1 < $1.1 }
            .map { items[$0.0] }
    }
}

// MARK: - Levenshtein Distance

/// Levenshtein Distance (assumes normalized strings)
private func levenshteinAssumingNormalized(_ a: String, _ b: String) -> Int {
    let aArray = Array(a)
    let bArray = Array(b)
    var last = [Int](0...bArray.count)
    
    for (i, aChar) in aArray.enumerated() {
        var cur = [i + 1] + [Int](repeating: 0, count: bArray.count)
        for (j, bChar) in bArray.enumerated() {
            cur[j + 1] = aChar == bChar
                ? last[j]
                : min(last[j], last[j + 1], cur[j]) + 1
        }
        last = cur
    }
    return last.last!
}
