//
//  AnotherViewController.swift
//  Test
//
//  Created by Apple on 08.04.25.
//

import UIKit


actor ServerConnection {
    var server: String = "primary"
    private var activeUsers: [Int] = []

    func connect() async -> Int {
        let userID = await fetchUserID(from: server)
        activeUsers.append(userID)
        return userID
    }

    func disconnect(userID: Int) {
        activeUsers.removeAll { $0 == userID }
    }

    func getActiveUsers() -> [Int] {
        return activeUsers
    }
}


class AnotherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let connection = ServerConnection()
    var users: [Int] = []
    
    let tableView = UITableView()
    let connectButton = UIButton(type: .system)
    let disconnectButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        loadUsers()
    }
    
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        disconnectButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(connectButton)
        view.addSubview(disconnectButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        connectButton.setTitle("Connect User", for: .normal)
        disconnectButton.setTitle("Disconnect Selected", for: .normal)
        
        connectButton.addTarget(self, action: #selector(connectUser), for: .touchUpInside)
        disconnectButton.addTarget(self, action: #selector(disconnectUser), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -20),
            
            connectButton.bottomAnchor.constraint(equalTo: disconnectButton.topAnchor, constant: -10),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            disconnectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func connectUser() {
        Task {
            let userID = await connection.connect()
            users.append(userID)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func disconnectUser() {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        let userID = users[selectedIndexPath.row]
        
        Task {
            await connection.disconnect(userID: userID)
            users.remove(at: selectedIndexPath.row)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadUsers() {
        Task {
            let active = await connection.getActiveUsers()
            users = active
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let userID = users[indexPath.row]
        cell.textLabel?.text = "User ID: \(userID)"
        return cell
    }
}

