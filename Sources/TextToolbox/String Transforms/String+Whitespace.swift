//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    /// Example:
    /// ```
    /// "    How are you?   ".trimmed()
    /// result: "How are you?"
    /// ```
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Example:
    /// ```
    /// "This is a test.".removingWhitespace()
    /// result: "Thisisatest"
    /// ```
    func removingWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: "")
    }
    
    /// Example:
    /// ```
    /// "This    is    a    test.".collapsingWhitespace()
    /// result: "This is a test"
    /// ```
    func collapsingWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
}
