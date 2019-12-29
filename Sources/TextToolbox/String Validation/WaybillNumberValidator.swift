//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public final class WaybillNumberValidator: StringValidatorGroup {

    public init() {
        super.init(validators: [SISWaybillNumberValidator(), GS1GSINWaybillNumberValidator()])
    }

}


/// Validates Swedish SIS waybill number.
public final class SISWaybillNumberValidator: StringValidator {

    public init() {}

    /// Validate Swedish SIS waybill number.
    ///
    /// Example: "6088391211"
    ///
    /// - returns: `true` if number is a valid waybill number, otherwise `false`.
    /// - parameter string: 10 digit waybill number.
    public func isValid(_ waybillNumber: String) -> Bool {
        guard waybillNumber.count == 10 else {
            return false
        }
        let digits = waybillNumber.compactMap { Int(String($0)) }
        guard digits.count == 10 else {
            return false
        }
        guard digits[0] != 0 else {
            return false
        }
        let checksumIsCorrect = digits.enumerated().reduce(0) {
            let value = $1.element + (1 - $1.offset % 2) * $1.element
            return $0 + value - (value > 9 ? 9 : 0)
            } % 10 == 0
        return checksumIsCorrect
    }
}

/// Validates GS1 GSIN waybill number.
public final class GS1GSINWaybillNumberValidator: StringValidator {

    public init() {}

    /// Validate GS1 GSIN waybill number.
    ///
    /// Example: "73655661561900123"
    ///
    /// - returns: `true` if number is a valid GS1 GSIN waybill number, otherwise `false`.
    /// - parameter string: 17 digit GS1 GSIN waybill number.
    public func isValid(_ waybillNumber: String) -> Bool {
        guard waybillNumber.count == 17 else {
            return false
        }
        let digits = waybillNumber.compactMap { Int(String($0)) }
        guard digits.count == 17 else {
            return false
        }
        let digitsWithoutCheckDigit = Array(digits[0...(digits.count - 2)])
        return checkdigit(digitsWithoutCheckDigit) == digits.last
    }

    /// Implemented according to algorithm from
    /// http://www.gs1.org/barcodes/support/check_digit_calculator
    private func checkdigit(_ digits: [Int]) -> Int {
        var sum: Int = 0
        var multiplier: Int = 3

        for i in (0...(digits.count - 1)).reversed() {
            sum += digits[i] * multiplier
            multiplier = multiplier ^ 2
        }

        let checksum = 10 - sum % 10
        return checksum == 10 ? 0 : checksum
    }
    
}

