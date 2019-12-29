//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public class StringValidatorGroup: StringValidator {

    private let validators: [StringValidator]

    public init(validators: [StringValidator]) {
        self.validators = validators
    }

    /// Returns true if at least one string validator returns true.
    public func isValid(_ string: String) -> Bool {
        for validator in validators {
            if validator.isValid(string) {
                return true
            }
        }
        return false
    }
    
}
