//
//  ContactInfoViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/7/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var contact: Contact?
    
    override func viewDidAppear(_ animated: Bool) {
        if let navBar = navigationController?.navigationBar{
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presentContact()
    }
    
    private func presentContact(){
        firstNameLabel.text = contact?.firstName
        lastNameLabel.text = contact?.lastName
        phoneLabel.text = contact?.phoneNumber
        emailLabel.text = contact?.email
        photoImageView.image = contact?.imagePhoto
    }

    

}
