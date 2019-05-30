//
//  ContactFieldTableViewCell.swift
//  ContactsTableView
//
//  Created by Vlad on 5/29/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var contactPropertyTextField: UITextField!
    
    var updateClosure:((Any?, ContactFieldTableViewCell)->())?
    
    private var meter = 0
    private var decimeter = 0
    private var santimeter = 0
    
    private let heightMeter = [[0,1,2,3], [0,1,2,3,4,5,6,7,8,9]]
    
    private var datePicker: UIDatePicker!
    private var heightPickerView: UIPickerView!
    
    var presentation: Presentation! {
        didSet{
            guard let present = presentation else{
                return
            }
            setupComponents(with: present)
        }
    }
    @IBAction func editingChanged(_ sender: UITextField) {
        if let dataType = presentation.dataType{
            switch dataType{
            case .text:
                updateClosure?(sender.text!, self)
                presentation.updateDataType(.text(sender.text))
            case .date:
                presentation.updateDataType(.date(datePicker!.date))
            case .height:
                let height = Int(sender.text!)
                presentation.updateDataType(.height(height))
            case .image(_):
                break
            }
        }
    }
}

//MARK: Private funcs
private extension ContactFieldTableViewCell{
    func setupComponents(with presentation: Presentation?){
        guard let presentation = presentation else {
            return
        }
        contactPropertyTextField.delegate = self
        fieldNameLabel.text = presentation.title
        contactPropertyTextField.keyboardType = presentation.keyboardType!
        contactPropertyTextField.placeholder = presentation.placeholder
        switch presentation.cellType {
        case .notes:
            contactPropertyTextField.isEnabled = false
        default:
            break
        }
        setupDataType(presentation: presentation)
    }
    
    func setupDataType(presentation: Presentation){
        if let dataType = presentation.dataType{
            switch dataType{
            case .text(let text):
                contactPropertyTextField.text = text
            case .date(let date):
                setupDatePicker()
                contactPropertyTextField.textAlignment = .center
                if let date = date{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = ContactDefault.dateFormat
                    contactPropertyTextField.text = dateFormatter.string(from: date)
                    datePicker.date = date
                }
            case .height(let height):
                
                contactPropertyTextField.textAlignment = .center
                setupHeightPicker()
                if var height = height{
                    if height == 0 {
                        contactPropertyTextField.text = ""
                    }else{
                        contactPropertyTextField.text = String(height)
                    }
                    heightPickerView.selectRow(height % 10, inComponent: 2, animated: false)
                    height /= 10
                    heightPickerView.selectRow(height % 10, inComponent: 1, animated: false)
                    heightPickerView.selectRow(height/10, inComponent: 0, animated: false)
                }
            case .image(_):
                break
            }
        }
    }
    
    func setupHeightPicker(){
        createToolbar()
        heightPickerView = UIPickerView()
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        contactPropertyTextField.inputView = heightPickerView
    }
    
    func setupDatePicker(){
        createToolbar()
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = ContactDefault.maxBirthDate
        datePicker.minimumDate = ContactDefault.minBirthDate
        contactPropertyTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(changeDate(datePicker:)), for: .valueChanged)
    }
    
    func createToolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBotton = UIBarButtonItem(title: NSLocalizedString("DONE_BUTTON_TEXT", comment: "Done"), style: .done, target: self, action: #selector(doneToolbarButtonPressed))
        toolbar.setItems([doneBotton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        contactPropertyTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneToolbarButtonPressed(){
        contactPropertyTextField.resignFirstResponder()
    }
    
    @objc func changeDate(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ContactDefault.dateFormat
        contactPropertyTextField.text = dateFormatter.string(from: datePicker.date)
        updateClosure?(datePicker.date, self)
    }
}

extension ContactFieldTableViewCell: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return heightMeter.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return heightMeter[component - 1].count
        }
        return heightMeter[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 2 {
            return String(heightMeter[component - 1][row])
        }
        return String(heightMeter[component][row])
    }
}

extension ContactFieldTableViewCell: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            meter = heightMeter[component][row]
        case 1:
            decimeter = heightMeter[component][row]
        case 2:
            santimeter = heightMeter[component-1][row]
        default:
            break
        }
        contactPropertyTextField.text = "\(meter)\(decimeter)\(santimeter)"
        updateClosure?(Int(contactPropertyTextField.text!) ?? 0, self)
    }
}

//MARK: TextFieldDelegate
extension ContactFieldTableViewCell: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.endEditing(true)
//    }
}
