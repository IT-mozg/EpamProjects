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
    
    var cells = [CellType]()
    
    var contactBeforeUpdate: Contact!
    private var contactAfterUpdate: Contact!
    
    var update: UpdateClosure?
    var delete: (()->())?
    
    private var indexPathForImageCell: IndexPath!
    
    private var isValidFirstName: (()->(Bool))!
    private var isValidLastName: (()->(Bool))!
    private var isValidPhoneNumber: (()->(Bool))!
    private var isValidEmail: (()->(Bool))!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deleteButton.isEnabled = !(contactBeforeUpdate == nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contactBeforeUpdate{
            contactAfterUpdate = (contact.copy() as! Contact)
        }else{
            contactAfterUpdate = Contact(firstName: "", lastName: nil, email: nil, phoneNumber: "", birthday: nil, height: nil, notes: nil, driverLicense: nil)
        }
      //  setupUI()
        setupCells()
        setupUI()
        isValidFirstName = {
            return Validation.isValidName(self.contactAfterUpdate.firstName)
        }
        isValidLastName = {
            return true
        }
        isValidEmail = {
            return true
        }
        isValidPhoneNumber = {
            return Validation.isValidPhoneNumber(self.contactAfterUpdate.phoneNumber)
        }
        
    }
    
    //MARK: IBActions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
         ContactActionHelper.delete(self.delete, viewController: self)
    }
}

//MARK: Private funcs
private extension NewContactViewController{
    private func setupCells(){
        cells.append(.image(contactAfterUpdate.presentationForImage))
        cells.append(.firstName(contactAfterUpdate.presentationForFirstName))
        cells.append(.lastName(contactAfterUpdate.presentationForLastName))
        cells.append(.phone(contactAfterUpdate.presentationForPhone))
        cells.append(.email(contactAfterUpdate.presentationForEmail))
        cells.append(.birthday(contactAfterUpdate.presentationForBirthday))
        cells.append(.height(contactAfterUpdate.presentationForHeight))
        cells.append(.driverLicenseSwitch(contactAfterUpdate.presentationForDriverLicense))
        cells.append(.note(contactAfterUpdate.presentationForNote))
    }
    
