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
    private var imageExtension: String{
        return "jpg"
    }
    private(set) var contactId: String
    var firstName: String
    var lastName: String?
    var email: String?
    var phoneNumber: String
    var birthday: Date?
    var height: Int?
    var notes: String?
    var driverLicense: String?
    var imagePhoto: UIImage?
    
    private var imageName: String{
        return "image-\(contactId)"
    }
    
    init(firstName: String, lastName: String?, email: String?, phoneNumber: String, birthday: Date?, height: Int?, notes: String?, driverLicense: String?){
        contactId = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        self.height = height
        self.notes = notes
        self.driverLicense = driverLicense
    }
    
    convenience init(id: String, firstName: String, lastName: String?, email: String?, phoneNumber: String, birthday: Date?, height: Int?, notes: String?, driverLicense: String?){
        self.init(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, birthday: birthday, height: height, notes: notes, driverLicense: driverLicense)
        contactId = id
        self.imagePhoto = DataManager.getImage(with: imageName, and: imageExtension)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "contactId") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let birthday = aDecoder.decodeObject(forKey: "birthday") as? Date
        let height = aDecoder.decodeObject(forKey: "height") as? Int
        let notes = aDecoder.decodeObject(forKey: "notes") as? String
        let driverLicense = aDecoder.decodeObject(forKey: "driverLicense") as? String
        
        self.init(id: id, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, birthday: birthday, height: height, notes: notes, driverLicense: driverLicense)
        self.imagePhoto = DataManager.getImage(with: imageName, and: imageExtension)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactId, forKey: "contactId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(height, forKey: "height")
        aCoder.encode(notes, forKey: "notes")
        aCoder.encode(driverLicense, forKey: "driverLicense")
    }
    
    func saveImage(){
        DataManager.saveImage(image: imagePhoto, with: imageName, and: imageExtension)
    }
    
    func deleteImage(){
        DataManager.deleteImage(with: imageName, and: imageExtension)
    }
    
//    static func == (lhs: Contact, rhs: Contact) -> Bool {
//        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.phoneNumber == rhs.phoneNumber && lhs.email == rhs.email && lhs.birthday == rhs.birthday && lhs.height == rhs.height && lhs.notes == rhs.notes && lhs.driverLicense == rhs.driverLicense
//    }
}

extension Contact : NSCopying{
    func copy(with zone: NSZone? = nil) -> Any{
        let copyContact = Contact(id: contactId, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, birthday: birthday, height: height, notes: notes, driverLicense: driverLicense)
        copyContact.imagePhoto = DataManager.getImage(with: imageName, and: imageExtension)
        return copyContact
    }
}
