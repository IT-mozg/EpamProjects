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
    
    convenience init(id: String, firstName: String, lastName: String, email: String, phoneNumber: String, imagePhoto: UIImage?){
        self.init(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, imagePhoto: imagePhoto)
        contactId = id
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "contactId") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        
        var oldImage: UIImage? = nil
        let possibleOldImagePath = UserDefaults.standard.object(forKey: "path") as! String?
        if let oldImagePath = possibleOldImagePath {
            let pathes = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = pathes.first! as String
            let oldFullPath = URL(fileURLWithPath: path).appendingPathComponent(oldImagePath)
            do{
                let data = try Data(contentsOf: oldFullPath)
                oldImage = UIImage(data: data)
            }catch{
                oldImage = nil
            }
        }
        self.init(id: id, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, imagePhoto: oldImage)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactId, forKey: "contactId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        encodeImage(imagePhoto!)
    }
    
    func encodeImage(_ image: UIImage){
        let imgData = UIImage.jpegData(image)
        let relativePath = "image-\(contactId).jpg"
        let url = documentsPathForFileName(relativePath)
        do{
            try imgData(1.0)?.write(to: url)
        }catch{}
        UserDefaults.standard.set(relativePath, forKey: "path")
        UserDefaults.standard.synchronize()
    }
    
    func documentsPathForFileName(_ name: String) -> URL{
        let pathes = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = pathes.first! as String
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        return url
    }
}
