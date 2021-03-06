import XCTest
@testable import TextToolbox

final class TextToolboxTests: XCTestCase {
    
    func testEmptyScanner() {
        let scanner = TextScanner(string: "")
        
        XCTAssert(scanner.isAtEnd)
        XCTAssertFalse(scanner.hasMore)
        XCTAssertEqual(scanner.remainderCount, 0)
        
        XCTAssertNil(scanner.scan())
        XCTAssertNil(scanner.scan(count: 5))
        XCTAssertNil(scanner.scanAtMost(7))

        XCTAssertNil(scanner.scan("Test"))
        
        XCTAssertEqual(scanner.stringRemainder, "")
        
        XCTAssertNil(scanner.peekAtNext(5))
    }
    
    func testRemainderCount() {
        let scanner = TextScanner(string: "12345")
        XCTAssertEqual(scanner.remainderCount, 5)
        for i in [4, 3, 2, 1, 0] {
            scanner.skip()
            XCTAssertEqual(scanner.remainderCount, i)
        }
        XCTAssertEqual(scanner.remainderCount, 0)
        XCTAssert(scanner.isAtEnd)
        XCTAssertFalse(scanner.hasMore)
    }
    
    func testScan() {
        let scanner = TextScanner(string: "12345")
        for character in "12345" {
            XCTAssertEqual(scanner.scan(), String(character))
        }
        XCTAssertEqual(scanner.remainderCount, 0)
        XCTAssert(scanner.isAtEnd)
        XCTAssertFalse(scanner.hasMore)
    }
        
    func testScanString() {
        let scanner = TextScanner(string: "1234512345")
        XCTAssertEqual(scanner.scan("12345"), "12345")
        XCTAssertEqual(scanner.scan("1234"), "1234")
        XCTAssertEqual(scanner.remainderCount, 1)
        XCTAssertNil(scanner.scan("1234"))
        XCTAssertEqual(scanner.remainderCount, 1)
        XCTAssertEqual(scanner.scan("5"), "5")
        XCTAssertEqual(scanner.remainderCount, 0)
        XCTAssert(scanner.isAtEnd)
        XCTAssertFalse(scanner.hasMore)
    }
    
    func testScanRepeatCount() {
        let scanner = TextScanner(string: "12345123451234")
        XCTAssertEqual(scanner.scan("12345", repeatCount: 2), "1234512345")
        XCTAssertEqual(scanner.remainderCount, 4)
        
        let scanner2 = TextScanner(string: "1234512345")
        XCTAssertEqual(scanner2.scan("12345", repeatCount: 2), "1234512345")
        XCTAssertEqual(scanner2.remainderCount, 0)
        XCTAssert(scanner2.isAtEnd)
        XCTAssertFalse(scanner2.hasMore)
    }
    
    func testScanSome() {
        let scanner = TextScanner(string: "12345123451234")
        XCTAssertEqual(scanner.scanSome("12345"), "1234512345")
        XCTAssertEqual(scanner.remainderCount, 4)
        
        let scanner2 = TextScanner(string: "1234512345")
        XCTAssertEqual(scanner2.scanSome("12345"), "1234512345")
        XCTAssertEqual(scanner2.remainderCount, 0)
        XCTAssert(scanner2.isAtEnd)
        XCTAssertFalse(scanner2.hasMore)
    }
    
    func testScanUpTo() {
        let scanner = TextScanner(string: "1234567890")
        XCTAssertEqual(scanner.scanUpTo("78"), "123456")
        XCTAssertEqual(scanner.remainderCount, 4)
        XCTAssertNil(scanner.scanUpTo("whatever"))
    }
    
    func testScanCount() {
        let scanner = TextScanner(string: "1234567890")
        XCTAssertEqual(scanner.scan(count: 5), "12345")
        XCTAssertEqual(scanner.scan(count: 5), "67890")
        XCTAssertNil(scanner.scan(count: 5))
    }
    
    func testScanThrough() {
        let scanner = TextScanner(string: "1234567890")
        XCTAssertEqual(scanner.scanThrough("67"), "1234567")
        XCTAssertEqual(scanner.remainderCount, 3)
        XCTAssertNil(scanner.scanThrough("whatever"))
    }
    
    func testScanUpToAndSkip() {
        let scanner = TextScanner(string: "1234567890")
        XCTAssertEqual(scanner.scanUpToAndSkip("67"), "12345")
        XCTAssertEqual(scanner.remainderCount, 3)
        XCTAssertNil(scanner.scanUpToAndSkip("whatever"))
    }
    
    func testScanAtMost() {
        let scanner = TextScanner(string: "12345")
        XCTAssertEqual(scanner.scanAtMost(10), "12345")
        XCTAssertNil(scanner.scanAtMost(10))
    }
    
    func testScanOneOf() {
        let scanner = TextScanner(string: "111124345")
        XCTAssertEqual(scanner.scanOne(of: "123"), "1")
        XCTAssertNil(scanner.scanOne(of: "abc"))
        let scanner2 = TextScanner(string: "111124345")
        XCTAssertEqual(scanner2.scanOne(of: CharacterSet(charactersIn: "123")), "1")
        XCTAssertNil(scanner2.scanOne(of: CharacterSet(charactersIn: "abc")))
    }
    
    func testScanAnyOf() {
        let scanner = TextScanner(string: "111124345")
        XCTAssertEqual(scanner.scanAny(of: "123"), "11112")
        XCTAssertNil(scanner.scanAny(of: "abc"))
        let scanner2 = TextScanner(string: "111124345")
        XCTAssertEqual(scanner2.scanAny(of: CharacterSet(charactersIn: "123")), "11112")
        XCTAssertNil(scanner2.scanAny(of: CharacterSet(charactersIn: "abc")))
    }
    
