//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

/// Convenience wrapper around `Foundation.Scanner`
public final class TextScanner {

    /// The string the scanner is scanning.
    public var string: String {
        return scanner.string
    }
    
    /// The rest of the string from the current index.
    public var stringRemainder: String {
        return String(string[scanner.currentIndex...])
    }
    
    /// Number of remaining characters to scan.
    public var remainderCount: Int {
        guard currentIndex <= endIndex else {
            return 0
        }
        return string.distance(from: currentIndex, to: endIndex)
    }

    /// Index into the string where the scanner is currently located.
    public var currentIndex: String.Index {
        get {
            scanner.currentIndex
        }
        set {
            scanner.currentIndex = newValue
        }
    }
    
    /// Start index of the string.
    public var startIndex: String.Index {
        scanner.string.startIndex
    }
    
    /// End index of the string.
    public var endIndex: String.Index {
        scanner.string.endIndex
    }
    
    /// Indicates whether the receiver has exhausted all characters.
    ///
    /// `true` if the receiver has exhausted all characters in its string, otherwise `false`.
    public var isAtEnd: Bool {
        return scanner.isAtEnd
    }

    /// Indicates whether the receiver has any characters left to scan.
    ///
    /// `true` if the receiver has any characters left to scan, otherwise `false`.
    public var hasMore: Bool {
        return !scanner.isAtEnd
    }
    
    /// Indicates whether the scanner is case sensitive.
    public var caseSensitive: Bool {
        return scanner.caseSensitive
    }
    
    /// Indicates the locale of the scanner for e.g. parsing floating point numbers.
    ///
    /// A value of `nil` means that the current locale is used.
    public var locale: Locale? {
        return scanner.locale as? Locale
    }
    
    private let scanner: Scanner
    
    /// Initialize scanner.
    ///
    /// - parameter string: The string to scan.
    /// - parameter caseSensitive: Determines if scanner is case sensitive. Defaults to false.
    /// - parameter locale:
    ///     The locale of the scanner for e.g. parsing floating point numbers.
    ///     Defaults to the current locale.
    public init(string: String,
                caseSensitive: Bool = true,
                locale: Locale? = nil) {
        scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = .none
        scanner.caseSensitive = caseSensitive
        scanner.locale = locale
    }
    
    private func makeInternalScanner(string: String) -> Scanner {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = .none
        scanner.caseSensitive = caseSensitive
        scanner.locale = locale
        return scanner
    }
        
    // MARK: - Index
    
    public func currentIndex(offsetBy offset: Int) -> String.Index? {
        guard currentIndex <= endIndex else {
            return nil
        }
        return string.index(currentIndex, offsetBy: offset, limitedBy: endIndex)
    }

    public func clampedCurrentIndex(offsetBy offset: Int) -> String.Index {
        guard currentIndex <= endIndex else {
            return endIndex
        }
        return string.index(currentIndex,
                            offsetBy: offset,
                            limitedBy: endIndex) ?? endIndex
    }

    func reset() {
        currentIndex = startIndex
    }
    
    // MARK: - Scanning
    
    /// Scan one character, if any remain.
    ///
    /// - returns: The scanned character string, or nil, if scanner has reached the end.
    public func scan() -> String? {
        guard hasMore else {
            return nil
        }
        return scanner.scanCharacter().flatMap(String.init)
    }
    
    /// Scan an exact number of characters, if available.
    ///
    /// - parameter count: The number of characters to scan.
    /// - returns:
    ///     The scanned characters string, or `nil` if the scanned reached the end before scanning
    ///     the specified number of characters.
    public func scan(count: Int) -> String? {
        guard let toIndex = currentIndex(offsetBy: count) else {
            return nil
        }
        let substring = String(string[currentIndex..<toIndex])
        currentIndex = toIndex
        return substring
    }
    
    /// Scan the specified string.
    ///
    /// - parameter string: The string to scan at the current scanner location.
    /// - returns: The scanned string, or `nil` if the string could not be scanned.
    public func scan(_ string: String) -> String? {
        return scanner.scanString(string)
    }

    /// Scan the specified string, repeated a specified number of times.
    ///
    /// - parameter string: The string to scan repeatedly at the current scanner location.
    /// - returns:
    ///     The total scanned repeated string, or `nil` if the string could not be scanned
    ///     the specified number of times.
    public func scan(_ string: String, repeatCount: Int) -> String? {
        let indexBefore = currentIndex
        var strings: [String] = []
        for _ in 1...repeatCount {
            if let substring = scan(string) {
                strings.append(substring)
            } else {
                currentIndex = indexBefore
                return nil
            }
            guard !isAtEnd else {
                break
            }
        }
        return strings.joined()
    }

    /// Scan the specified string and any subsequent repeats of the same string.
    ///
    /// - parameter string: The string to scan repeatedly at the current scanner location.
    /// - returns:
    ///     The total scanned repeated string, or `nil` if the string could not be scanned
    ///     at least once.
    public func scanSome(_ string: String) -> String? {
        var strings: [String] = []
        while !isAtEnd {
            guard let substring = scan(string) else {
                break
            }
            strings.append(substring)
        }
        if strings.isEmpty {
            return nil
        }
        return strings.joined()
    }
    
