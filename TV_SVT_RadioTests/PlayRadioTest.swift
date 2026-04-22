//
//  PlayRadioTest.swift
//  TV_SVT_RadioTests
//

import XCTest
@testable import TV_SVT_Radio

@MainActor
final class PlayRadioTests: XCTestCase {

    var playRadio: PlayRadio!

    override func setUp() {
        super.setUp()
        playRadio = PlayRadio()
    }

    override func tearDown() {
        playRadio = nil
        super.tearDown()
    }

    // MARK: - Invalid URL

    func testPlaySongRadioReturnsFalseForEmptyURL() {
        let result = playRadio.playSongRadio(radioURL: "", isPlaying: true)
        XCTAssertFalse(result, "An empty URL string should not be a valid URL")
    }

    func testPlaySongRadioReturnsFalseForMalformedURL() {
        let result = playRadio.playSongRadio(radioURL: "not a valid url %%%", isPlaying: true)
        XCTAssertFalse(result)
    }

    // MARK: - Valid URL

    func testPlaySongRadioReturnsTrueWhenIsPlayingTrue() {
        let result = playRadio.playSongRadio(
            radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3",
            isPlaying: true
        )
        XCTAssertTrue(result, "A valid URL with isPlaying=true should return true")
    }

    func testPlaySongRadioReturnsFalseWhenIsPlayingFalse() {
        let result = playRadio.playSongRadio(
            radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3",
            isPlaying: false
        )
        XCTAssertFalse(result, "A valid URL with isPlaying=false should return false (paused)")
    }

    // MARK: - State

    func testPlayerIsNotNilAfterValidPlay() {
        _ = playRadio.playSongRadio(
            radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3",
            isPlaying: true
        )
        XCTAssertNotNil(playRadio.player)
    }

    func testPlayerIsReplacedOnSubsequentCalls() {
        _ = playRadio.playSongRadio(
            radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3",
            isPlaying: true
        )
        let firstPlayer = playRadio.player

        _ = playRadio.playSongRadio(
            radioURL: "http://sverigesradio.se/topsy/direkt/srapi/163.mp3",
            isPlaying: true
        )
        XCTAssertFalse(playRadio.player === firstPlayer, "Player should be replaced when a new station is played")
    }
}
