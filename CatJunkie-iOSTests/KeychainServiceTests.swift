//
//  KeychainServiceTests.swift
//  CatJunkie-iOSTests
//
//  Created by e.vanags on 24/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import XCTest
@testable import CatJunkie_iOS

final class KeychainServiceTests: XCTestCase {

    private var keychainService: KeychainService!

    override func setUp() {
        if let bundleIdentifier = Bundle(for: KeychainServiceTests.self).bundleIdentifier {
            keychainService = KeychainService(bundleIdentifier)
        }
    }

    override func tearDown() {
        try? keychainService.removeValue()

        keychainService = nil
    }

    func testSetValueWithSuccess() {
        XCTAssertNoThrow(try keychainService.setValue("value"), "Attempt to store value in keychain threw an error.")
    }

    func testGetValueWithSuccess() {
        let expected = "value"

        try? keychainService.setValue(expected)

        XCTAssertNoThrow(try keychainService.getValue(), "Attempt to retrieve value from keychain threw an error.")

        let storedValue = try? keychainService.getValue()
        XCTAssertEqual(storedValue, expected, "Expected: \(expected). Received: \(storedValue ?? "nil").")
    }

    func testUpdateValueWithSuccess() {
        let expected = "newValue"

        try? keychainService.setValue("value")

        XCTAssertNoThrow(try keychainService.setValue(expected), "Attempt to update value in keychain threw an error.")
        let storedValue = try? keychainService.getValue()
        XCTAssertEqual(storedValue, expected, "Expected: \(expected). Received: \(storedValue ?? "nil").")
    }

    func testRemoveValueWithSuccess() {
        let expected = "value"

        try? keychainService.setValue(expected)

        XCTAssertNoThrow(try keychainService.getValue(), "Attempt to retrieve value from keychain threw an error.")

        let storedValue = try? keychainService.getValue()
        XCTAssertEqual(storedValue, expected, "Expected: \(expected). Received: \(storedValue ?? "nil").")

        XCTAssertNoThrow(try keychainService.removeValue(), "Attempt to remove value from keychain threw an error.")
    }

    func testGetValueThrowsError() {
        XCTAssertNoThrow(try keychainService.getValue(), "Attempt to retrieve unexistent value threw an error.")
        XCTAssertNil(try keychainService.getValue())
    }
}