    /// Scan up to the start index of the specified string.
    ///
    /// - parameter string: The string to scan up to.
    /// - returns: The scanned string up to the specified string, or `nil` if no occurrence.
    public func scanUpTo(_ string: String) -> String? {
        let indexBefore = currentIndex
        guard let scannedString = scanner.scanUpToString(string) else {
            return nil
        }
        guard peekMatch(string) else {
            currentIndex = indexBefore
            return nil
        }
        return scannedString
    }
    
    /// Scan all characters leading up to, and also through, the next occurrence of the specified string.
    ///
    /// - parameter string: The string to scan through.
    /// - returns: The scanned string through the specified string, or `nil` if no occurrence.
    public func scanThrough(_ string: String) -> String? {
        let indexBefore = currentIndex
        let scannedString = scanUpTo(string) ?? ""
        if skip(string) {
            return scannedString + string
        } else {
            currentIndex = indexBefore
            return nil
        }
    }
            
    /// Scan all characters leading up to the next occurrence of the specified string, and then skip
    /// skip through the specified string.
    ///
    /// - parameter string: The string to scan up to, and skip.
    /// - returns: The scanned string up to the specified string, or `nil` if no occurrence.
    public func scanUpToAndSkip(_ string: String) -> String? {
        let indexBefore = currentIndex
        guard let text = scanner.scanUpToString(string), skip(string) else {
            currentIndex = indexBefore
            return nil
        }
        return text
    }
            
    /// Scan at most `count` characters.
    ///
    /// - parameter count: The upper limit of characters to scan.
    /// - returns: The scanned string or `nil` if no characters could be scanned.
    public func scanAtMost(_ count: Int) -> String? {
        let toIndex = clampedCurrentIndex(offsetBy: count)
        let substring = String(string[currentIndex..<toIndex])
        currentIndex = endIndex
        guard substring.count > 0 else {
            return nil
        }
        return substring
    }
        
    /// Scan exactly one character, if the next character belongs to a specified set of characters.
    ///
    /// - parameter characters: A set of characters to scan one of.
    /// - returns: The scanned character string or nil if no characters from the set could be scanned.
    public func scanOne(of characters: String) -> String? {
        guard let character = scanner.scanCharacter(),
           characters.contains(character) else {
            return nil
        }
        return String(character)
    }

    /// Scan exactly one character, if the next character belongs to a specified set of characters.
    ///
    /// - parameter characters: A set of characters to scan one of.
    /// - returns: The scanned character string or nil if no characters from the set could be scanned.
    public func scanOne(of characters: CharacterSet) -> String? {
        guard let character = scan() else {
            return nil
        }
        let internalScanner = makeInternalScanner(string: character)
        return internalScanner.scanCharacters(from: characters)
    }
    
    /// Scan any number of characters, as long as they belong to the specified set of characters.
    ///
    /// - parameter characters: A set of characters to scan any of.
    /// - returns: The scanned character string or nil if no characters from the set could be scanned.
    public func scanAny(of characters: String) -> String? {
        let characterSet = CharacterSet(charactersIn: characters)
        guard let output = scanner.scanCharacters(from: characterSet) else {
            return nil
        }
        return output
    }

    /// Scan any number of characters, as long as they belong to the specified set of characters.
    ///
    /// - parameter characters: A set of characters to scan any of.
    /// - returns: The scanned character string or nil if no characters from the set could be scanned.
    public func scanAny(of characters: CharacterSet) -> String? {
        guard let output = scanner.scanCharacters(from: characters) else {
            return nil
        }
        return output
    }
    
    /// Scan up to the index of the next occurrence of a character from the specified set.
    ///
    /// - parameter string: The character to scan up to.
    /// - returns: The scanned string up to the specified character.
    public func scanUpTo(oneOf characters: String) -> String? {
        let indexBefore = currentIndex
        let characterSet = CharacterSet(charactersIn: characters)
        guard let result = scanner.scanUpToCharacters(from: characterSet) else {
            return nil
        }
        guard peekMatch(oneOf: characters) else {
            currentIndex = indexBefore
            return nil
        }
        return result
    }

    /// Scan up to the index of the next occurrence of a character from the specified set.
    ///
    /// - parameter string: The character to scan up to.
    /// - returns: The scanned string up to the specified character.
    public func scanUpTo(oneOf characters: CharacterSet) -> String? {
        let indexBefore = currentIndex
        guard let result = scanner.scanUpToCharacters(from: characters) else {
            return nil
        }
        guard peekMatch(oneOf: characters) else {
            currentIndex = indexBefore
            return nil
        }
        return result
    }
    
    /// Scan any white space.
    ///
    /// - parameter excludingNewlines:
    ///     Exclude new line characters when scanning white space. Defaults to `true`.
    /// - returns: The scanned white space characters or `nil` if no white space was found.
    public func scanWhiteSpace(excludingNewlines: Bool = false) -> String? {
        return scanner.scanCharacters(from: excludingNewlines
                                        ? .whitespaces
                                        : .whitespacesAndNewlines)
    }
    
