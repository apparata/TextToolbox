//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - String Normalization

extension String {

    /// A normalized representation of the string.
    ///
    /// This computed property returns the string with diacritic marks removed and
    /// converted to a case-insensitive form, using the current locale.
    /// It is useful for comparisons and searches that should ignore accents and case differences.
    ///
    /// For example, `"Café".normalized` returns `"cafe"`.
    ///
    public var normalized: String {
        self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
    }
}
