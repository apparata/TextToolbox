//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

public extension String {
    
    func taggedTokens(omitPunctuation: Bool = false, omitWhitespace: Bool = true) -> [(token: String, tag: TokenTag, lemma: String)] {
        return TokenTagger.taggedTokens(in: self, omitPunctuation: omitPunctuation, omitWhitespace: omitWhitespace)
    }
}

public enum TokenTag {
    
    // New tag that has is not recognized yet.
    case unknown
    
    // Word
    case noun
    case verb
    case adjective
    case adverb
    case pronoun
    case determiner
    case particle
    case preposition
    case number
    case conjunction
    case interjection
    case classifier
    case idiom
    case otherWord
    
    // Punctuation
    case sentenceTerminator
    case openQuote
    case closeQuote
    case openParenthesis
    case closeParenthesis
    case wordJoiner
    case dash
    case otherPunctuation
    
    // Whitespace
    case paragraphBreak
    case otherWhitespace
    
    // Name
    case personalName
    case placeName
    case organizationName
}

public class TokenTagger {
    
    public static func taggedTokens(in string: String, omitPunctuation: Bool = false, omitWhitespace: Bool = true) -> [(token: String, tag: TokenTag, lemma: String)] {
        
        var options: NSLinguisticTagger.Options = []
        if omitWhitespace {
            options.insert(.omitWhitespace)
        }
        
        var taggedTokenRanges: [Range<String.Index>] = []
        let tags = string.linguisticTags(in: string.startIndex..<string.endIndex, scheme: NSLinguisticTagScheme.nameTypeOrLexicalClass.rawValue, options: options, tokenRanges: &taggedTokenRanges)
        
        let lemmas = string.linguisticTags(in: string.startIndex..<string.endIndex, scheme: NSLinguisticTagScheme.lemma.rawValue, options: options)
        
        var taggedTokens = [(token: String, tag: TokenTag, lemma: String)]()
        
        for (index, tag) in tags.enumerated() {
            let tokenRange = taggedTokenRanges[index]
            let token = string[tokenRange]
            let lemma = lemmas[index]
            taggedTokens.append((token: String(token), tag: tokenTag(for: NSLinguisticTag(rawValue: tag)), lemma: lemma))
        }
        
        return taggedTokens
    }
    
    private static func tokenTag(for tag: NSLinguisticTag) -> TokenTag {
        switch tag {
        case NSLinguisticTag.noun: return .noun
        case NSLinguisticTag.verb: return .verb
        case NSLinguisticTag.adjective: return .adjective
        case NSLinguisticTag.adverb: return .adverb
        case NSLinguisticTag.pronoun: return .pronoun
        case NSLinguisticTag.determiner: return .determiner
        case NSLinguisticTag.particle: return .particle
        case NSLinguisticTag.preposition: return .preposition
        case NSLinguisticTag.number: return .number
        case NSLinguisticTag.conjunction: return .conjunction
        case NSLinguisticTag.interjection: return .interjection
        case NSLinguisticTag.classifier: return .classifier
        case NSLinguisticTag.idiom: return .idiom
        case NSLinguisticTag.otherWord: return .otherWord
        case NSLinguisticTag.sentenceTerminator: return .sentenceTerminator
        case NSLinguisticTag.openQuote: return .openQuote
        case NSLinguisticTag.closeQuote: return .closeQuote
        case NSLinguisticTag.openParenthesis: return .openParenthesis
        case NSLinguisticTag.closeParenthesis: return .closeParenthesis
        case NSLinguisticTag.wordJoiner: return .wordJoiner
        case NSLinguisticTag.dash: return .dash
        case NSLinguisticTag.otherPunctuation: return .otherPunctuation
        case NSLinguisticTag.paragraphBreak: return .paragraphBreak
        case NSLinguisticTag.otherWhitespace: return .otherWhitespace
        case NSLinguisticTag.personalName: return .personalName
        case NSLinguisticTag.placeName: return .placeName
        case NSLinguisticTag.organizationName: return .organizationName
        default: return .unknown
        }
    }
}


