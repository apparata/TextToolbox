//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Validates UUID string.
public final class UUIDValidator: StringValidator {
    
    // 8-4-4-4-12
    private static let pattern = "^[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}$"
    
    private static let regex = Regex(pattern)
    
    public init() {}
    
    public func isValid(_ uuid: String) -> Bool {
        return UUIDValidator.regex.isMatch(uuid)
    }
}

