//
//  HomeViewModelTests.swift
//  TrustWalletChallengeTests
//
//  Created by Esteban Boffa on 02/03/2023.
//

import XCTest
@testable import TrustWalletChallenge

final class HomeViewModelTests: XCTestCase {

    // MARK: Properties

    var homeViewModel: HomeViewModel!
    var mockedTransactionsRepository: MockedTransactionsRepository!

    // MARK: setUp

    @MainActor
    override func setUp() {
        mockedTransactionsRepository = MockedTransactionsRepository()
        homeViewModel = HomeViewModel(repository: mockedTransactionsRepository)
    }

    // MARK: Tests - Commands

    @MainActor
    func test_didTapGetButton_shouldCallGetMethodAndUpdateGetValue() {
        XCTAssertEqual(mockedTransactionsRepository.getCalledCount, 0)
        XCTAssertEqual(homeViewModel.getValue, "")

        homeViewModel.didTapGetButton(with: "car")
        XCTAssertEqual(mockedTransactionsRepository.getCalledCount, 1)
        XCTAssertEqual(homeViewModel.getValue, "value")
    }

    @MainActor
    func test_didTapSetButton_shouldCallSetMethod() {
        XCTAssertEqual(mockedTransactionsRepository.setCalledCount, 0)

        homeViewModel.didTapSetButton(key: "car", value: "")
        XCTAssertEqual(mockedTransactionsRepository.setCalledCount, 1)
    }

    @MainActor
    func test_didTapCountButton_shouldCallCountMethodAndUpdateCountValue() {
        XCTAssertEqual(mockedTransactionsRepository.countCalledCount, 0)
        XCTAssertEqual(homeViewModel.countValue, 0)

        homeViewModel.didTapCountButton(for: "123")
        XCTAssertEqual(mockedTransactionsRepository.countCalledCount, 1)
        XCTAssertEqual(homeViewModel.countValue, 3)
    }

    @MainActor
    func test_didTapDeleteButton_shouldCallDeleteMethod() {
        XCTAssertEqual(mockedTransactionsRepository.deleteCalledCount, 0)

        homeViewModel.didTapDeleteButton(for: "car")
        XCTAssertEqual(mockedTransactionsRepository.deleteCalledCount, 1)
    }

    // MARK: Tests - Operations

    @MainActor
    func test_didTapBeginButton_shouldIncrementTransactionsCounterAndCallStartTransactionMethod() {
        XCTAssertEqual(mockedTransactionsRepository.startTransactionCalledCount, 0)
        XCTAssertEqual(homeViewModel.transactionsCounter, 0)

        homeViewModel.didTapBeginButton()
        XCTAssertEqual(mockedTransactionsRepository.startTransactionCalledCount, 1)
        XCTAssertEqual(homeViewModel.transactionsCounter, 1)
    }

    @MainActor
    func test_didTapCommitButton_withTransactionsCounterEqualToZero_shouldSetShowingCommitErrorAlertToTrueAndCommitTransactionMethodShouldNotBeCalled() {
        XCTAssertEqual(homeViewModel.transactionsCounter, 0)

        homeViewModel.didTapCommitButton()
        XCTAssertTrue(homeViewModel.showingCommitErrorAlert)
        XCTAssertEqual(mockedTransactionsRepository.commitTransactionCalledCount, 0)
    }

    @MainActor
    func test_didTapCommitButton_withTransactionsCounterGreaterThanZero_shouldCallCommitTransactionMethodAndDecrementTransactionsCounter() {
        homeViewModel.didTapBeginButton()
        XCTAssertEqual(homeViewModel.transactionsCounter, 1)

        homeViewModel.didTapCommitButton()
        XCTAssertFalse(homeViewModel.showingCommitErrorAlert)
        XCTAssertEqual(mockedTransactionsRepository.commitTransactionCalledCount, 1)
        XCTAssertEqual(homeViewModel.transactionsCounter, 0)
    }

    @MainActor
    func test_didTapRollbackButton_withTransactionsCounterEqualToZero_shouldSetShowingRollbackErrorAlertToTrueAndRollbackMethodShouldNotBeCalled() {
        XCTAssertEqual(homeViewModel.transactionsCounter, 0)

        homeViewModel.didTapRollbackButton()
        XCTAssertTrue(homeViewModel.showingRollbackErrorAlert)
        XCTAssertEqual(mockedTransactionsRepository.rollbackCalledCount, 0)
    }

    @MainActor
    func test_didTapRollbackButton_withTransactionsCounterGreaterThanZero_shouldCallRollbackMethodAndDecrementTransactionsCounter() {
        homeViewModel.didTapBeginButton()
        XCTAssertEqual(homeViewModel.transactionsCounter, 1)

        homeViewModel.didTapRollbackButton()
        XCTAssertFalse(homeViewModel.showingRollbackErrorAlert)
        XCTAssertEqual(mockedTransactionsRepository.rollbackCalledCount, 1)
        XCTAssertEqual(homeViewModel.transactionsCounter, 0)
    }

    @MainActor
    func test_resetValues_shouldSetEmptyStringToGetValueAndZeroToCountValue() {
        homeViewModel.didTapGetButton(with: "test")
        homeViewModel.didTapCountButton(for: "123")
        XCTAssertEqual(homeViewModel.getValue, "value")
        XCTAssertEqual(homeViewModel.countValue, 3)

        homeViewModel.resetValues()
        XCTAssertEqual(homeViewModel.getValue, "")
        XCTAssertEqual(homeViewModel.countValue, 0)
    }
}

final class MockedTransactionsRepository: TransactionalStoreProtocol {

    // MARK: Properties

    var getCalledCount = 0
    var setCalledCount = 0
    var countCalledCount = 0
    var deleteCalledCount = 0
    var startTransactionCalledCount = 0
    var commitTransactionCalledCount = 0
    var rollbackCalledCount = 0

    // MARK: Methods

    func get(_ key: String) -> String? {
        getCalledCount += 1
        return "value"
    }

    func set(key: String, value: String, transactionsCounter: Int) {
        setCalledCount += 1
    }

    func count(for value: String) -> Int {
        countCalledCount += 1
        return 3
    }

    func delete(_ key: String, transactionsCounter: Int) {
        deleteCalledCount += 1
    }

    func startTransaction() {
        startTransactionCalledCount += 1
    }

    func commitTransaction(_ transactionsCounter: Int) {
        commitTransactionCalledCount += 1
    }

    func rollback() {
        rollbackCalledCount += 1
    }
}
