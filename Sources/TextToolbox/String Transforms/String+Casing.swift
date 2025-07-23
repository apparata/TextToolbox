//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public extension String {

    /// Returns a copy of the string with the first character uppercased.
    ///
    /// This method capitalizes only the first character of the string and leaves the rest unchanged.
    /// It does not take locale into account for the casing operation.
    ///
    /// - Returns: A new string with the first letter capitalized.
    /// 
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    /// Capitalizes the first character of the string in-place.
    ///
    /// This mutating method replaces the original string with a version where only
    /// the first character is uppercased. It does not modify the casing of the rest of the string.
    ///
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