    func testScanUpToOneOf() {
        let scanner = TextScanner(string: "1234567890")
        XCTAssertEqual(scanner.scanUpTo(oneOf: "7890"), "123456")
        XCTAssertEqual(scanner.remainderCount, 4)
        XCTAssertNil(scanner.scanUpTo(oneOf: "1234"))
    }
    
    func testScanWhiteSpace() {
        let scanner = TextScanner(string: "    \n1234567890")
        XCTAssertEqual(scanner.scanWhiteSpace(), "    \n")
        scanner.reset()
        XCTAssertEqual(scanner.scanWhiteSpace(excludingNewlines: true), "    ")
    }
    
    func testScanNewLine() {
        let scanner = TextScanner(string: "\n")
        XCTAssertEqual(scanner.scanNewLine(), "\n")
        XCTAssertNil(scanner.scanNewLine())
        let scanner2 = TextScanner(string: "aaaa")
        XCTAssertNil(scanner2.scanNewLine())
    }
    
    func testScanUpToNewLine() {
        let scanner = TextScanner(string: "whatever\n")
        XCTAssertEqual(scanner.scanUpToNewLine(), "whatever")
        XCTAssertEqual(scanner.scanNewLine(), "\n")
    }
    
    func testScanThroughNewLine() {
        let scanner = TextScanner(string: "whatever\n")
        XCTAssertEqual(scanner.scanThroughNewLine(), "whatever\n")
    }
    
    // MARK: - Skipping
    
    func testSkipString() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skip("1234"))
        XCTAssertFalse(scanner.skip("1234"))
        XCTAssert(scanner.skip("5678"))
        XCTAssert(scanner.isAtEnd)
    }
    
    func testSkipUpTo() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skipUpTo("56"))
        XCTAssert(scanner.skip("5678"))
        XCTAssert(scanner.isAtEnd)
    }
    
    func testSkipThrough() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skipThrough("34"))
        XCTAssert(scanner.skip("5678"))
        XCTAssert(scanner.isAtEnd)
    }
    
    func testSkipCharacter() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skip())
        XCTAssert(scanner.skip("2345678"))
    }
    
    func testSkipOneOf() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skipOne(of: "123"))
        XCTAssert(scanner.skip("2345678"))
    }
    
    func testSkipAnyOf() {
        let scanner = TextScanner(string: "12345678")
        XCTAssert(scanner.skipAny(of: "132"))
        XCTAssert(scanner.skip("45678"))
    }
    
    func testSkipUpToOneOf() {
        func testSkipOneOf() {
            let scanner = TextScanner(string: "12345678")
            XCTAssert(scanner.skipUpTo(oneOf: "456"))
            XCTAssert(scanner.skip("45678"))
            scanner.reset()
            XCTAssertNil(scanner.skipUpTo(oneOf: "abc"))
        }
    }
    
    func testSkipNewLine() {
        let scanner = TextScanner(string: "\n")
        XCTAssert(scanner.skipNewLine())
        XCTAssertFalse(scanner.skipNewLine())
        let scanner2 = TextScanner(string: "aaaa")
        XCTAssertFalse(scanner2.skipNewLine())
    }
    
    func testSkipThroughNewLine() {
        let scanner = TextScanner(string: "whatever\n")
        XCTAssert(scanner.skipThroughNewLine())
        XCTAssert(scanner.isAtEnd)
    }
    
    func testSkipWhiteSpaceAndThenNewLine() {
        let scanner = TextScanner(string: "whatever\n")
        XCTAssertFalse(scanner.skipWhiteSpaceAndThenNewLine())
        let scanner2 = TextScanner(string: "\n")
        XCTAssert(scanner2.skipWhiteSpaceAndThenNewLine())
        XCTAssert(scanner2.isAtEnd)
        let scanner3 = TextScanner(string: "     \n")
        XCTAssert(scanner3.skipWhiteSpaceAndThenNewLine())
        XCTAssert(scanner3.isAtEnd)
    }
    
    // MARK: - Peeking
    
    func testPeek() {
        let scanner = TextScanner(string: "abcd")
        XCTAssertEqual(scanner.peek(), "a")
        XCTAssert(scanner.skip("abcd"))
    }
    
    func testPeekAtNext() {
        let scanner = TextScanner(string: "abcd")
        XCTAssertEqual(scanner.peekAtNext(3), "abc")
        XCTAssert(scanner.skip("abcd"))
    }
    
    func testPeekAtMostNext() {
        let scanner = TextScanner(string: "abcd")
        XCTAssertEqual(scanner.peekAtMostNext(13), "abcd")
        XCTAssert(scanner.skip("abcd"))
    }
        
    func testPeekMatch() {
        let scanner = TextScanner(string: "abcd")
        XCTAssert(scanner.peekMatch("abc"))
        XCTAssertFalse(scanner.peekMatch("cde"))
        XCTAssert(scanner.skip("abcd"))
    }
    
    func testIsEmptyLine() {
        XCTAssert(TextScanner(string: "\n").isEmptyLine())
        XCTAssert(TextScanner(string: "\n\n").isEmptyLine())
        XCTAssert(TextScanner(string: "      \n").isEmptyLine())
        XCTAssert(TextScanner(string: "        \t     \n").isEmptyLine())
        XCTAssert(TextScanner(string: "\t\n").isEmptyLine())
        XCTAssertFalse(TextScanner(string: "").isEmptyLine())
        XCTAssertFalse(TextScanner(string: "12345").isEmptyLine())
        XCTAssertFalse(TextScanner(string: "12345\n").isEmptyLine())
        XCTAssertFalse(TextScanner(string: "12345\n \n").isEmptyLine())
        XCTAssertFalse(TextScanner(string: "1\n\n").isEmptyLine())
    }
}
