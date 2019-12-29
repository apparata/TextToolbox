//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public class ForgivingSearchFilter<T> {
    
    public var searchString: String? {
        didSet {
            guard let normalizedSearchString = normalizeSearchString(searchString) else {
                searchPattern = nil
                return
            }
            
            searchPattern = makeSearchPattern(from: normalizedSearchString)
        }
    }
    
    private var searchPattern: Regex?
    
    private var property: KeyPath<T, String>
    
    public init(by property: KeyPath<T, String>) {
        self.property = property
    }
    
    public func filterItems(_ items: [T]) -> [T] {
        guard let searchPattern = searchPattern else {
            return items
        }
        return items.filter(by: property, matching: searchPattern)
    }
    
    private func makeSearchPattern(from searchString: String) -> Regex? {
        let forgivingSearchPattern = searchString.reduce(".*") {
            return "\($0)\(String($1)).*"
        }
        return Regex(forgivingSearchPattern, options: [.caseInsensitive])
    }
    
    private func normalizeSearchString(_ rawSearchString: String?) -> String? {
        guard let rawSearchString = rawSearchString else {
            return nil
        }
        
        let trimmedString = rawSearchString.trimmingCharacters(in: CharacterSet.whitespaces)
        
        guard !trimmedString.isEmpty else {
            return nil
        }
        
        let searchString = trimmedString.lowercased()
        
        return searchString
    }
}

private extension Sequence {

    func filter<T>(by keyPath: KeyPath<Element, T>, where condition: (T) -> Bool) -> [Element] {
        filter { element in
            let value = element[keyPath: keyPath]
            return condition(value)
        }
    }

    func filter(by keyPath: KeyPath<Element, String>, matching regex: Regex) -> [Element] {
        filter(by: keyPath, where: { regex.isMatch($0) })
    }
}
