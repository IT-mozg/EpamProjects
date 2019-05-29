//
//  DataManager.swift
//  ContactsTableView
//
//  Created by Vlad on 5/27/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class DataManager{
    static func unarchiveContacts() -> [String:[Contact]]{
        let userDefaults = UserDefaults.standard
        var contactDictionary = [String:[Contact]]()
        do{
            if let decoded = userDefaults.data(forKey: "contacts"){
                contactDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [String: [Contact]]
            }
        }catch {
            print(error)
        }
        return contactDictionary
    }
    
    static func updateUserDefaults(with contactDictionary: [String:[Contact]]){
        let userDefaults = UserDefaults.standard
        do{
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: contactDictionary, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "contacts")
            userDefaults.synchronize()
        }catch{
            print(error)
        }
    }
    
    static func documentsPath(for fileName: String, with fileExtension: String) -> URL{
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        return fileURL
    }
    
    static func saveImage(image: UIImage?, with name: String, and fileExtension: String){
        guard let image = image else{
            deleteImage(with: name, and: fileExtension)
            return
        }
        let imgData = UIImage.jpegData(image)
        let relativePath = name
        let url = DataManager.documentsPath(for: relativePath, with: fileExtension)
        do{
            try imgData(1.0)!.write(to: url)
        }catch let error as NSError{
            print(error)
        }
    }
    
    static func deleteImage(with name: String, and fileExtension: String){
        do{
            let path = DataManager.documentsPath(for: name, with: fileExtension)
            let fileManager = FileManager.default
            try fileManager.removeItem(at: path)
        }catch let error as NSError{
            print(error)
        }
    }
    
    static func getImage(with name: String, and fileExtension: String) -> UIImage?{
        var image: UIImage? = nil
        do{
            let path = DataManager.documentsPath(for: name, with: fileExtension)
            let data = try Data(contentsOf: path)
            image = UIImage(data: data)
        }catch let error as NSError{
            print(error)
        }
        return image
    }
}
