//
//  HomeViewModel.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {}

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: Constants

    struct Constants {
        static let getButtonTitle = "Get"
        static let setButtonTitle = "Set"
        static let countButtonTitle = "Count"
        static let deleteButtonTitle = "Delete"
        static let beginButtonTitle = "Begin"
        static let commitButtonTitle = "Commit"
        static let rollbackButtonTitle = "Rollback"
        static let okTitle = "Ok"
        static let keyTitle = "Key"
        static let valueTitle = "Value"
        static let outputTitle = "Output"
        static let noAlertTitle = "No"
        static let yesAlertTitle = "Yes"
        static let commandsTitle = "COMMANDS"
        static let operationsTitle = "OPERATIONS"
        static let deleteAlertMessageConfirmation = "Do you want to delete this value?"
        static let commitAlertMessageConfirmation = "Do you want to commit this transaction?"
        static let rollbackAlertMessageConfirmation = "Do you want to roll back the last transaction?"
        static let commitAlertMessage = "You should first start a transaction before commiting"
        static let rollbackAlertMessage = "You should first start a transaction before doing roll back"
        static let emptyValueAlertMessage = "Please enter a value for executing this command"
        static let processingText = "Processing"
        static let transactionsText = "transactions"
        static let keyNotFound = "key not set"
    }

    // MARK: Private Properties

    @Published private(set) var getValue = ""
    @Published private(set) var countValue = 0
    @Published private(set) var transactionsCounter = 0
    private let repository: TransactionalStoreProtocol

    // MARK: Properties

    @Published var showingCommitErrorAlert = false
    @Published var showingRollbackErrorAlert = false
    weak var delegate: HomeViewModelDelegate?

    // MARK: Init

    init(repository: TransactionalStoreProtocol = TransactionsRepository()) {
        self.repository = repository
    }
}

// MARK: User actions - Commands

extension HomeViewModel {
    func didTapGetButton(with key: String) {
        let value = repository.get(key)
        getValue = value ?? Constants.keyNotFound
    }

    func didTapSetButton(key: String, value: String) {
        repository.set(key: key, value: value, transactionsCounter: transactionsCounter)
    }

    func didTapCountButton(for value: String) {
        countValue = repository.count(for: value)
    }

    func didTapDeleteButton(for key: String) {
        repository.delete(key, transactionsCounter: transactionsCounter)
    }
}

// MARK: User actions - Operations

extension HomeViewModel {
    func didTapBeginButton() {
        transactionsCounter += 1
        repository.startTransaction()
    }

    func didTapCommitButton() {
        guard transactionsCounter > 0 else {
            showingCommitErrorAlert = true
            return
        }
        repository.commitTransaction(transactionsCounter)
        transactionsCounter -= 1
    }

    func didTapRollbackButton() {
        guard transactionsCounter > 0 else {
            showingRollbackErrorAlert = true
            return
        }
        repository.rollback()
        transactionsCounter -= 1
    }
}

// MARK: Public methods

extension HomeViewModel {
    func resetValues() {
        getValue = ""
        countValue = 0
    }
}
