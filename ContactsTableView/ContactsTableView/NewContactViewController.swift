//
//  NewContactViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

protocol NewContactViewControllerDelegate{
    func addNewContact(_ contactController: NewContactViewController, newItem: Contact)
}

class NewContactViewController: UIViewController {
    var delegate: NewContactViewControllerDelegate?
    
    @IBOutlet weak var photoContactImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addNewContactButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return  }
        guard let phone = phoneTextField.text else { return  }
        guard let email = emailTextField.text else { return  }
        let newItem = Contact(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, imagePhoto: "avatar")
        delegate?.addNewContact(self, newItem: newItem)
        dismiss(animated: true, completion: nil)
    }
}
