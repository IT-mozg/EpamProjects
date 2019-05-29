//
//  Contact.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//
import UIKit
import Foundation

class Contact: NSObject, NSCoding{
    private(set) var contactId: String
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var imagePhoto: UIImage?
    
    private var imageName: String{
        return "image-\(contactId)"
    }
    
    var contactName: String{
        if firstName != nil && !firstName!.isEmpty{
            return firstName!
        }
        if lastName != nil && !lastName!.isEmpty{
            return lastName!
        }
        return "~"
    }
    
    init(firstName: String?, lastName: String?, email: String?, phoneNumber: String?){
        contactId = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    convenience init(id: String, firstName: String?, lastName: String?, email: String?, phoneNumber: String?){
        self.init(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        contactId = id
        self.imagePhoto = DataManager.getImage(with: imageName, and: ContactDefault.imageExtension)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "contactId") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        
        self.init(id: id, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        self.imagePhoto = DataManager.getImage(with: imageName, and: ContactDefault.imageExtension)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactId, forKey: "contactId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
    }
    
    func saveImage(){
        DataManager.saveImage(image: imagePhoto, with: imageName, and: ContactDefault.imageExtension)
    }
    
    func deleteImage(){
        DataManager.deleteImage(with: imageName, and: ContactDefault.imageExtension)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if object is Contact{
            let contact = object as! Contact
            return self.firstName == contact.firstName && self.lastName == contact.lastName && self.phoneNumber == contact.phoneNumber && self.email == contact.email
        }
        return false
    }
}

extension Contact : NSCopying{
    func copy(with zone: NSZone? = nil) -> Any{
        let copyContact = Contact(id: contactId, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        copyContact.imagePhoto = DataManager.getImage(with: imageName, and: ContactDefault.imageExtension)
        return copyContact
    }
}
