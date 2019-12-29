//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension DefaultStringInterpolation {
    
    /// Convenient extension for formatting numbers using string interpolation.
    ///
    /// Example:
    ///
    /// ```
    /// let numberFormatter = NumberFormatter()
    /// numberFormatter.numberStyle = .spellOut
    /// print("One plus one is \(2, numberFormatter)")
    /// ```
    mutating func appendInterpolation<T: Numeric>(_ value: T, _ formatter: NumberFormatter) {
        appendInterpolation(formatter.string(from: value as! NSNumber) ?? "\(value)")
    }
    
}
