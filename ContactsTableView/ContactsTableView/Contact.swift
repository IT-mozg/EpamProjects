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
    private var privateId: String
    
    var contactId: String{
        return privateId
    }
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var imagePhoto: UIImage?{
        set{
            guard let image = newValue else{
                do{
                    let path = self.documentsPathForFileName(imageName, fileExtension: "jpg")
                    let fileManager = FileManager.default
                    try fileManager.removeItem(at: path)
                }catch let error as NSError{
                    print(error)
                }
                return
            }
            let imgData = UIImage.jpegData(image)
            let relativePath = imageName
            let url = documentsPathForFileName(relativePath, fileExtension: "jpg")
            do{
                try imgData(1.0)!.write(to: url)
            }catch let error as NSError{
                print(error)
            }
        }
        get{
            var image: UIImage? = nil
            do{
                let path = self.documentsPathForFileName(imageName, fileExtension: "jpg")
                let data = try Data(contentsOf: path)
                image = UIImage(data: data)
            }catch let error as NSError{
                print(error)
            }
            return image
        }
    }
    
    private lazy var imageName: String = {
        return "image-\(contactId)"
    }()
    
    init(firstName: String, lastName: String, email: String, phoneNumber: String){
        privateId = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        super.init()
    }
    
    convenience init(id: String, firstName: String, lastName: String, email: String, phoneNumber: String){
        self.init(firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        privateId = id
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "contactId") as! String
        let firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        let lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        
        self.init(id: id, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
    }
    
    deinit {
        imagePhoto = nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(contactId, forKey: "contactId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
    }
    
    func documentsPathForFileName(_ name: String, fileExtension: String) -> URL{
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(name).appendingPathExtension(fileExtension)
        return fileURL
    }

}

extension Contact : NSCopying{
    func copy(with zone: NSZone? = nil) -> Any{
        let copyContact = Contact(id: contactId, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
        copyContact.imagePhoto = imagePhoto
        return copyContact
    }
}
