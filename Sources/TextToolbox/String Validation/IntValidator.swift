//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Validates Int string.
public class IntValidator: StringValidator {
    
    private static let pattern = "^\\d+$"
    
    private static let regex = Regex(pattern)
    
    private let range: CountableClosedRange<Int>?
    
    public init() {
        range = nil
    }
    
    public init(range: CountableClosedRange<Int>) {
        self.range = range
    }
    
    public func isValid(_ intString: String) -> Bool {
        if IntValidator.regex.isMatch(intString) {
            if let value = Int(intString) {
                if let range = range {
                    if case range = value {
                        return true
                    }
                } else {
                    return true
                }
            }
        }
        return false
    }
}

