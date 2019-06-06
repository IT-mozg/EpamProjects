//
//  TitleTableViewCell.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var presentation: Presentation!{
        didSet{
            guard let present = presentation else { return }
            setupComponents(with: present)
        }
    }
    
    private func setupComponents(with presentation: Presentation){
        switch presentation.dataType {
        case .text(let text):
            titleLabel.text = text
        default:
            break
        }
    }
}
