//
//  LaunchViewController.swift
//  SpaceX
//
//  Created by Vicente Simões on 05/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    var launch: Launch?
    
    init(launch: Launch) {
        super.init(nibName: nil, bundle: nil)
        self.launch = launch
    }
    
    @objc func siteButtonTapped(_ sender: UIBarButtonItem) {
        if let launch = launch {
            self.navigationController?.pushViewController(SiteViewController(siteId: launch.launch_site.site_id), animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Launch #\(launch!.flight_number)"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "site"), style: UIBarButtonItem.Style.done, target: self, action: #selector(siteButtonTapped))
        
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: true)
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        let mainStack = createStackView(translatesAutoResizingMaskIntoConstraints: false, axis: .vertical, alignement: .fill, distribution: .fill, spacing: nil)
        self.view.addSubview(mainStack)
        if let launch = self.launch {
            let launchView = LaunchView(launch: launch)
            launchView.updateValues(forLaunch: launch)
            launchView.setDelegate(delegate: self, shouldRespondToSelf: false)
            mainStack.addArrangedSubview(launchView)
        }
        
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safe.topAnchor),
            mainStack.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            mainStack.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
