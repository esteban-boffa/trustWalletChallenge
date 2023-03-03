//
//  TransactionsRepository.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import Foundation

final class TransactionsRepository: TransactionalStoreProtocol {

    enum Command {
        case set(key: String, value: String, isNewKey: Bool)
        case delete(key: String)
    }

    // MARK: Private Properties

    private(set) var dictionary: [String: String] = [:]

    // temporaryDictionary will be used when transactions are being processed. It should always be updated with the latest command executed.
    private(set) var temporaryDictionary: [String: String] = [:]
    private(set) var queues: [[Command]] = []

    // MARK: Init

    init() {}
}

// MARK: Public methods - Commands

extension TransactionsRepository {
    func get(_ key: String) -> String? {
        temporaryDictionary.isEmpty ? dictionary[key] : temporaryDictionary[key]
    }

    func set(key: String, value: String, transactionsCounter: Int) {
        if transactionsCounter == 0 {
            dictionary[key] = value
        } else {
            var isNewKey = temporaryDictionary[key] == nil
            temporaryDictionary[key] = value
            // Add command to the queue
            guard var queue = queues.last else { return }
            queue.append(.set(key: key, value: value, isNewKey: isNewKey))
            queues.removeLast()
            queues.append(queue)
        }
    }

    func count(for value: String) -> Int {
        if temporaryDictionary.isEmpty {
            return dictionary.filter { $0.value == value }.count
        } else {
            return temporaryDictionary.filter { $0.value == value }.count
        }
    }

    func delete(_ key: String, transactionsCounter: Int) {
        if transactionsCounter == 0 {
            dictionary.removeValue(forKey: key)
        } else {
            temporaryDictionary.removeValue(forKey: key)
            // Add command to the queue
            guard var queue = queues.last else { return }
            queue.append(.delete(key: key))
            queues.removeLast()
            queues.append(queue)
        }
    }
}

// MARK: Public methods - Operations

extension TransactionsRepository {
    func startTransaction() {
        if temporaryDictionary.isEmpty {
            temporaryDictionary = dictionary
        }
        queues.append([])
    }

    func commitTransaction(_ transactionsCounter: Int) {
        guard let queue = queues.last else { return }
        // Update temporaryDictionary with queued commands
        for command in queue {
            switch command {
            case .set(let key, let value, _):
                temporaryDictionary[key] = value
            case .delete(let key):
                temporaryDictionary.removeValue(forKey: key)
            }
        }
        queues.removeLast()
        if transactionsCounter == 1 {
            // If we are commiting the only existing transaction we just update the original dictionary with the temporaryDictionary
            dictionary = temporaryDictionary
            temporaryDictionary.removeAll()
        }
        printCommandsToCommit(transactionsCounter)
    }

    func rollback() {
        let lastQueue = queues.removeLast()
        guard let queue = queues.last else {
            // If we are doing roll back of the only existing transaction we just remove all elements from
            // temporaryDictionary and start using again the original dictionary
            temporaryDictionary.removeAll()
            return
        }
        // Update temporaryDictionary with queued commands of previous transaction
        for command in queue {
            switch command {
            case .set(let key, let value, _):
                temporaryDictionary[key] = value
            case .delete(let key):
                temporaryDictionary.removeValue(forKey: key)
            }
        }

        // Remove NEW keys that were added to the temporaryDictionary in the transaction that was reverted
        var keysToRemove: [String] = []
        for command in lastQueue {
            switch command {
            case .set(let key, _, let isNewKey):
                if isNewKey {
                    keysToRemove.append(key)
                }
            default:
                break
            }
        }
        keysToRemove.forEach { temporaryDictionary.removeValue(forKey: $0) }
    }
}

// MARK: Private methods

private extension TransactionsRepository {
    func printCommandsToCommit(_ transactionsCounter: Int) {
        guard transactionsCounter > 1 else {
            print("***No more transactions")
            return
        }
        print("***Commands to commit in current transacton \(transactionsCounter - 1):\n")
        guard let lastQueue = queues.last else { return }
        for command in lastQueue {
            print("***\(command)")
        }
    }
}