    private func setupUI(){
        if contactBeforeUpdate != nil{
            navigationItem.title = NSLocalizedString("EDITING_NAVIGATION_TITLE", comment: "Editing")
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("SAVE_BUTTON_TEXT", comment: "Save")
        }else{
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("ADD_BUTTON_TEXT", comment: "Add")
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

// MARK: Image picker
extension NewContactViewController: UIImagePickerControllerDelegate{
    private func pickImageButtonPressed() {
        if contactAfterUpdate.imagePhoto == nil{
            changeImage()
        }
        else{
            let alertController = UIAlertController(title: NSLocalizedString("EDIT_ACTION_TITLE", comment: "Edit image"), message: nil, preferredStyle: .actionSheet)
            let removeAction = UIAlertAction(title: NSLocalizedString("REMOVE_ACTION_BUTTON_TEXT", comment: "Remove"), style: .default) { (action) in
                self.assignImage(nil)
            }
            let changeAction = UIAlertAction(title: NSLocalizedString("CHANGE_ACTION_BUTTON_TEXT", comment: "Change"), style: .default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.changeImage()
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_ACTION_BUTTON_TEXT", comment: "Cancel"), style: .cancel, handler: nil)
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
        let alertController = UIAlertController(title: NSLocalizedString("SOURCE_ACTION_TITLE", comment: "Photo source"), message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("CAMERA_ACTION_BUTTON_TEXT", comment: "Camera"), style: .default, handler: { (action) in
            self.chooseImagePickerAction(source: .camera)
        })
        let libraryAction = UIAlertAction(title: NSLocalizedString("LIBRARY_ACTION_BUTTON_TEXT", comment: "Library"), style: .default, handler: { (action) in
            self.chooseImagePickerAction(source: .photoLibrary)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL_ACTION_BUTTON_TEXT", comment: "Cancel"), style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        #endif
    }
    private func assignImage(_ image: UIImage?){
        contactAfterUpdate.imagePhoto = image
        cells[indexPathForImageCell.row] = .image(contactAfterUpdate.presentationForImage)
        tableView.reloadRows(at: [indexPathForImageCell], with: .none)
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
            assignImage(image)
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
    
    private func checkTextFieldsValidation(){
        if isValidFirstName() && isValidPhoneNumber() && isValidEmail() && isValidLastName() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: TableViewControllerDelegate
extension NewContactViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cells[indexPath.row] {
        case .image(_):
            pickImageButtonPressed()
            indexPathForImageCell = indexPath
        default:
            break
        }
        view.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Contact extension
private extension Contact{
    
    var presentationForImage: Presentation{
        return Presentation(keyboardType: nil, placeholder: nil, title: nil, dataType: .image(imagePhoto))
    }
    
    var presentationForFirstName: Presentation{
        return Presentation(keyboardType: .default, placeholder: "First name", title: "First name *:", dataType: .text(firstName))
    }
    
    var presentationForLastName: Presentation{
        return Presentation(keyboardType: .default, placeholder: "Last name", title: "Last:", dataType: .text(lastName))
    }
    
    var presentationForEmail: Presentation{
        return Presentation(keyboardType: .emailAddress, placeholder: "Email", title: "Email:", dataType: .text(email))
    }
    
    var presentationForPhone: Presentation{
        return Presentation(keyboardType: .phonePad, placeholder: "+380XXXXXXXXX", title: "Phone *:", dataType: .text(phoneNumber))
    }
    
    var presentationForBirthday: Presentation{
        return Presentation(keyboardType: .default, placeholder: "Birthday", title: "Birthday:", dataType: .date(birthday))
    }
    
    var presentationForHeight: Presentation{
        return Presentation(keyboardType: .default, placeholder: "Height", title: "Height:", dataType: .height(height))
    }
    
    var presentationForDriverLicense: Presentation{
         return Presentation(keyboardType: .default, placeholder: "Driver license", title: "Driver license:", dataType: .text(driverLicense))
    }
    
    var presentationForNote: Presentation{
        return Presentation(keyboardType: .default, placeholder: "Note", title: "Note:", dataType: .text(notes))
    }
    
}

//MARK: TableViewDataSource
extension NewContactViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cells[indexPath.row]
        switch cellType {
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.imageCellId) as! ContactImageTableViewCell
            cell.cellType = cellType
            return cell
        case .driverLicenseSwitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.switchCellId) as! ContactSwitchTableViewCell
            cell.cellType = cellType
            cell.updateClosure = {[weak self] text, cell in
                self?.updateDriverLicenseSwitch(text: text, cell: cell)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.textFieldCellId) as! ContactTextFIeldTableViewCell
            cell.cellType = cellType
            cell.updateClosure = {[weak self] text, cell in
                self?.updateTextFields(text: text, cell: cell)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cells[indexPath.row]
        switch cellType {
        case .image:
            return 200
        default:
            return 45
        }
    }
}

//MARK: Update cells
private extension NewContactViewController{
    private func updateTextFields(text: String, cell: ContactTextFIeldTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else{
            return
        }
        switch cell.cellType! {
        case .firstName(_):
            contactAfterUpdate.firstName = text
            cells[indexPath.row] = CellType.firstName(contactAfterUpdate.presentationForFirstName)
            _ = Validation.isValidTextField(textField: cell.contactPropertyTextField) { (text) -> (Bool) in
                return isValidFirstName()
            }
        case .lastName(_):
            contactAfterUpdate.lastName = text
            cells[indexPath.row] = CellType.lastName(contactAfterUpdate.presentationForLastName)
            if text.isEmpty{
                isValidLastName = {return true}
            }else{
                isValidLastName = {
                    return Validation.isValidName(self.contactAfterUpdate.lastName ?? "")
                }
            }
            _ = Validation.isValidTextField(textField: cell.contactPropertyTextField) { (text) -> (Bool) in
                return isValidLastName()
            }

        case .email(_):
            contactAfterUpdate.email = text
            cells[indexPath.row] = CellType.email(contactAfterUpdate.presentationForEmail)
            if text.isEmpty{
                isValidEmail = {return true}
            }else{
                isValidEmail = {
                    return Validation.isValidEmail(self.contactAfterUpdate.email ?? "")
                }
            }
            _ = Validation.isValidTextField(textField: cell.contactPropertyTextField) { (text) -> (Bool) in
                return isValidEmail()
            }
        case .phone(_):
            contactAfterUpdate.phoneNumber = text
            cells[indexPath.row] = CellType.phone(contactAfterUpdate.presentationForPhone)
            _ = Validation.isValidTextField(textField: cell.contactPropertyTextField) { (text) -> (Bool) in
                return isValidPhoneNumber()
            }
        case .birthday(_):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ContactDefault.dateFormat
            contactAfterUpdate.birthday = dateFormatter.date(from: text)
            cells[indexPath.row] = CellType.birthday(contactAfterUpdate.presentationForBirthday)
        case .height(_):
            contactAfterUpdate.height = Int(text)
            cells[indexPath.row] = CellType.height(contactAfterUpdate.presentationForHeight)
        case .note(_):
            contactAfterUpdate.notes = text
            cells[indexPath.row] = CellType.note(contactAfterUpdate.presentationForNote)
        default:
            break
        }
        checkTextFieldsValidation()
    }
    
    private func updateDriverLicenseSwitch(text: String, cell: ContactSwitchTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else{
            return
        }
        switch cell.cellType! {
        case .driverLicenseSwitch(_):
            contactAfterUpdate.driverLicense = text
            cells[indexPath.row] = CellType.driverLicenseSwitch(contactAfterUpdate.presentationForDriverLicense)
        default:
            break
        }
    }
}
