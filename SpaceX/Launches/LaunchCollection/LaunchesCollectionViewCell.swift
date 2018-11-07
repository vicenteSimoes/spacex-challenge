//
//  LaunchesCollectionViewCell.swift
//  SpaceX
//
//  Created by Vicente Simões on 31/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class LaunchesCollectionViewCell: UICollectionViewCell {
    
    var launch: Launch? = nil
    let launchView = LaunchView(launch: _launch, asSmallCard: true)
    weak var delegate: LaunchesViewController?
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainStack)
        mainStack.addArrangedSubview(launchView)
        NSLayoutConstraint.activate([
            mainStack.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLaunch(launch: Launch) {
        self.launch = launch
        self.launch!.date = Date(timeIntervalSince1970: launch.launch_date_unix)
        DispatchQueue.main.async {
            self.launchView.updateValues(forLaunch: self.launch!)
        }
    }
    
    func resetValues() {
        self.launchView.resetValues()
    }
}

extension LaunchesCollectionViewCell {
    func setDelegate(delegate: LaunchesViewController) {
        self.delegate = delegate
        self.launchView.setDelegate(delegate: delegate)
    }
}
