//
//  TransactionsRepository.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 28/02/2023.
//

import Foundation

final class TransactionsRepository {

    enum Command {
        case set(key: String, value: String)
        case delete(key: String)
    }

    // MARK: Private Properties

    private var dictionary: [String: String] = [:]

    // temporaryDictionary will be used when transactions are being processed. It should always be updated with the latest command executed.
    private var temporaryDictionary: [String: String] = [:]
    private var queues: [[Command]] = []

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
            temporaryDictionary[key] = value
            // Add command to the queue
            guard var queue = queues.last else { return }
            queue.append(.set(key: key, value: value))
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
            case .set(let key, let value):
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
        queues.removeLast()
        guard let queue = queues.last else {
            // If we are doing roll back of the only existing transaction we just remove all elements from
            // temporaryDictionary and start using again the original dictionary
            temporaryDictionary.removeAll()
            return
        }
        // Update temporaryDictionary with queued commands of previous transaction
        for command in queue {
            switch command {
            case .set(let key, let value):
                temporaryDictionary[key] = value
            case .delete(let key):
                temporaryDictionary.removeValue(forKey: key)
            }
        }
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
