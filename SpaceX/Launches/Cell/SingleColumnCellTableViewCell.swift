//
//  SingleColumnTableViewCell.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class SingleColumnTableViewCell: UITableViewCell {
    
    var launch: Launch = _launch
    var launchView: LaunchView? = nil
    weak var delegate: LaunchesViewController?

    let mainStack: UIStackView = createStackView(axis: .vertical, alignement: .fill, distribution: .fillProportionally, spacing: nil)
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Helvetica", size: 22.5)
        label.textColor = appThemeColor
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return label
    }()
    
    func setLaunch(launch: Launch) {
        self.launch = launch
        if let launchView = launchView {
            launchView.updateValues(forLaunch: launch)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(mainStack)
        
        launchView = LaunchView(launch: launch)
        
        // setup title for this launch view
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleView.addSubview(cellTitle)
    
        cellTitle.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10).isActive = true
        
        mainStack.addArrangedSubview(titleView)
        mainStack.addArrangedSubview(launchView!)
        
        autoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: launchesCellPadding),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // it is safe to force unwrap
            launchView!.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            launchView!.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
    }
}
