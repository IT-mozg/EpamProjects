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
        let alertController = UIAlertController(title: NSLocalizedString("DELETE_ACTION_TITLE", comment: "Delete"), message: NSLocalizedString("DELETE_ACTION_MESSAGE", comment: "Delete"), preferredStyle: .alert)
        let noAlertAction = UIAlertAction(title: NSLocalizedString("NO_ACTION_BUTTON_TEXT", comment: "No"), style: .default, handler: nil)
        let yesAlertAction = UIAlertAction(title: NSLocalizedString("YES_ACTION_BUTTON_TEXT", comment: "Yes"), style: .default) { (action) in
            if let deleteClosure = delete{
                deleteClosure()
                //viewController.dismiss(animated: true)
                viewController.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(noAlertAction)
        alertController.addAction(yesAlertAction)
        viewController.present(alertController, animated: true)
    }
}

extension String{
    func splitString(separator: String) -> [String]{
        let thisString = self.lowercased()
        let strippedName = thisString.trimmingCharacters(in: CharacterSet.whitespaces)
        return strippedName.components(separatedBy: separator)
    }
}
