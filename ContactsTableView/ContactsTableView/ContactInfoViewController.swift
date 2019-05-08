//
//  ContactInfoViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/7/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

//protocol ContactInfoViewControllerDelegate:class{
//    func deleteContact(at id: UUID)
//}

class ContactInfoViewController: UIViewController {
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    var editBarButtonItem: UIBarButtonItem!
    
    var contact: Contact!
    
   // weak var delegate: ContactInfoViewControllerDelegate?
    
    var update: ((_ contact: Contact)->())?
    var delete: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        presentContact()
        editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    private func presentContact(){
        firstNameLabel.text = contact?.firstName
        lastNameLabel.text = contact?.lastName
        phoneLabel.text = contact?.phoneNumber
        emailLabel.text = contact?.email
        photoImageView.image = contact?.imagePhoto
    }
    
    @objc private func editButtonPressed(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "NewContactViewController") as? NewContactViewController{
            controller.update = {[unowned self] updatedContact in
                self.contact = updatedContact
                self.update?(updatedContact)
                self.presentContact()
            }
            controller.editingContact = contact
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Delete", message: "Do you realy wanna delete current contact?", preferredStyle: .alert)
        let noAlertAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAlertAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            if let deleteClosure = self.delete{
                deleteClosure()
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(noAlertAction)
        alertController.addAction(yesAlertAction)
        present(alertController, animated: true)
    }
}
