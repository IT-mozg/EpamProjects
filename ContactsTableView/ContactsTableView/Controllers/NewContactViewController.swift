//
//  NewContactViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

typealias UpdateClosure = (_ contact: Contact) -> ()
class NewContactViewController: UITableViewController {
    weak var delegate: NewContactViewControllerDelegate?
    
    var editingContact: Contact?
    var update: UpdateClosure?
    var delete: (()->())?
    
    private var meter: Int = 0
    private var deсimetеr: Int = 0
    private var santimeter: Int = 0
    
    private var contactImage: UIImage?
    private var datePicker: UIDatePicker?
    private var heightPickerView: UIPickerView?
    
    @IBOutlet weak var photoContactImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var driverLicenseTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var driverLicenseSwitch: UISwitch!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteButton.isEnabled = !(editingContact == nil)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
//        view.addGestureRecognizer(tapGesture)
        firstNameTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(validateTextFields), for: .editingChanged)
    }
    
//    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
//        view.endEditing(true)
//    }
    
    //MARK: IBActions
    @IBAction func driverLicenseSwitchValueChanged(_ sender: UISwitch) {
        driverLicenseTextField.isHidden = !driverLicenseSwitch.isOn
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewContactButtonPressed(_ sender: UIBarButtonItem) {
        guard let firstName = firstNameTextField.text else { return }
        let lastName = lastNameTextField.text
        guard let phone = phoneTextField.text else { return  }
        let email = emailTextField.text
        let birthday = birthdayTextField.text
        let height = heightTextField.text
        let notes = notesTextView.text
        let driverLicense = driverLicenseSwitch.isOn ? driverLicenseTextField.text : nil
        if let updateClosure = self.update{
            let updated = editingContact!.copy() as! Contact
            updated.firstName = firstName
            updated.lastName = lastName
            updated.email = email
            updated.phoneNumber = phone
            updated.saveImage(image: contactImage)
            updated.birthday = birthday
            updated.height = height
            updated.notes = notes
            updated.driverLicense = driverLicense
            updateClosure(updated)
        }
        if delegate != nil{
            let newItem = Contact(firstName: firstName, lastName: lastName, email: email, phoneNumber: phone, birthday: birthday, height: height, notes: notes, driverLicense: driverLicense)
            newItem.saveImage(image: contactImage)
            delegate!.addNewContact(newItem: newItem)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
         ContactActionHelper.delete(self.delete, viewController: self)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    private func setupUI(){
        if let contact = editingContact{
            navigationItem.title = "Editing"
            navigationItem.rightBarButtonItem?.title = "Save"
            firstNameTextField.text = contact.firstName
            lastNameTextField.text = contact.lastName
            phoneTextField.text = contact.phoneNumber
            emailTextField.text = contact.email
            birthdayTextField.text = contact.birthday
            heightTextField.text = contact.height
            driverLicenseTextField.text = contact.driverLicense
            notesTextView.text = contact.notes
            photoContactImageView.image = contact.imagePhoto ?? ContactDefault.defaultCameraImage
            contactImage = contact.imagePhoto
        }else{
            navigationItem.rightBarButtonItem?.title = "Add"
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        setupBirthdayCell()
        setupHeightPickeView()
        setupDriverLicenseCell()
    }
    
    private func setupHeightPickeView(){
        heightPickerView = UIPickerView()
        heightPickerView?.delegate = self
        heightPickerView?.dataSource = self
        heightTextField.inputView = heightPickerView
    }
    
    private func setupBirthdayCell(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        birthdayTextField.inputView = datePicker
    }
    
    private func setupDriverLicenseCell(){
        if let text = driverLicenseTextField.text{
            driverLicenseSwitch.isOn = !(text.isEmpty)
            driverLicenseTextField.isHidden = !driverLicenseSwitch.isOn
        }
    }
    
    private func pickImageButtonPressed() {
        if editingContact?.imagePhoto == nil && contactImage == nil{
            changeImage()
        }
        else{
            let alertController = UIAlertController(title: "Edit image", message: nil, preferredStyle: .actionSheet)
            let removeAction = UIAlertAction(title: "Remove", style: .default) { (action) in
                self.assingImage(nil, .scaleAspectFit)
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

}
// MARK: Image picker
extension NewContactViewController: UIImagePickerControllerDelegate{
    private func assingImage(_ image: UIImage?, _ mode: UIView.ContentMode){
        contactImage = image
        photoContactImageView.image = contactImage ?? ContactDefault.defaultCameraImage
        photoContactImageView.contentMode = mode
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
            assingImage(image, .scaleAspectFill)
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
    @objc private func validateTextFields() -> Bool{
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
            return true
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
        return false
    }
    
    private func isValidTextField(textField: UITextField, _ validate: (String)->(Bool))->Bool{
        if let text = textField.text{
            if validate(text){
                navigationItem.rightBarButtonItem?.isEnabled = true
                textField.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                return true
            }
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
        textField.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return false
    }
    
    @objc private func isValidFirstNameTextField() -> Bool{
        return isValidTextField(textField: firstNameTextField){ (text) -> (Bool) in
            return Validation.isValidName(text)
        }
    }
    
    @objc private func isValidLastNameTextField() -> Bool{
        return isValidTextField(textField: lastNameTextField){ (text) -> (Bool) in
            return Validation.isValidName(text)
        }
    }
    
    @objc private func isValidEmailTextField() -> Bool{
        return isValidTextField(textField: emailTextField){ (text) -> (Bool) in
            return Validation.isValidEmail(text)
        }
    }
    
    @objc private func isValidPhoneTextField() -> Bool{
        return isValidTextField(textField: phoneTextField){ (text) -> (Bool) in
            return Validation.isValidPhoneNumber(text)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: TableViewControllerDelegate
extension NewContactViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            pickImageButtonPressed()
        }
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UIPickerViewDataSource
extension NewContactViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
}

//MARK: UIPickerViewDelegate
extension NewContactViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
            case 0:
                meter = row
            case 1:
                deсimetеr = row
            case 2:
                santimeter = row
            default:
                break
        }
        heightTextField.text = "\(meter)/\(deсimetеr)/\(santimeter)"
    }
}
