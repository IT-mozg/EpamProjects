//
//  Validation.swift
//  ContactsTableView
//
//  Created by Vlad on 5/7/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class Validation{
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidName(_ name: String) -> Bool{
        let name = name.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if !name.isEmpty && name.count <= 20{
            return true
        }
        return false
    }
    
    static func isValidPhoneNumber(_ number: String) -> Bool{
        let regex = "^\\+?3?8?(0[0-9][0-9]\\d{7})$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES[c] %@", regex)
        return phonePredicate.evaluate(with: number)
    }
    
    static func isValidTextField(textField: UITextField, _ validate: ((String)->(Bool)))->Bool{
        if let text = textField.text{
            if validate(text){
                textField.backgroundColor = ContactDefault.validColor
                return true
            }
        }
        textField.backgroundColor = ContactDefault.invalidColor
        return false
    }
}
