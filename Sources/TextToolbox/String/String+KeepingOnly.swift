//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
        
    /// Example:
    /// ```
    /// "This is a test (1 2 3)+.".keepingOnly(.alphanumerics)
    /// result: "Thisisatest123"
    /// ```
    func keepingOnly(_ characterSet: CharacterSet) -> String {
        let components = self.components(separatedBy: characterSet.inverted).filter { !$0.isEmpty }
        return components.joined(separator: "")
    }
}
