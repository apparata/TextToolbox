//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

extension String: @retroactive Identifiable {
    public var id: String { self }
}
