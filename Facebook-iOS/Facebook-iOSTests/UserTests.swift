//
//  UserTests.swift
//  Facebook-iOSTests
//
//  Created by Evhenii Shovkovyi on 12.03.2024.
//

@testable import Facebook_iOS
import XCTest

final class UserTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testVerifyFirsNameAndLastName() throws {
        let user = User(firstName: "Evhenii", lastName: "Shelby")
        let expectedNameAndLastName = "Evhenii Shelby"

        XCTAssertTrue(user.getUserFirsNameAndLastName() == expectedNameAndLastName, "First name and/or Last Name of user is not equal to expected")
    }

    func testVerifyUsersPictureUrlDidSetCorrectly() throws {
        var user = User(firstName: "Evhenii", lastName: "Shelby")
        let expectedUrl = "https://www.apple.com/ua/"

        // swiftlint:disable:next force_unwrapping
        user.setPictureUrl(with: URL(string: expectedUrl)!)
        XCTAssertTrue(user.picture.data.url.absoluteString == expectedUrl, "Picture url is not equalt to expected")

    }

    func testVerifyUserEquatability() throws {
        let user = try User(dictionary: JsonReader.readJson(filename: "userResponseMock"))
        let user2 = try User(dictionary: JsonReader.readJson(filename: "userResponseMock"))
        let user3 = User(firstName: "Peter", lastName: "Parker")
        XCTAssertTrue(user == user2, "User1 is not equal to User2")
        XCTAssertTrue(user != user3, "User1 is equal to User3")
    }

    func testVerifyUserHashability() throws {
        let user = try User(dictionary: JsonReader.readJson(filename: "userResponseMock"))
        let user2 = try User(dictionary: JsonReader.readJson(filename: "user2ResponseMock"))
        XCTAssertTrue(user.hashValue != user2.hashValue)
    }

}
