//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    subscript(range: PartialRangeThrough<Int>) -> String {
        let rangeStartIndex = index(startIndex, offsetBy: 0)
        let rangeEndIndex = index(startIndex, offsetBy: range.upperBound)
        let substring = self[rangeStartIndex...rangeEndIndex]
        return String(substring)
    }
    
    subscript(range: PartialRangeUpTo<Int>) -> String {
        let rangeStartIndex = index(startIndex, offsetBy: 0)
        let rangeEndIndex = index(startIndex, offsetBy: range.upperBound)
        let substring = self[rangeStartIndex..<rangeEndIndex]
        return String(substring)
    }
    
    subscript(range: CountablePartialRangeFrom<Int>) -> String {
        let rangeStartIndex = index(startIndex, offsetBy: range.lowerBound)
        let rangeEndIndex = index(endIndex, offsetBy: -1)
        let substring = self[rangeStartIndex...rangeEndIndex]
        return String(substring)
    }
    
    subscript(range: CountableClosedRange<Int>) -> String {
        let rangeStartIndex = index(startIndex, offsetBy: range.lowerBound)
        let rangeEndIndex = index(startIndex, offsetBy: range.upperBound)
        let substring = self[rangeStartIndex...rangeEndIndex]
        return String(substring)
    }
    
    subscript(range: CountableRange<Int>) -> String {
        let rangeStartIndex = index(startIndex, offsetBy: range.lowerBound)
        let rangeEndIndex = index(startIndex, offsetBy: range.upperBound - 1)
        let substring = self[rangeStartIndex...rangeEndIndex]
        return String(substring)
    }
}
