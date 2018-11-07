//
//  SiteViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 07/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class SiteViewController: UIViewController {
    var siteId: String? = nil
    
    let mainStack: UIStackView = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .vertical, alignement: .fill, distribution: .fill, spacing: nil)
    
    var mainView: SiteView? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "Launch Site"
        self.mainView = SiteView()
        fetchAndPopulate()
    }
    
    convenience init(siteId: String) {
        self.init(nibName: nil, bundle: nil)
        self.siteId = siteId
        self.view.addSubview(mainStack)
        
        let safeView = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: safeView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: safeView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: safeView.bottomAnchor)
        ])
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchAndPopulate() {
        if let id = siteId {
            let requestURL = "https://api.spacexdata.com/v3/launchpads/\(id)"
            fetch(requestURL: requestURL) { data in
                let decoder = JSONDecoder()
                print(requestURL)
                let site = try! decoder.decode(Site.self, from: data!)
                self.mainView!.setUp(withSite: site)
                DispatchQueue.main.async {
                    self.mainStack.addArrangedSubview(self.mainView!)
                }
            }
        }
    }
}

struct Site: Codable {
    let id: Int
    let status: String
    let location: Location
    let vehiclesLaunched: [String]
    let attemptedLaunches, successfulLaunches: Int
    let wikipedia: String
    let details, siteID, siteNameLong: String
    
    enum CodingKeys: String, CodingKey {
        case id, status, location
        case vehiclesLaunched = "vehicles_launched"
        case attemptedLaunches = "attempted_launches"
        case successfulLaunches = "successful_launches"
        case wikipedia, details
        case siteID = "site_id"
        case siteNameLong = "site_name_long"
    }
}

struct Location: Codable {
    let name, region: String
    let latitude, longitude: Double
}
