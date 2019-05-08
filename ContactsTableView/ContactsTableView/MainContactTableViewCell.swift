//
//  MainContactTableViewCell.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class MainContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    func updateWith(model: Contact){
        firstNameLabel.text = model.firstName
        lastNameLabel.text = model.lastName
        contactImage?.image = model.imagePhoto
    }

}
