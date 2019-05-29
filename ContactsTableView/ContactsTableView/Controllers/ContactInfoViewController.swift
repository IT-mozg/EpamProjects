//
//  ContactInfoViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/7/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController {
    var editBarButtonItem: UIBarButtonItem!
    var contact: Contact!
    var update: ((_ contact: Contact)->())?
    var delete: (()->())?
    private var noText: String = NSLocalizedString("NO_LABLE_TEXT", comment: "No")
    
    //MARK: IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var driverLicenseLabel: UILabel!
    @IBOutlet weak var nodesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        presentContact()
        editBarButtonItem = UIBarButtonItem(title: NSLocalizedString("EDIT_BUTTON_TEXT", comment: "Edit"), style: .plain, target: self, action: #selector(editButtonPressed))
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    //MARK: IBActions
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        ContactActionHelper.delete(delete, viewController: self)
    }
}

//MARK: Private help methods
private extension ContactInfoViewController{
    func presentContact(){
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName ?? noText
        phoneLabel.text = contact.phoneNumber
        emailLabel.text = contact.email ?? noText
        photoImageView.image = contact.imagePhoto ?? ContactDefault.defaultImage
        driverLicenseLabel.text = contact.driverLicense ?? noText
        nodesLabel.text = contact.notes ?? noText
    }
    
    @objc func editButtonPressed(){
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewContactViewController") as? NewContactViewController{
            controller.update = {[unowned self] updatedContact in
                self.contact = updatedContact
                self.update?(updatedContact)
                self.presentContact()
            }
            controller.delete = {[unowned self] in
                self.delete?()
                self.navigationController?.popToRootViewController(animated: true)
            }
            controller.contactBeforeUpdate = contact
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
