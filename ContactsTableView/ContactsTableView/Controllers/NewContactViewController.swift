//
//  NewContactViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

typealias UpdateClosure = (_ contact: Contact) -> ()
class NewContactViewController: UIViewController {
    weak var delegate: NewContactViewControllerDelegate?
    
    var editingContact: Contact?
    var update: UpdateClosure?
    var delete: (()->())?
    
    var contactImage: UIImage?
    
    @IBOutlet weak var photoContactImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteButton.isHidden = editingContact == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    //MARK: IBActions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewContactButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return  }
        guard let phone = phoneTextField.text else { return  }
        guard let email = emailTextField.text else { return  }
        if let updateClosure = self.update{
            let updated = editingContact!.copy() as! Contact
            updated.firstName = firstName
            updated.lastName = lastName
            updated.email = email
            updated.phoneNumber = phone
            updated.saveImage()
            updateClosure(updated)
        }
        if delegate != nil{
            let newItem = Contact(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone)
            newItem.saveImage()
            delegate!.addNewContact(newItem: newItem)

        }
        dismiss(animated: true, completion: nil)
    
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
         ContactActionHelper.delete(self.delete, viewController: self)
    }
    
    @IBAction func pickImageButtonPressed(_ sender: UIButton) {
        if editingContact == nil && contactImage == nil{
            changeImage()
        }
        else{
            let alertController = UIAlertController(title: "Edit image", message: nil, preferredStyle: .actionSheet)
            let removeAction = UIAlertAction(title: "Remove", style: .default) { (action) in
                self.contactImage = nil
            }
            let changeAction = UIAlertAction(title: "Change", style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.changeImage()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(removeAction)
            alertController.addAction(changeAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
    }
    
    @IBAction func validateTextFields(){
        var firstNameChecker = false
        var lastNameChecker = true
        var phoneChecker = false
        var emailChecker = true
        if !firstNameTextField.text!.isEmpty{
            firstNameChecker = isValidFirstNameTextField()
        }
        if !lastNameTextField.text!.isEmpty{
            lastNameChecker = isValidLastNameTextField()
        }
        if !phoneTextField.text!.isEmpty{
            phoneChecker = isValidPhoneTextField()
        }
        if !emailTextField.text!.isEmpty{
            emailChecker = isValidEmailTextField()
        }
        if firstNameChecker && lastNameChecker && phoneChecker && emailChecker{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: private funcs
private extension NewContactViewController{
    private func setupUI(){
        if let contact = editingContact{
            navigationItem.title = "Editing"
            navigationItem.rightBarButtonItem?.title = "Save"
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            phoneTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            photoContactImageView.image = contact.imagePhoto ?? ContactDefault.defaultCameraImage
            contactImage = contact.imagePhoto
        }else{
            navigationItem.rightBarButtonItem?.title = "Add"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
// MARK: Image picker
extension NewContactViewController: UIImagePickerControllerDelegate{
    private func changeImage(){
        #if targetEnvironment(simulator)
        self.chooseImagePickerAction(source: .photoLibrary)
        #else
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
        #endif
    }
    
    private func assingImage(_ image: UIImage){
        contactImage = image
        photoContactImageView.image = contactImage
        photoContactImageView.contentMode = .scaleAspectFill
        photoContactImageView.clipsToBounds = true
    }
    
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
        if let image = info[.editedImage] as? UIImage{
            assingImage(image)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension NewContactViewController: UINavigationControllerDelegate{
    
}

//MARK: TextFieldDelegate
extension NewContactViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: Validation
    
    private func isValidTextField(textField: UITextField, _ validate: (String)->(Bool))->Bool{
        if let text = textField.text{
            if validate(text){
                navigationItem.rightBarButtonItem?.isEnabled = true
                textField.backgroundColor = ContactDefault.validColor
                return true
            }
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
        textField.backgroundColor = ContactDefault.invalidColor
        return false
    }
    
    private func isValidFirstNameTextField() -> Bool{
        return isValidTextField(textField: firstNameTextField){ (text) -> (Bool) in
            return Validation.isValidName(text)
        }
    }
    
    private func isValidLastNameTextField() -> Bool{
        return isValidTextField(textField: lastNameTextField){ (text) -> (Bool) in
            return Validation.isValidName(text)
        }
    }
    private func isValidEmailTextField() -> Bool{
        return isValidTextField(textField: emailTextField){ (text) -> (Bool) in
            return Validation.isValidEmail(text)
        }
    }
    
    private func isValidPhoneTextField() -> Bool{
        return isValidTextField(textField: phoneTextField){ (text) -> (Bool) in
            return Validation.isValidPhoneNumber(text)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
