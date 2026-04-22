//
//  LoadRadioStationJSON.swift
//  TV_SVT_RadioTests
//

import XCTest
@testable import TV_SVT_Radio

final class LoadRadioStationJSONFileTests: XCTestCase {

    var loader: LoadRadioStationJSONFile!

    override func setUp() {
        super.setUp()
        loader = LoadRadioStationJSONFile()
    }

    override func tearDown() {
        loader = nil
        super.tearDown()
    }

    // MARK: - File not found

    func testLoadStationReturnsEmptyWhenFileNotFound() {
        let result = loader.loadStation(fileName: "nonexistent_file")
        XCTAssertTrue(result.isEmpty)
    }

    // MARK: - Loading real data

    func testLoadStationReturnsNonEmptyArray() {
        let result = loader.loadStation()
        XCTAssertFalse(result.isEmpty, "radios23.json should contain at least one station")
    }

    func testLoadStationReturns52Stations() {
        let result = loader.loadStation()
        XCTAssertEqual(result.count, 52)
    }

    func testLoadStationFirstStationIsP1() {
        let result = loader.loadStation()
        XCTAssertEqual(result.first?.name, "P1")
        XCTAssertEqual(result.first?.id, "132")
    }

    func testLoadStationAllStationsHaveNonEmptyURL() {
        let result = loader.loadStation()
        let emptyURLs = result.filter { $0.url.isEmpty }
        XCTAssertTrue(emptyURLs.isEmpty, "All stations should have a non-empty stream URL")
    }

    func testLoadStationAllStationsHaveNonEmptyName() {
        let result = loader.loadStation()
        let unnamed = result.filter { $0.name.isEmpty }
        XCTAssertTrue(unnamed.isEmpty, "All stations should have a non-empty name")
    }

    func testLoadStationAllStationsHaveNonEmptyID() {
        let result = loader.loadStation()
        let noID = result.filter { $0.id.isEmpty }
        XCTAssertTrue(noID.isEmpty, "All stations should have a non-empty ID")
    }

    // MARK: - Stateful caching

    func testLoadStationUpdatesRadioStationsProperty() {
        let result = loader.loadStation()
        XCTAssertEqual(loader.radioStations.count, result.count)
    }

    func testLoadStationDoesNotUpdateStateWhenFileNotFound() {
        // Load valid data first, then attempt a bad file name
        _ = loader.loadStation()
        let countBefore = loader.radioStations.count
        _ = loader.loadStation(fileName: "nonexistent_file")
        // radioStations should remain unchanged because the guard returns early
        XCTAssertEqual(loader.radioStations.count, countBefore)
    }
}
