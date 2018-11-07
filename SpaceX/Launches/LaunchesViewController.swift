//
//  LaunchesViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class LaunchesViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    
    var futureLaunches: [Launch] = []
    var pastLaunches: [Launch] = []
    
    private func setupNavigationBar() {
        self.navigationItem.title = spaceXLaunchesViewControllerTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        setupNavigationBar()
        setupTable()
        
        self.view.addSubview(tableView)
        
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safe.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}

extension LaunchesViewController : UITableViewDelegate, UITableViewDataSource {
    
    private func setupTable(){
        tableView.register(SingleColumnTableViewCell.self, forCellReuseIdentifier: "latestLaunchCell")
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "multipleLaunchesCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return launchesTableNumberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell: SingleColumnTableViewCell = tableView.dequeueReusableCell(withIdentifier: "latestLaunchCell") as! SingleColumnTableViewCell
            cell.setTitle(title: cellTitles[indexPath.row])
            cell.setDelegate(delegate: self)
            fetch(requestURL: latestUrl) { data in
                guard let data = data else { return }
                let decoder = JSONDecoder()
                var launch = try! decoder.decode(Launch.self, from: data)
                
                launch.date = Date(timeIntervalSince1970: launch.launch_date_unix)
                cell.setLaunch(launch: launch)
            }
            return cell
        }
        else {
            let cell: CollectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "multipleLaunchesCell") as! CollectionViewTableViewCell
            cell.setTitle(title: cellTitles[indexPath.row])
            cell.setDelegate(delegate: self)
            let dataURL = indexPath.row == 1 ? futureUrl : pastUrl
            fetch(requestURL: dataURL) { data in
                guard let data = data else { return }
                let decoder = JSONDecoder()
                let launches = try! decoder.decode([Launch].self, from: data)
                cell.setData(data: launches)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0
            ? launchesTableCellHeight
            : launchesCollectionCellHeight
    }
}

extension UIViewController {
    func presentNewViewController(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
