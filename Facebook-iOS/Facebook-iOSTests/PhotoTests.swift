//
//  PhotoTests.swift
//  Facebook-iOSTests
//
//  Created by Evhenii Shovkovyi on 12.03.2024.
//

@testable import Facebook_iOS
import XCTest

final class PhotoTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testVerifyPhotoDefaultUrl() throws {
        let coverPhotoType = PhotoType.cover
        let profilePhotoType = PhotoType.profile

        XCTAssertEqual(coverPhotoType.defaultUrl.absoluteString, "https://png.pngtree.com/thumb_back/fh260/background/20230527/pngtree-nature-wallpapers-image_2683049.jpg")
        XCTAssertEqual(profilePhotoType.defaultUrl.absoluteString, "https://community.sailpoint.com/t5/image/serverpage/image-id/10533i1F90D9618A930108/image-size/large/is-moderation-mode/true?v=v2&px=999")
    }

    func testVerifyPhotoDefaultImage() throws {
        let coverPhotoType = PhotoType.cover
        let profilePhotoType = PhotoType.profile

        XCTAssertEqual(coverPhotoType.defaultImage, "default_cover")
        XCTAssertEqual(profilePhotoType.defaultImage, "default_profile")
    }

    func testVerifyPhotoEquatability() throws {
        let photo = try Photo(dictionary: JsonReader.readJson(filename: "photoResponseMock"))
        let photo2 = try Photo(dictionary: JsonReader.readJson(filename: "photo2ResponseMock"))
        XCTAssertNotEqual(photo, photo2)
    }

    func testVerifyPhotoHashability() throws {
        let photo = try Photo(dictionary: JsonReader.readJson(filename: "photoResponseMock"))
        let photo2 = try Photo(dictionary: JsonReader.readJson(filename: "photo2ResponseMock"))
        XCTAssertNotEqual(photo.hashValue, photo2.hashValue)
    }

}
