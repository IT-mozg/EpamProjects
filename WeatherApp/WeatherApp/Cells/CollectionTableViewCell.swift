//
//  WeatherInfoTableViewCell.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var presentation: Presentation!{
        didSet{
            guard let present = presentation else { return }
            collectionView.dataSource = self
            collectionView.delegate = self
            setupComponents(with: present)
            collectionView.reloadData()
        }
    }
    private var weathers: [CurrentWeather]!
    
    private func setupComponents(with presentation: Presentation){
        switch presentation.dataType {
        case .weather(let weathers):
            self.weathers = weathers
        default:
            break
        }
    }

}

extension CollectionTableViewCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionDetailCell", for: indexPath) as! WeatherInfoCollectionViewCell
        cell.setupCell(with: weathers[indexPath.item])
        cell.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        cell.layer.borderWidth = 1.0
        return cell
    }
}

extension CollectionTableViewCell : UICollectionViewDelegate{
    
}
