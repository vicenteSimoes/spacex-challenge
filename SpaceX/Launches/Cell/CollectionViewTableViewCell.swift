//
//  CollectionViewCell.swift
//  SpaceX
//
//  Created by Vicente Simões on 30/10/2018.
//  Copyright © 2018 Vicente Simões. All rights reserved.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    var fetchUrl: String = ""
    var launches: [Launch] = []
    weak var delegate: LaunchesViewController?

    let mainStack: UIStackView = createStackView(axis: .vertical, alignement: .fill, distribution: .fill, spacing: nil)
    
    let cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Helvetica", size: 22.5)
        label.textColor = appThemeColor
        label.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(mainStack)
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleView.addSubview(cellTitle)
        
        cellTitle.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10).isActive = true
        mainStack.addArrangedSubview(titleView)
        
        setupCollectionView()
        
        mainStack.addArrangedSubview(collectionView)
        autoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 300, height: launchesCollectionCellHeight - 45)
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LaunchesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setData(data: [Launch]) {
        self.launches = data
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: launchesCellPadding),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: cellTitle.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor)
        ])
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return launches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LaunchesCollectionViewCell
        cell.resetValues()
        cell.setLaunch(launch: launches[indexPath.row])
        if let delegate = delegate {
            cell.setDelegate(delegate: delegate)
        }
        return cell
    }
}
