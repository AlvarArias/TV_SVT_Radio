//
//  PlayRadio.swift
//  TV_SVT_RadioTests
//
//  Created by Alvar Arias on 2024-05-04.
//

import XCTest
@testable import TV_SVT_Radio

final class PlayRadioTest: XCTestCase {

    var playRadio: PlayRadio!

    override func setUp() {
        super.setUp()
        playRadio = PlayRadio()
    }

    override func tearDown() {
        playRadio = nil
        super.tearDown()
    }

    func testPlaySongRadioReturnsTrueWhenPlaying() {
        let result = playRadio.playSongRadio(radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3", isPlaying: true)
        XCTAssertTrue(result, "playSongRadio should return true when isPlaying is true")
    }

    func testPlaySongRadioReturnsFalseWhenNotPlaying() {
        let result = playRadio.playSongRadio(radioURL: "http://sverigesradio.se/topsy/direkt/srapi/132.mp3", isPlaying: false)
        XCTAssertFalse(result, "playSongRadio should return false when isPlaying is false")
    }

}
    

