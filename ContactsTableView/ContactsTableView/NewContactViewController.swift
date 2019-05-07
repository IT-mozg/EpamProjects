//
//  NewContactViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

protocol NewContactViewControllerDelegate: class{
    func addNewContact(newItem: Contact)
}

protocol NewContactViewControllerDataCource: class {
    func updateContact(updatedContact: Contact, at indexPath: IndexPath)
}

class NewContactViewController: UIViewController {
    weak var delegate: NewContactViewControllerDelegate?
    weak var dataSource: NewContactViewControllerDataCource?
    var editingContact: Contact?
    var indexPath: IndexPath?
    
    @IBOutlet weak var photoContactImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = editingContact{
            navigationItem.rightBarButtonItem?.title = "Save"
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            phoneTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            photoContactImageView.image = contact.imagePhoto
        }else{
            navigationItem.rightBarButtonItem?.title = "Add"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewContactButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return  }
        guard let phone = phoneTextField.text else { return  }
        guard let email = emailTextField.text else { return  }
        let newItem = Contact(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, imagePhoto: photoContactImageView!.image!)
        dataSource?.updateContact(updatedContact: newItem, at: indexPath!)
        delegate?.addNewContact(newItem: newItem)
       // dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickImageButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Photo source", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.chooseImagePickerAction(source: .camera)
        })
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: { (action) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
// MARK: Image picker
extension NewContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func chooseImagePickerAction(source: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoContactImageView.image = info[.editedImage] as? UIImage
        photoContactImageView.contentMode = .scaleAspectFill
        photoContactImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
