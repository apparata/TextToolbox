//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
        
    /// Example:
    /// ```
    /// "abcdefghijkl".chomping(left: "abcd")
    /// result: "efghijkl"
    /// ```
    func chomping(left prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return String(self[startIndex..<prefixRange.lowerBound])
            } else {
                return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    /// Example:
    /// ```
    /// "abcdefghijkl".chomping(right: "ijkl")
    /// result: "abcdefgh"
    /// ```
    func chomping(right suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return String(self[startIndex..<suffixRange.lowerBound])
            } else {
                return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
}
