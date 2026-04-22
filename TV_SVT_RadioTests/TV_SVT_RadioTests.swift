//
//  TV_SVT_RadioTests.swift
//  TV_SVT_RadioTests
//

import XCTest
@testable import TV_SVT_Radio

final class RadioStationTests: XCTestCase {

    // MARK: - Codable

    func testRadioStationDecodesFromValidJSON() throws {
        let json = """
        {
            "image": "https://example.com/img.jpg",
            "imagetemplate": "https://example.com/img_template.jpg",
            "color": "FF0000",
            "tagline": "Test tagline",
            "siteurl": "https://example.com",
            "url": "http://example.com/stream.mp3",
            "scheduleurl": "http://example.com/schedule",
            "xmltvid": "test.xml",
            "name": "Test Radio",
            "id": "999"
        }
        """.data(using: .utf8)!

        let station = try JSONDecoder().decode(RadioStation.self, from: json)

        XCTAssertEqual(station.name, "Test Radio")
        XCTAssertEqual(station.id, "999")
        XCTAssertEqual(station.color, "FF0000")
        XCTAssertEqual(station.url, "http://example.com/stream.mp3")
    }

    func testRadioStationDecodesArrayFromJSON() throws {
        let json = """
        [
            {
                "image": "https://a.com/a.jpg",
                "imagetemplate": "https://a.com/a.jpg",
                "color": "000000",
                "tagline": "A",
                "siteurl": "https://a.com",
                "url": "http://a.com/stream.mp3",
                "scheduleurl": "http://a.com/schedule",
                "xmltvid": "a.xml",
                "name": "Alpha",
                "id": "1"
            },
            {
                "image": "https://b.com/b.jpg",
                "imagetemplate": "https://b.com/b.jpg",
                "color": "FFFFFF",
                "tagline": "B",
                "siteurl": "https://b.com",
                "url": "http://b.com/stream.mp3",
                "scheduleurl": "http://b.com/schedule",
                "xmltvid": "b.xml",
                "name": "Beta",
                "id": "2"
            }
        ]
        """.data(using: .utf8)!

        let stations = try JSONDecoder().decode([RadioStation].self, from: json)

        XCTAssertEqual(stations.count, 2)
        XCTAssertEqual(stations[0].name, "Alpha")
        XCTAssertEqual(stations[1].name, "Beta")
    }

    func testRadioStationEncodesAndDecodesRoundTrip() throws {
        let original = RadioStation(
            image: "https://img.com/x.jpg",
            imagetemplate: "https://img.com/x.jpg",
            color: "AABBCC",
            tagline: "Round trip test",
            siteurl: "https://radio.com",
            url: "http://radio.com/live.mp3",
            scheduleurl: "http://radio.com/schedule",
            xmltvid: "round.xml",
            name: "Round Trip Radio",
            id: "42"
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(RadioStation.self, from: data)

        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.url, original.url)
        XCTAssertEqual(decoded.color, original.color)
    }

    func testRadioStationIgnoresExtraJSONKeys() throws {
        let jsonWithExtra = """
        {
            "image": "https://example.com/img.jpg",
            "imagetemplate": "https://example.com/img.jpg",
            "color": "123456",
            "tagline": "tagline",
            "siteurl": "https://example.com",
            "url": "http://example.com/stream.mp3",
            "scheduleurl": "http://example.com/schedule",
            "xmltvid": "x.xml",
            "name": "P1",
            "id": "132",
            "channeltype": "Rikskanal",
            "unknownKey": "some value"
        }
        """.data(using: .utf8)!

        XCTAssertNoThrow(try JSONDecoder().decode(RadioStation.self, from: jsonWithExtra))
    }

    func testRadioStationDecodingFailsOnMissingRequiredKey() {
        let incompleteJSON = """
        {
            "image": "https://example.com/img.jpg",
            "name": "Incomplete Station"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(RadioStation.self, from: incompleteJSON))
    }

    // MARK: - Hashable / Equatable

    func testRadioStationsWithSameDataAreEqual() {
        let a = RadioStation(
            image: "img", imagetemplate: "tmpl", color: "red",
            tagline: "tag", siteurl: "site", url: "url",
            scheduleurl: "sched", xmltvid: "xml", name: "Radio A", id: "1"
        )
        let b = RadioStation(
            image: "img", imagetemplate: "tmpl", color: "red",
            tagline: "tag", siteurl: "site", url: "url",
            scheduleurl: "sched", xmltvid: "xml", name: "Radio A", id: "1"
        )
        XCTAssertEqual(a, b)
    }

    func testRadioStationsWithDifferentIDsAreNotEqual() {
        let a = RadioStation(
            image: "img", imagetemplate: "tmpl", color: "red",
            tagline: "tag", siteurl: "site", url: "url",
            scheduleurl: "sched", xmltvid: "xml", name: "Radio A", id: "1"
        )
        let b = RadioStation(
            image: "img", imagetemplate: "tmpl", color: "red",
            tagline: "tag", siteurl: "site", url: "url",
            scheduleurl: "sched", xmltvid: "xml", name: "Radio A", id: "2"
        )
        XCTAssertNotEqual(a, b)
    }

    func testRadioStationCanBeStoredInSet() {
        let a = RadioStation(
            image: "img", imagetemplate: "tmpl", color: "red",
            tagline: "tag", siteurl: "site", url: "url",
            scheduleurl: "sched", xmltvid: "xml", name: "Radio A", id: "1"
        )
        let set: Set<RadioStation> = [a, a]
        XCTAssertEqual(set.count, 1)
    }

    // MARK: - APIError descriptions

    func testAPIErrorInvalidURLHasDescription() {
        let error = APIError.invalidURL("bad-url")
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("bad-url"))
    }

    func testAPIErrorHTTPErrorHasStatusCode() {
        let error = APIError.httpError(statusCode: 404)
        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("404"))
    }

    func testAPIErrorNetworkErrorHasDescription() {
        let urlError = URLError(.notConnectedToInternet)
        let error = APIError.networkError(urlError)
        XCTAssertNotNil(error.errorDescription)
        XCTAssertFalse(error.errorDescription!.isEmpty)
    }
}
