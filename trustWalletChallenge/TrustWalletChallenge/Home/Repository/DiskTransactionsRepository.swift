//
//  DiskTransactionsRepository.swift
//  TrustWalletChallenge
//
//  Created by Esteban Boffa on 03/03/2023.
//

import Foundation

// Implementation for saving data to disk
final class DiskTransactionsRepository: TransactionalStoreProtocol {

    func get(_ key: String) -> String? {
        // get implementation
        return ""
    }

    func set(key: String, value: String, transactionsCounter: Int) {
        // set implementation
    }

    func count(for value: String) -> Int {
        // count implementation
        return 0
    }

    func delete(_ key: String, transactionsCounter: Int) {
        // delete implementation
    }

    func startTransaction() {
        // startTransaction implementation
    }

    func commitTransaction(_ transactionsCounter: Int) {
        // commitTransaction implementation
    }

    func rollback() {
        // rollback implementation
    }
}
