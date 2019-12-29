//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    /// Replacing last space with non-breaking space to avoid orphans.
    ///
    /// - returns: New string with last space replaced with non-breaking space.
    var removingOrphan: String {
        get {
            let set = CharacterSet(charactersIn: " ")
            if let range = rangeOfCharacter(from: set, options: .backwards, range: nil) {
                return replacingCharacters(in: range, with: "\u{00a0}")
            }
            return self
        }
    }
}
