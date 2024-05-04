//
//  LoadRadioStationJSON.swift
//  TV_SVT_RadioTests
//
//  Created by Alvar Arias on 2024-05-04.
//

import XCTest
@testable import TV_SVT_Radio

class LoadRadioStationJSONFileTests: XCTestCase {
    
    var loadRadioStationJSONFile: LoadRadioStationJSONFile!
    
    override func setUp() {
        super.setUp()
        loadRadioStationJSONFile = LoadRadioStationJSONFile()
    }
    
    override func tearDown() {
        loadRadioStationJSONFile = nil
        super.tearDown()
    }
    
    func testLoadStationReturnsEmptyWhenFileNotFound() {
        // Pass an incorrect file name to simulate file not found
        let result = loadRadioStationJSONFile.loadStation(fileName: "incorrectFileName")
        XCTAssertTrue(result.isEmpty, "loadStation should return an empty array when the file is not found")
    }
    
    func testLoadStationReturnsDecodedDataWhenFileFound() {
        // Assuming that the file "radios23.json" exists and contains valid data
        let result = loadRadioStationJSONFile.loadStation()
        XCTAssertFalse(result.isEmpty, "loadStation should return decoded data when the file is found and contains valid data")
    }
}
