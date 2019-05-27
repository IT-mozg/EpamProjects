//
//  ContactImageTableViewCell.swift
//  ContactsTableView
//
//  Created by Vlad on 5/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactImageTableViewCell: UITableViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    var presentation: Presentation!{
        didSet{
            guard let present = presentation else {
                return
            }
            setupComponents(with: present)
        }
    }
    
    private func setupComponents(with presentation: Presentation?){
        guard let presentation = presentation else {
            return
        }
        if let dataType = presentation.dataType{
            switch dataType{
                case .text(_):
                    break
                case .image(let image):
                    contactImage.image = image ?? ContactDefault.defaultCameraImage
                    contactImage.contentMode = (image == nil) ? .scaleAspectFit : .scaleAspectFill
                    contactImage.clipsToBounds = true
                case .date(_):
                    break
                case .height(_):
                    break
            }
        }
    }
}
