//
//  TransactionsRepositoryTests.swift
//  TrustWalletChallengeTests
//
//  Created by Esteban Boffa on 02/03/2023.
//

import XCTest
@testable import TrustWalletChallenge

final class TransactionsRepositoryTests: XCTestCase {

    // MARK: Properties

    var repository: TransactionsRepository!

    // MARK: setUp

    override func setUp() {
        repository = TransactionsRepository()
    }

    // MARK: Tests

    func test_get_withNoTransaction_shouldRetrieveExpectedValue() {
        var value = repository.get("foo")
        XCTAssertNil(value)

        repository.set(key: "foo", value: "123", transactionsCounter: 0)
        repository.set(key: "car", value: "999", transactionsCounter: 0)
        value = repository.get("foo")
        XCTAssertEqual(value, "123")
        value = repository.get("car")
        XCTAssertEqual(value, "999")
    }

    func test_set_withNoTransaction_shouldSetExpectedValue() {
        repository.set(key: "foo", value: "123", transactionsCounter: 0)
        repository.set(key: "foo", value: "456", transactionsCounter: 0)
        repository.set(key: "car", value: "333", transactionsCounter: 0)
        XCTAssertEqual(repository.dictionary.count, 2)

        var value = repository.get("foo")
        XCTAssertEqual(value, "456")
        value = repository.get("car")
        XCTAssertEqual(value, "333")
    }

    func test_count_withNoTransaction_shouldReturnExpectedValue() {
        XCTAssertEqual(repository.dictionary.count, 0)

        repository.set(key: "var", value: "456", transactionsCounter: 0)
        repository.set(key: "foo", value: "456", transactionsCounter: 0)
        repository.set(key: "test", value: "99", transactionsCounter: 0)
        repository.set(key: "car", value: "456", transactionsCounter: 0)
        XCTAssertEqual(repository.count(for: "456"), 3)
    }

    func test_delete_withNoTransaction_shouldDeleteExpectedValue() {
        repository.set(key: "var", value: "456", transactionsCounter: 0)
        repository.set(key: "foo", value: "456", transactionsCounter: 0)
        XCTAssertNotNil(repository.get("var"))
        repository.delete("var", transactionsCounter: 0)
        XCTAssertNil(repository.get("var"))
    }

    func test_startTransaction_whenItIsTheFirstTransaction_shouldSetTemporaryDictionary() {
        repository.set(key: "foo", value: "456", transactionsCounter: 0)
        repository.startTransaction()
        XCTAssertEqual(repository.temporaryDictionary, repository.dictionary)
        XCTAssertEqual(repository.queues.count, 1)
    }

    func test_startTransaction_whenItIsNotTheFirstTransaction_shouldNotSetTemporaryDictionary() {
        repository.set(key: "foo", value: "456", transactionsCounter: 0)
        repository.startTransaction()
        repository.set(key: "car", value: "456", transactionsCounter: 1)
        let tempDict = repository.temporaryDictionary

        repository.startTransaction()
        XCTAssertEqual(repository.temporaryDictionary, tempDict)
    }

    func test_commitTransaction_whenItIsTheOnlyExistingTransaction_shouldCompleteCurrentTransaction() {
        repository.startTransaction()
        repository.set(key: "car", value: "789", transactionsCounter: 1)
        repository.set(key: "foo", value: "789", transactionsCounter: 1)
        repository.set(key: "var", value: "123", transactionsCounter: 1)
        repository.delete("var", transactionsCounter: 1)

        repository.commitTransaction(1)
        XCTAssertEqual(repository.dictionary.count, 2)
        XCTAssertEqual(repository.count(for: "789"), 2)
        XCTAssertEqual(repository.temporaryDictionary.count, 0)
    }

    func test_commitTransaction_whenItIsNotTheOnlyExistingTransaction_shouldCompleteCurrentTransaction() {
        repository.startTransaction()
        repository.set(key: "car", value: "789", transactionsCounter: 1)
        repository.set(key: "foo", value: "789", transactionsCounter: 1)
        repository.set(key: "var", value: "123", transactionsCounter: 1)
        repository.delete("var", transactionsCounter: 1)

        repository.startTransaction()
        repository.set(key: "car", value: "333", transactionsCounter: 2)

        repository.commitTransaction(2)
        XCTAssertEqual(repository.temporaryDictionary.count, 2)
        XCTAssertEqual(repository.get("car"), "333")
    }

    func test_rollback_whenItIsTheOnlyExistingTransaction_shouldRevertToStatePriorToStartCall() {
        repository.set(key: "car", value: "123", transactionsCounter: 0)
        repository.startTransaction()
        repository.set(key: "car", value: "789", transactionsCounter: 1)
        repository.set(key: "foo", value: "789", transactionsCounter: 1)
        repository.set(key: "var", value: "123", transactionsCounter: 1)
        repository.delete("var", transactionsCounter: 1)

        XCTAssertEqual(repository.get("car"), "789")
        XCTAssertEqual(repository.get("foo"), "789")
        XCTAssertEqual(repository.count(for: "789"), 2)

        repository.rollback()
        XCTAssertEqual(repository.get("car"), "123")
        XCTAssertNil(repository.get("foo"))
    }

    func test_rollback_whenItIsNotTheOnlyExistingTransaction_shouldRevertToStatePriorToStartCall() {
        repository.startTransaction()
        repository.set(key: "car", value: "789", transactionsCounter: 1)
        repository.set(key: "foo", value: "789", transactionsCounter: 1)
        repository.set(key: "var", value: "123", transactionsCounter: 1)
        repository.delete("var", transactionsCounter: 1)

        XCTAssertEqual(repository.get("car"), "789")
        XCTAssertEqual(repository.get("foo"), "789")
        XCTAssertEqual(repository.count(for: "789"), 2)

        repository.startTransaction()
        repository.set(key: "foo", value: "456", transactionsCounter: 2)
        repository.set(key: "test", value: "000", transactionsCounter: 2)
        repository.delete("car", transactionsCounter: 2)

        XCTAssertEqual(repository.get("foo"), "456")
        XCTAssertNil(repository.get("car"))
        XCTAssertEqual(repository.temporaryDictionary.count, 2)

        repository.rollback()
        XCTAssertEqual(repository.get("foo"), "789")
        XCTAssertEqual(repository.get("car"), "789")
        XCTAssertNil(repository.get("test"))
        XCTAssertEqual(repository.temporaryDictionary.count, 2)
    }
}
