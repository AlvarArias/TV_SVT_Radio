//
//  APIClientTests.swift
//  TV_SVT_RadioTests
//

import XCTest
@testable import TV_SVT_Radio

@MainActor
final class APIClientTests: XCTestCase {

    // MARK: - fetchLocalStations success

    func testFetchLocalStationsReturnsStations() async {
        let result = await APIClient.shared.fetchLocalStations()

        guard case .success(let stations) = result else {
            XCTFail("Expected success but got failure: \(result)")
            return
        }
        XCTAssertFalse(stations.isEmpty)
    }

    func testFetchLocalStationsReturns52Stations() async {
        let result = await APIClient.shared.fetchLocalStations()

        guard case .success(let stations) = result else {
            XCTFail("Expected success")
            return
        }
        XCTAssertEqual(stations.count, 52)
    }

    func testFetchLocalStationsFirstStationIsP1() async {
        let result = await APIClient.shared.fetchLocalStations()

        guard case .success(let stations) = result else {
            XCTFail("Expected success")
            return
        }
        XCTAssertEqual(stations.first?.name, "P1")
        XCTAssertEqual(stations.first?.id, "132")
    }

    func testFetchLocalStationsAllHaveValidStreamURL() async {
        let result = await APIClient.shared.fetchLocalStations()

        guard case .success(let stations) = result else {
            XCTFail("Expected success")
            return
        }
        let invalidURLStations = stations.filter { URL(string: $0.url) == nil || $0.url.isEmpty }
        XCTAssertTrue(invalidURLStations.isEmpty, "All stations should have a parseable stream URL")
    }

    // MARK: - fetchLocalStations failure

    func testFetchLocalStationsReturnsFailureForMissingFile() async {
        let result = await APIClient.shared.fetchLocalStations(fileName: "does_not_exist")

        guard case .failure(let error) = result else {
            XCTFail("Expected failure for non-existent file")
            return
        }
        if case .invalidURL(let name) = error {
            XCTAssertEqual(name, "does_not_exist")
        } else {
            XCTFail("Expected .invalidURL error, got \(error)")
        }
    }

    func testFetchLocalStationsFailureHasNonEmptyDescription() async {
        let result = await APIClient.shared.fetchLocalStations(fileName: "does_not_exist")

        if case .failure(let error) = result {
            XCTAssertNotNil(error.errorDescription)
            XCTAssertFalse(error.errorDescription!.isEmpty)
        }
    }
}
