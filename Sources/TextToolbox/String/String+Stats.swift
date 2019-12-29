//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    func wordCount() -> Int {
        let scheme = NSLinguisticTagScheme.tokenType
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: 0)
        tagger.string = self
        let range = NSMakeRange(0, self.count)
        var words = 0
        tagger.enumerateTags(in: range, scheme: scheme, options: []) { (tag, _, _, _) in
            if tag == NSLinguisticTag.word {
                words += 1
            }
        }
        return words
    }

}
