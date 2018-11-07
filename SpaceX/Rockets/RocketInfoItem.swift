//
//  RocketInfoItem.swift
//  SpaceX
//
//  Created by Vicente Simões on 06/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit


class RocketInfoItem: UITableViewCell {
    var infoValue: Any? = nil

    let itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.getFont(for: .small)
        label.textColor = label.getFontColor(for: .small)
        return label
    }()
    
    let itemValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.getFont(for: .normal)
        label.textColor = label.getFontColor(for: .normal)
        label.numberOfLines = 0 // infinite number of lines
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(itemLabel)
        self.addSubview(itemValue)
        
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            itemLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            itemLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            itemLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            itemLabel.heightAnchor.constraint(equalToConstant: 20),
            
            itemValue.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5),
            itemValue.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            itemValue.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            itemValue.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RocketInfoItem {
    func setData(data: RocketCellData) {
        if let engines = data.value as? Engines {
            self.itemLabel.text = data.key
            var values: [String : Any] = [:]
            values["Number of Engines"] = engines.number
            values["Layout"] = engines.layout
            values["Max Engine Losses"] = engines.engineLossMax
            values["Thrust to Weight Ratio"] = engines.thrustToWeight
            
            let final_value = values.reduce("") { "\($0) \($1.key) : \( $1.value )\n" }
            
            self.itemValue.text = final_value
            return
        }
        if let dataValue = data.value as? [String : String] {
            self.itemLabel.text = data.key
            let finalValue = dataValue.reduce("") {
                return $0 + $1.key + " : " + $1.value + "\n" }
            self.itemValue.text = finalValue
            return
        }
        self.itemLabel.text = data.key
        self.itemValue.text = data.value as? String
    }
}
