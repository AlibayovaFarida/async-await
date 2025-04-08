//
//  Helpers.swift
//  Test
//
//  Created by Apple on 08.04.25.
//

import Foundation


struct UserInfo {
    let server: String
    let userID: Int
    let username: String
    let status: String
}

func fetchUserID(from server: String) async -> Int {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...2_000_000_000))
    return Int.random(in: 100...999)
}

func fetchUsername(from server: String) async -> String {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...2_000_000_000))
    return ["Alice", "Bob", "Charlie"].randomElement()!
}

func fetchUserStatus(from server: String) async -> String {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...2_000_000_000))
    return ["Online", "Offline", "Busy"].randomElement()!
}
