//
//  ViewController.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 06/03/2024.
//

import UIKit
import DGCharts

// Data of covid cases
class ViewController: UIViewController {
    
    // Default scope
    private var scope: StateScope = .national
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var covidData: [CovidData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.createGraph()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Covid Cases"
        
        configureTable()
        createFilterButton()
    }
    
    private func configureTable() {
        view.addSubview(tableView)
        tableView.dataSource = self
    }
    
    private func createGraph() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.clipsToBounds = true
        
        let set = covidData.prefix(20)
        
        var entries: [BarChartDataEntry] = []
        for index in 0..<set.count {
            let data = set[index]
            entries.append(.init(x: Double(index), y: Double(data.cases?.total ?? 0)))
        }
        
        let dataSet = BarChartDataSet(
            entries: entries
        )
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data: BarChartData = BarChartData(dataSet: dataSet)
        
        let chart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        chart.data = data
        
        headerView.addSubview(chart)
        
        tableView.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchCovidDataByState() {
        NetworkManager.shared.getCovidDataOfState(for: scope) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let covidData):
                self.covidData = covidData.data ?? []
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createFilterButton() {
        let buttonTitle: String = {
            switch scope {
            case .national: return "National"
            case .state(let state): return state.name ?? "National"
            }
        }()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: buttonTitle,
            style: .done,
            target: self,
            action: #selector(didTapFilter)
        )
    }
    
    @objc private func didTapFilter() {
        let vc = FilterViewController()
        
        vc.completion = { [weak self] state in
            guard let self = self else { return }
            
            self.scope = .state(state)
            
            self.createFilterButton()
            
            self.fetchCovidDataByState()
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covidData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let covidData = covidData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = createText(with: covidData)
        
        return cell
    }
    
    private func createText(with data: CovidData) -> String? {
        if let date = DateFormatter.dayFormatter.date(from: data.date!) {
            let dateString = DateFormatter.prettyFormatter.string(from: date)
            if let totalCases = data.cases?.total {
                if let total = NumberFormatter.prettyFormatter.string(from: NSNumber(value: totalCases)) {
                    return "\(dateString): \(total) Cases"
                } else {
                    return nil
                }
            } else {
                return "\(dateString): 0 Case"
            }
        } else {
            return nil
        }
    }
}

