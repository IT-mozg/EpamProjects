//
//  Contact.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//
import UIKit
import Foundation

struct Contact{
    var contactId: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var imagePhoto: UIImage?
    
    init(firstName: String, lastName: String, email: String, phoneNumber: String, imagePhoto: UIImage?){
        contactId = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.imagePhoto = imagePhoto
    }
}
