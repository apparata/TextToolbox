import XCTest
@testable import TextToolbox

fileprivate struct Country: Equatable {
    let name: String
    let code: String
}

final class FuzzySearcherTests: XCTestCase {

    private var countries: [Country] = []
    private var searcher: FuzzySearcher<Country>!

    override func setUp() {
        countries = [
            Country(name: "Germany", code: "DE"),
            Country(name: "France", code: "FR"),
            Country(name: "España", code: "ES"),
            Country(name: "Italy", code: "IT"),
            Country(name: "Portugal", code: "PT"),
            Country(name: "Netherlands", code: "NL")
        ]
        searcher = FuzzySearcher(items: countries, keyPath: \.name, maxDistance: 2)
    }

    func testExactMatch() {
        let result = searcher.search("France")
        XCTAssertEqual(result, [Country(name: "France", code: "FR")])
    }

    func testDiacriticInsensitiveMatch() {
        let result = searcher.search("Espana")
        XCTAssertEqual(result, [Country(name: "España", code: "ES")])
    }

    func testSingleEditDistance() {
        let result = searcher.search("Italu")
        XCTAssertEqual(result, [Country(name: "Italy", code: "IT")])
    }

    func testMultipleMatchesSortedByDistance() {
        let result = searcher.search("Germony")
        XCTAssertEqual(result.first, Country(name: "Germany", code: "DE"))
        XCTAssertTrue(result.contains { $0.name == "Germany" })
    }

    func testNoMatchAboveThreshold() {
        let result = searcher.search("Xyzland")
        XCTAssertTrue(result.isEmpty)
    }

    func testMultipleCloseMatches() {
        let result = searcher.search("Frnce")
        XCTAssertEqual(result, [Country(name: "France", code: "FR")])
    }
}