    /// Scans one new line character at the current position.
    public func scanNewLine() -> String? {
        return scanner.scanString("\n")
    }
    
    /// Scans up to the next new line character.
    public func scanUpToNewLine() -> String? {
        return scanUpTo("\n")
    }
    
    /// Scan up to, and then through, the next new line character.
    public func scanThroughNewLine() -> String? {
        let indexBefore = currentIndex
        guard let string = scanUpToNewLine() else {
            return nil
        }
        guard let newLine = scanNewLine() else {
            currentIndex = indexBefore
            return nil
        }
        return string + newLine
    }
        
    // MARK: - Skipping
    
    /// Skip the string, starting at the current position.
    @discardableResult
    public func skip(_ string: String) -> Bool {
        return scanner.scanString(string) != nil
    }
    
    /// Skip up to the next occurrence of the string.
    @discardableResult
    public func skipUpTo(_ string: String) -> Bool {
        let indexBefore = currentIndex
        guard scanUpTo(string) != nil else {
            return false
        }
        guard peekMatch(string) else {
            currentIndex = indexBefore
            return false
        }
        return true
    }

    /// Skip up to and then through the next occurrence of the string.
    @discardableResult
    public func skipThrough(_ string: String) -> Bool {
        let scannedString = scanThrough(string)
        return scannedString != nil
    }

    /// Skip the next character.
    @discardableResult
    public func skip() -> Bool {
        return scan() != nil
    }

    
    /// Skip exactly one of the characters from the set.
    @discardableResult
    public func skipOne(of characters: String) -> Bool {
        return scanOne(of: characters) != nil
    }

    /// Skip exactly one of the characters from the set.
    @discardableResult
    public func skipOne(of characters: CharacterSet) -> Bool {
        return scanOne(of: characters) != nil
    }

    /// Skips any of the characters in the set.
    @discardableResult
    public func skipAny(of characters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: characters)
        return scanner.scanCharacters(from: characterSet) != nil
    }

    /// Skips any of the characters in the set.
    @discardableResult
    public func skipAny(of characters: CharacterSet) -> Bool {
        return scanner.scanCharacters(from: characters) != nil
    }
    
    /// Skips up to any character in the specified set.
    @discardableResult
    public func skipUpTo(oneOf characters: String) -> Bool {
        return scanUpTo(oneOf: characters) != nil
    }

    /// Skips up to any character in the specified set.
    @discardableResult
    public func skipUpTo(oneOf characters: CharacterSet) -> Bool {
        return scanUpTo(oneOf: characters) != nil
    }
    
    /// Skips new line character at the current position.
    @discardableResult
    public func skipNewLine() -> Bool {
        return scanNewLine() != nil
    }

    /// Skips through the next new line character.
    @discardableResult
    public func skipThroughNewLine() -> Bool {
        let indexBefore = currentIndex
        _ = scanUpToNewLine()
        guard scanNewLine() != nil else {
            currentIndex = indexBefore
            return false
        }
        return true
    }
    
    /// Skips past white space through the new line character, if the line is empty.
    @discardableResult
    public func skipWhiteSpaceAndThenNewLine() -> Bool {
        let indexBefore = currentIndex
        _ = scanWhiteSpace(excludingNewlines: true)
        guard scanNewLine() != nil else {
            currentIndex = indexBefore
            return false
        }
        return true
    }

    // MARK: - Peeking
    
    /// Look ahead at the next character.
    public func peek() -> String? {
        let indexBefore = currentIndex
        defer { currentIndex = indexBefore }
        return scan()
    }
    
    /// Look ahead at the next `count` characters, or `nil` if less than `count` characters remain.
    public func peekAtNext(_ count: Int) -> String? {
        guard let end = currentIndex(offsetBy: count) else {
            return nil
        }
        return String(string[currentIndex..<end])
    }

    /// Look ahead at the next at most `count` characters.
    public func peekAtMostNext(_ count: Int) -> String {
        let end = clampedCurrentIndex(offsetBy: count)
        return String(string[currentIndex..<end])
    }
    
    /// Look ahead to check if string matches the coming characters.
    public func peekMatch(_ string: String) -> Bool {
        let indexBefore = currentIndex
        defer { currentIndex = indexBefore }
        if scanner.scanString(string) != nil {
            return true
        }
        return false
    }

    /// Look ahead to check if string matches the coming characters.
    public func peekMatch(oneOf characters: String) -> Bool {
        let indexBefore = currentIndex
        defer { currentIndex = indexBefore }
        if scanOne(of: characters) != nil {
            return true
        }
        return false
    }

    /// Look ahead to check if the next character is in the match set.
    public func peekMatch(oneOf characters: CharacterSet) -> Bool {
        let indexBefore = currentIndex
        defer { currentIndex = indexBefore }
        if scanOne(of: characters) != nil {
            return true
        }
        return false
    }
    
    /// Look ahead to check if this is an empty line.
    public func isEmptyLine() -> Bool {
        let indexBefore = currentIndex
        defer { currentIndex = indexBefore }
        _ = scanWhiteSpace(excludingNewlines: true)
        return scanNewLine() != nil
    }
}
