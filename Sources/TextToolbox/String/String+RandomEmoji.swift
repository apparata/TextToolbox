//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

extension String{
    
    static var randomEmoji: String {
        
        let emojiRanges: [ClosedRange<Int>] = [
            0x1f600...0x1f64f,
            0x1f680...0x1f6c5,
            0x1f6cb...0x1f6d2,
            0x1f6e0...0x1f6e5,
            0x1f6f3...0x1f6fa,
            0x1f7e0...0x1f7eb,
            0x1f90d...0x1f93a,
            0x1f93c...0x1f945,
            0x1f947...0x1f971,
            0x1f973...0x1f976,
            0x1f97a...0x1f9a2,
            0x1f9a5...0x1f9aa,
            0x1f9ae...0x1f9ca,
            0x1f9cd...0x1f9ff,
            0x1fa70...0x1fa73,
            0x1fa78...0x1fa7a,
            0x1fa80...0x1fa82,
            0x1fa90...0x1fa95
        ]
        
        return emojiRanges
            .randomElement()?
            .randomElement()
            .flatMap(UnicodeScalar.init)?
            .description ?? "🙂"
    }
}
