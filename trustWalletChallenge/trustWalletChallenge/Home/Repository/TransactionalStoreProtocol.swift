//
//  TransactionalStoreProtocol.swift
//  trustWalletChallenge
//
//  Created by Esteban Boffa on 02/03/2023.
//

import Foundation

protocol TransactionalStoreProtocol: AnyObject {

    /// Returns the current value for key
    ///
    /// - Parameters:
    /// - key: The key to get the value
    /// - Returns: The current value for received key
    func get(_ key: String) -> String?

    /// Stores the value for key
    ///
    /// - Parameters:
    /// - key: The key to set the value
    /// - value: The current value to be stored
    /// - transactionsCounter: The current transaction number
    func set(key: String, value: String, transactionsCounter: Int)

    /// Returns the number of keys that have the given value
    ///
    /// - Parameters:
    /// - value: The value to get the number of keys
    /// - Returns: The number of keys that have the given value
    func count(for value: String) -> Int

    /// Removes the entry for key
    ///
    /// - Parameters:
    /// - key: The key to be removed
    /// - transactionsCounter: The current transaction number
    func delete(_ key: String, transactionsCounter: Int)

    /// Starts a new transaction
    func startTransaction()

    /// Completes the current transaction
    ///
    /// - Parameters:
    /// - transactionsCounter: The current transaction number
    func commitTransaction(_ transactionsCounter: Int)

    /// Revert to state prior to BEGIN/START call
    func rollback()
}
