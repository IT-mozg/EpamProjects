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
    
    var contactBeforeUpdate: Contact!
    private var contactAfterUpdate: Contact!
    private var imageChanges: ImageChanges = .noChanges
    
    var update: UpdateClosure?
    var delete: (()->())?
    
    @IBOutlet weak var photoContactImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         deleteButton.isEnabled = !(contactBeforeUpdate == nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contactBeforeUpdate{
            contactAfterUpdate = (contact.copy() as! Contact)
        }else{
            contactAfterUpdate = Contact(firstName: nil, lastName: nil, email: nil, phoneNumber: nil)
        }
        setupUI()

    }
    
    //MARK: IBActions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewContactButtonPressed(_ sender: UIBarButtonItem) {
        if let updateClosure = self.update{
            updateClosure(contactAfterUpdate)
        }
        if delegate != nil{
            delegate!.addNewContact(newItem: contactAfterUpdate)
        }
        contactAfterUpdate.saveImage()
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
         ContactActionHelper.delete(self.delete, viewController: self)
    }
    
    @IBAction func pickImageButtonPressed(_ sender: UIButton) {
        if contactAfterUpdate.imagePhoto == nil{
            changeImage()
        }
        else{
            let alertController = UIAlertController(title: "Edit image", message: nil, preferredStyle: .actionSheet)
            let removeAction = UIAlertAction(title: "Remove", style: .default) { (action) in
                self.assingImage(nil)
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
        checkValidation()
    }
}

// MARK: private funcs
private extension NewContactViewController{
    private func checkValidation(){
        var isValid = isValidFirstNameTextField()
        if isValid{
            isValid = isValidLastNameTextField()
            if isValid{
                isValid = isValidEmailTextField()
                if isValid{
                    isValid = isValidPhoneTextField()
                    if isValid{
                        isValid = !isAllTextFieldsEmpty()
                    }
                }
            }
        }
        navigationItem.rightBarButtonItem?.isEnabled = isValid && checkContactChanges()
    }
    
    private func checkContactChanges() -> Bool{
        var isImageChanged = false
        switch self.imageChanges {
        case .noChanges:
            isImageChanged = false
        default:
            isImageChanged = true
        }
        return isImageChanged || !contactAfterUpdate.isEqual(contactBeforeUpdate)
    }
    
    private func setupUI(){
        if let contact = contactAfterUpdate{
            navigationItem.title = "Editing"
            navigationItem.rightBarButtonItem?.title = "Save"
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            phoneTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            photoContactImageView.image = contact.imagePhoto ?? ContactDefault.defaultCameraImage
        }else{
            navigationItem.rightBarButtonItem?.title = "Add"
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
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
    
    private func assingImage(_ image: UIImage?){
        contactAfterUpdate.imagePhoto = image
        imageChanges = .changed
        photoContactImageView.image = image ?? ContactDefault.defaultCameraImage
        photoContactImageView.contentMode = .scaleAspectFill
        photoContactImageView.clipsToBounds = true
        checkValidation()
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
            self.contactAfterUpdate.firstName = text
            if text.isEmpty {
                return true
            }
            return Validation.isValidName(text)
        }
    }
    
    private func isValidLastNameTextField() -> Bool{
        return isValidTextField(textField: lastNameTextField){ (text) -> (Bool) in
            self.contactAfterUpdate.lastName = text
            if text.isEmpty {
                return true
            }
            return Validation.isValidName(text)
        }
    }
    private func isValidEmailTextField() -> Bool{
        return isValidTextField(textField: emailTextField){ (text) -> (Bool) in
            self.contactAfterUpdate.email = text
            if text.isEmpty {
                return true
            }
            return Validation.isValidEmail(text)
        }
    }
    
    private func isValidPhoneTextField() -> Bool{
        return isValidTextField(textField: phoneTextField){ (text) -> (Bool) in
            self.contactAfterUpdate.phoneNumber = text
            if text.isEmpty {
                return true
            }
            return Validation.isValidPhoneNumber(text)
        }
    }
    
    private func isAllTextFieldsEmpty() -> Bool{
        return firstNameTextField.text!.isEmpty && lastNameTextField.text!.isEmpty && phoneTextField.text!.isEmpty && emailTextField.text!.isEmpty
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
