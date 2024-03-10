//
//  FilterViewController.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import UIKit

class FilterViewController: UIViewController {
    
    public var completion: ((StateData) -> Void)?
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var states: [StateData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select State"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, 
            target: self,
            action: #selector(didTapClose)
        )
        
        fetchAllStates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func fetchAllStates() {
        NetworkManager.shared.getAllStates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let states):
                self.states = states.data ?? []
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let state = states[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = state.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let state = states[indexPath.row]
        
        // call completion back to view controller
        completion?(state)
        // dismiss
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate {
    
}
