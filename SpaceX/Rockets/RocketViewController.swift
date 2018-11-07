//
//  RocketViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 05/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

struct RocketCellData {
    let key: String
    let value: Any?
}

class RocketViewController: UIViewController {

    var rocket: RocketObj?
    var expandedHeight: CGFloat { get { return 100 } }
    var contractedHeight: CGFloat { get { return 50 } }
    var data: [RocketCellData] = []
    
    init(withRocketId id: String) {
        super.init(nibName: nil, bundle: nil)
        self.fetchRocket(by: id)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar(title: String) {
        self.navigationItem.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func setupRocketView(for rocket: RocketObj) {
        self.setupNavigationBar(title: rocket.rocketName)
        let rocketTableView = UITableView()
        rocketTableView.translatesAutoresizingMaskIntoConstraints = false
        rocketTableView.delegate = self
        rocketTableView.dataSource = self
        rocketTableView.register(RocketInfoItem.self, forCellReuseIdentifier: "cell")
        rocketTableView.rowHeight = UITableView.automaticDimension
        rocketTableView.estimatedRowHeight = 140
        rocketTableView.separatorStyle = .none
        self.view.addSubview(rocketTableView)
        
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            rocketTableView.topAnchor.constraint(equalTo: safe.topAnchor),
            rocketTableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            rocketTableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            rocketTableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
        self.rocket = rocket
        self.prepareData()
    }
    
    func prepareData() {
        if let rocket = rocket {
            data.append(RocketCellData(key: "Type", value: rocket.rocketType))
            data.append(RocketCellData(key: "Is Active", value: rocket.active ? "Yes" : "No"))
            data.append(RocketCellData(key: "Dimensions", value: rocket.dimensions))
            data.append(RocketCellData(key: "# of Stages", value: String(rocket.stages)))
            data.append(RocketCellData(key: "Engines", value: rocket.engines))
            data.append(RocketCellData(key: "Description", value: rocket.description))
        }
    }
    
    func fetchRocket(by rocketId: String) {
        fetch(requestURL: "https://api.spacexdata.com/v3/rockets/\(rocketId)") { rocketData in
            let decoder = JSONDecoder()
            var rocket = try! decoder.decode(RocketObj.self, from: rocketData!)
            rocket.dimensions["Height"] = String(rocket.height.meters) + "m"
            rocket.dimensions["Diameter"] = String(rocket.diameter.meters) + "m"
            rocket.dimensions["Mass"] = String(rocket.mass.kg) + "kg"
            DispatchQueue.main.async {
                self.setupRocketView(for: rocket)
            }
        }
    }
}

extension RocketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RocketInfoItem
        let cellData = data[indexPath.row]
        cell.setData(data: cellData)
        return cell
    }
}
