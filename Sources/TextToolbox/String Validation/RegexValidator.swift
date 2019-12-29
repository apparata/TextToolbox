//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public final class RegexValidator: StringValidator {
    
    fileprivate let regex: Regex
    
    public init(regex: Regex) {
        self.regex = regex
    }
    
    public init(pattern: String) {
        regex = Regex(pattern)
    }
    
    public func isValid(_ string: String) -> Bool {
        let regexMatches = regex.isMatch(string)
        return regexMatches
    }
}
