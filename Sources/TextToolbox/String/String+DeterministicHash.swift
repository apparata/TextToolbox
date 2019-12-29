//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    var deterministicHash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}
