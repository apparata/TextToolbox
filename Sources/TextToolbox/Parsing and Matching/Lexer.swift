//
//  Copyright © 2015 Apparata AB. All rights reserved.
//

import Foundation

/// Error type for Lexer methods that throw.
public enum LexerError: Error {
    case tokenNotRecognized(range: CountableRange<Int>)
}

/// The Lexer object tokenizes a string based on a list of regular expressions.
/// Each regular expression corresponds to a token. The list is evaluated from
/// the beginning, which results in earlier regular expressions taking
/// precedence over later regular expressions.
///
/// Example:
/// ```
/// enum ExampleToken {
///     case symbol(String)
///     case number(Float)
/// }
///
/// let lexerRules: [Lexer<ExampleToken>.Rule] = [
///     ("^\\s+", { _ in nil }),
///     ("^\\d+", { .number(($0 as NSString).floatValue) }),
///     ("^\\w+", { .symbol($0) })
/// ]
/// let lexer = Lexer<ExampleToken>(rules: lexerRules)
/// let tokens = try? lexer.tokenize("this is the number 123")
///
/// let lexerRangedTokenRules: [Lexer<ExampleToken>.RangedTokenRule] = [
///     ("^\\s+", { (_, _) in nil }),
///     ("^\\d+", { (groups, _) in .number((groups[0] as NSString).floatValue) }),
///     ("^\\w+", { (groups, _) in .symbol(groups[0]) })
/// ]
/// let lexer2 = Lexer<ExampleToken>(rules: lexerRules)
/// let rangedTokens = try? lexer2.tokenize("this is the number 123")
/// ```
public final class Lexer<Token> {
    
    public typealias MatchGroups = [String]
    public typealias RangedTokenFactory = (MatchGroups, CountableRange<Int>) -> Token?
    public typealias RangedTokenRule = (Regex, RangedTokenFactory)
    public typealias TokenFactory = (String) -> Token?
    public typealias Rule = (Regex, TokenFactory)
    private typealias GenericRule = (Regex, TokenFactory?, RangedTokenFactory?)
    
    private let rules: [GenericRule]
    
    public init(rules: [Rule]) {
        self.rules = rules.map { ($0.0, $0.1, nil) }
    }
    
    public init(rules: [RangedTokenRule]) {
        self.rules = rules.map { ($0.0, nil, $0.1) }
    }
    
    
    /// Tokenizes a string based on a list of regular expression patterns.
    ///
    /// - parameter string: The string to tokenize.
    ///
    /// - throws: LexerError.tokenNotRecognized(range:) if no pattern matches.
    ///
    /// - returns: Array of tokens.
    public func tokenize(_ string: String) throws -> [Token] {
        var tokens = [Token]()
        let count = string.count

        var range: CountableRange<Int> = 0 ..< count
        while !range.isEmpty {
            var ruleMatched = false
            for (regex, tokenFactory, rangedTokenFactory) in rules {
                if let (groups, tokenRange) = regex.firstMatch(in: string, inRange: range) {
                    if let token = createTokenWithFactory(tokenFactory, rangedTokenFactory: rangedTokenFactory, groups: groups, tokenRange: tokenRange) {
                        tokens.append(token)
                    }
                    ruleMatched = true
                    range = tokenRange.upperBound ..< count
                    break
                }
            }
            
            if !ruleMatched {
                #if DEBUG
                print("[Lexer] Error: Token not recognized.")
                #endif
                throw LexerError.tokenNotRecognized(range: range)
            }
        }
        
        return tokens
    }
    
    private func createTokenWithFactory(_ tokenFactory: TokenFactory?, rangedTokenFactory: RangedTokenFactory?, groups: [String], tokenRange: CountableRange<Int>) -> Token? {
        if let tokenFactory = tokenFactory {
            return tokenFactory(groups[0])
        } else if let rangedTokenFactory = rangedTokenFactory {
            return rangedTokenFactory(groups, tokenRange)
        }
        return nil
    }
    
    private func createToken(_ tokenFactory: TokenFactory, groups: [String], tokenRange: Range<Int>) -> Token? {
        return tokenFactory(groups[0])
    }
    
}
