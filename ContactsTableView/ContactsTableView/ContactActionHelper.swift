//
//  ContactActionHelper.swift
//  ContactsTableView
//
//  Created by Vlad on 5/13/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactActionHelper{
    static func delete(_ delete: (()->())?, viewController: UIViewController){
        let alertController = UIAlertController(title: "Delete", message: "Do you realy wanna delete current contact?", preferredStyle: .alert)
        let noAlertAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if let deleteClosure = delete{
                deleteClosure()
                viewController.dismiss(animated: true)
            }
        }
        alertController.addAction(noAlertAction)
        alertController.addAction(yesAlertAction)
        viewController.present(alertController, animated: true)
    }
}
