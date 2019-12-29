//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public class UInt16Validator: IntValidator {
    
    override public init() {
        super.init(range: 0...65535)
    }
    
    override private init(range: CountableClosedRange<Int>) {
        super.init(range: range)
    }
    
}
