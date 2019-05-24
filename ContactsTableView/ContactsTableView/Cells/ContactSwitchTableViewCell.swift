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
    @IBOutlet weak var contactPropertyTextField: UITextField!
    
    var updateClosure:((String, ContactSwitchTableViewCell)->())?
    var cellType: CellType!{
        didSet{
            guard let cell = cellType else {
                return
            }
            switch cell {
            case .driverLicenseSwitch(let present):
                setupComponents(with: present)
            default:
                break
            }
        }
    }
    @IBAction func editingChanged(_ sender: UITextField) {
         updateClosure?(sender.text!, self)
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        contactPropertyTextField.isHidden = !fieldSwitch.isOn
        contactPropertyTextField.text = nil
        updateClosure?(contactPropertyTextField.text!, self)
    }
    
    private func setupComponents(with presentation: Presentation?){
        guard let presentation = presentation else {
            return
        }
        fieldNameLabel.text = presentation.title
        contactPropertyTextField.keyboardType = presentation.keyboardType!
        contactPropertyTextField.placeholder = presentation.placeholder
        if let dataType = presentation.dataType{
            switch dataType{
            case .text(let text):
                if text != nil && !text!.isEmpty{
                    fieldSwitch.isOn = true
                    contactPropertyTextField.isHidden = false
                    contactPropertyTextField.text = text
                }
                else{
                    fieldSwitch.isOn = false
                    contactPropertyTextField.isHidden = true
                }
            case .image(_):
                break
            case .date(_):
                break
            case .height(_):
                break
            }
        }
        
    }
    
}
