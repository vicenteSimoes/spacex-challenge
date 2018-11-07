//
//  extensions.swift
//  SpaceX
//
//  Created by Vicente Simões on 05/11/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import Foundation
import UIKit


// TODO: Is there a way to refactor this?

extension SingleColumnTableViewCell {
    func setDelegate(delegate: LaunchesViewController) {
        self.delegate = delegate
        if let launchView = self.launchView, let delegate = self.delegate {
            launchView.setDelegate(delegate: delegate)
        }
    }
    
    func setTitle(title: String) {
        cellTitle.text = title
    }
}

extension CollectionViewTableViewCell {
    func setDelegate(delegate: LaunchesViewController) {
        self.delegate = delegate
    }
    
    func setTitle(title: String) {
        cellTitle.text = title
    }
}
