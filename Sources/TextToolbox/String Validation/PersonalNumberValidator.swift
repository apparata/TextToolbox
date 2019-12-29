//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

/// Validates Swedish personal numbers.
public final class PersonalNumberValidator: StringValidator {
    
    private static let format = "^(?:19|20)?\\d{6}-?\\d{4}$"
    
    private static let regex = Regex(format, options: [.caseInsensitive])
    
    public init() {}
    
    /// Validate Swedish personal number.
    ///
    /// - returns: `true` if number is a valid personal number, otherwise `false`.
    /// - parameter string: 12 or 10 digit personal number, with optional "-"
    public func isValid(_ personalNumber: String) -> Bool {
        let regexMatches = PersonalNumberValidator.regex.isMatch(personalNumber)
        var digits = personalNumber.compactMap { Int(String($0)) }
        if digits.count == 12 {
            digits.removeSubrange(0...1)
        }
        let checksumIsCorrect = digits.enumerated().reduce(0) {
            let value = $1.element + (1 - $1.offset % 2) * $1.element
            return $0 + value - (value > 9 ? 9 : 0)
            } % 10 == 0
        return regexMatches && checksumIsCorrect
    }
}

