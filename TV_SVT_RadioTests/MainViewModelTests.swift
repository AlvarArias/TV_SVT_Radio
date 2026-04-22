//
//  MainViewModelTests.swift
//  TV_SVT_RadioTests
//

import XCTest
@testable import TV_SVT_Radio

@MainActor
final class MainViewModelTests: XCTestCase {

    var viewModel: MainViewModel!

    override func setUp() {
        super.setUp()
        viewModel = MainViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial state

    func testInitialStationsListIsEmpty() {
        XCTAssertTrue(viewModel.listRadioStaions.isEmpty)
    }

    func testInitialErrorMessageIsNil() {
        XCTAssertNil(viewModel.errorMessage)
    }

    // MARK: - fetchChannels success

    func testFetchChannelsPopulatesStationsList() async {
        await viewModel.fetchChannels()
        XCTAssertFalse(viewModel.listRadioStaions.isEmpty)
    }

    func testFetchChannelsLoads52Stations() async {
        await viewModel.fetchChannels()
        XCTAssertEqual(viewModel.listRadioStaions.count, 52)
    }

    func testFetchChannelsClearsErrorMessageOnSuccess() async {
        await viewModel.fetchChannels()
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchChannelsFirstStationIsP1() async {
        await viewModel.fetchChannels()
        XCTAssertEqual(viewModel.listRadioStaions.first?.name, "P1")
    }

    func testFetchChannelsCanBeCalledMultipleTimes() async {
        await viewModel.fetchChannels()
        let countFirst = viewModel.listRadioStaions.count

        await viewModel.fetchChannels()
        let countSecond = viewModel.listRadioStaions.count

        XCTAssertEqual(countFirst, countSecond)
    }
}
