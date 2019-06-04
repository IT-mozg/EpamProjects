//
//  ContactSwitchTableViewCell.swift
//  ContactsTableView
//
//  Created by Vlad on 5/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactSwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldSwitch: UISwitch!
    
    var updateSwitchClosure:((Bool, ContactSwitchTableViewCell)->())!
    var presentation: Presentation!{
        didSet{
            guard let present = presentation else {
                return
            }
            setupComponents(with: present)
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        updateSwitchClosure(sender.isOn, self)
    }
    
    private func setupComponents(with presentation: Presentation?){
        guard let presentation = presentation else {
            return
        }
        fieldNameLabel.text = presentation.title
    }
}
