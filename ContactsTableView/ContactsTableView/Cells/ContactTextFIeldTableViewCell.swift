//
//  ContactTextFIeldTableViewCell.swift
//  ContactsTableView
//
//  Created by Vlad on 5/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactTextFIeldTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var contactPropertyTextField: UITextField!
    
    var updateClosure:((String, ContactTextFIeldTableViewCell)->())?
    
    private var meter = 0
    private var decimeter = 0
    private var santimeter = 0
    private var datePicker: UIDatePicker!
    
    var cellType: CellType! {
        didSet{
            guard let cell = cellType else{
                return
            }
            switch cell {
                case .firstName (let present):
                    setupComponents(with: present)
                case .lastName(let present):
                    setupComponents(with: present)
                case .email(let present):
                    setupComponents(with: present)
                case .phone(let present):
                    setupComponents(with: present)
                case .birthday(let present):
                    setupComponents(with: present)
                case .height(let present):
                    setupComponents(with: present)
                case .note(let present):
                    setupComponents(with: present)
                default:
                    break
            }
        }
    }
    @IBAction func editingChanged(_ sender: UITextField) {
        updateClosure?(sender.text!, self)
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
                contactPropertyTextField.text = text
            case .date(let date):
                contactPropertyTextField.textAlignment = .center
                if let date = date{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = ContactDefault.dateFormat
                    contactPropertyTextField.text = dateFormatter.string(from: date)
                }
                setupDatePicker()
            case .height(let height):
                contactPropertyTextField.textAlignment = .center
                if let height = height{
                    contactPropertyTextField.text = String(height)
                }
                setupHeightPicker()
            case .image(_):
                break
            }
        }
    }
    
    private func setupHeightPicker(){
        let heightPickerView = UIPickerView()
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        contactPropertyTextField.inputView = heightPickerView
    }
    
    private func setupDatePicker(){
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        contactPropertyTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(changeDate(datePicker:)), for: .valueChanged)
    }
    
    @objc private func changeDate(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        contactPropertyTextField.text = dateFormatter.string(from: datePicker.date)
        updateClosure?(contactPropertyTextField.text!, self)
    }
}

extension ContactTextFIeldTableViewCell: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
}

extension ContactTextFIeldTableViewCell: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
                meter = row
            case 1:
                decimeter = row
            case 2:
                santimeter = row
            default:
                break
        }
        contactPropertyTextField.text = "\(meter)\(decimeter)\(santimeter)"
        updateClosure?(contactPropertyTextField.text!, self)
    }
}
