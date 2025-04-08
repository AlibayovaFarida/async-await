//
//  ViewController.swift
//  Test
//
//  Created by Apple on 08.04.25.
//

import UIKit

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

// Second method
class ViewController: UIViewController {

    func result() async {
        let servers = ["primary", "secondary", "development"]
        let usersList = await withTaskGroup(of: UserInfo.self) { group in
            for server in servers {
                group.addTask {
                    async let userId = fetchUserID(from: server)
                    async let username = fetchUsername(from: server)
                    async let userStatus = fetchUserStatus(from: server)
                    
                    return UserInfo(server: server, userID: await userId, username: await username, status: await userStatus)
                }
            }
            
            var results: [UserInfo] = []
            
            for await result in group {
                results.append(result)
            }
            
            return results
        }
        
        print(usersList)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await result()
        }
    }
}

// First method

//class ViewController: UIViewController {
//    func result() async {
//        var usersList: [UserInfo] = []
//        let userIDS = await withTaskGroup(of: Int.self) { group in
//            for server in ["primary", "secondary", "development"] {
//                group.addTask {
//                    await fetchUserID(from: server)
//                }
//            }
//            var results: [Int] = []
//            for await result in group {
//                results.append(result)
//            }
//            return results
//        }
//        let usernames = await withTaskGroup(of: String.self) { group in
//            for server in ["primary", "secondary", "development"] {
//                group.addTask {
//                    await fetchUsername(from: server)
//                }
//            }
//            var results: [String] = []
//            for await result in group {
//                results.append(result)
//            }
//            return results
//        }
//        let userStatuses = await withTaskGroup(of: String.self) { group in
//            for server in ["primary", "secondary", "development"] {
//                group.addTask {
//                    await fetchUserStatus(from: server)
//                }
//            }
//
//            var results: [String] = []
//            for await result in group {
//                results.append(result)
//            }
//            return results
//        }
//        for (index, value) in ["primary", "secondary", "development"].enumerated(){
//            usersList.append(.init(server: value, userID: userIDS[index], username: usernames[index], status: userStatuses[index]))
//        }
//
//        print(usersList)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Task {
//            await result()
//        }
//    }
//}
