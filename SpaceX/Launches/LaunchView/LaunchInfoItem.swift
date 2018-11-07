//
//  LaunchInfoItem.swift
//  SpaceX
//
//  Created by Vicente Simões on 31/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class LaunchInfoItem: UIView {
    
    let infoTopicLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = label.getFontColor(for: .small)
        label.font      = label.getFont(for: .small)
        return label
    }()
    
    let infoValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font      = label.getFont(for: .normal)
        label.textColor = label.getFontColor(for: .normal)
        return label
    }()
    
    init(infoTopic: String, infoValue: String? = nil) {
        super.init(frame: CGRect())
        
        infoTopicLabel.text = infoTopic
        infoValueLabel.text = infoValue ?? ""
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis         = .vertical
        stack.alignment    = .fill
        stack.distribution = .fillProportionally
        
        stack.addArrangedSubview(infoTopicLabel)
        stack.addArrangedSubview(infoValueLabel)
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo:      self.topAnchor),
            stack.leadingAnchor.constraint(equalTo:  self.leadingAnchor , constant:  infoItemTextPadding),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -infoItemTextPadding),
            stack.bottomAnchor.constraint(equalTo:   self.bottomAnchor)
        ])
    }

    func setInfoValue(withValue value: String) {
        infoValueLabel.text = value
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
