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
    
    var cells = [Presentation]()
    
    var contactBeforeUpdate: Contact!
    private var contactAfterUpdate: Contact!
    private var imageChanges: ImageChanges = .noChanges
    
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
            contactAfterUpdate = Contact(firstName: nil, lastName: nil, email: nil, phoneNumber: nil, birthday: nil, height: nil, notes: nil, driverLicense: nil)
        }
        setupCells()
        setupUI()
        setupValidationConditions()
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
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
         ContactActionHelper.delete(self.delete, viewController: self)
    }
}

//MARK: Private funcs
private extension NewContactViewController{
    func checkValidation(){
        if checkContactChanges() && isValidFirstName() && isValidPhoneNumber() && isValidEmail() && isValidLastName() {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func checkContactChanges() -> Bool{
        var isImageChanged = false
        switch self.imageChanges {
        case .noChanges:
            isImageChanged = false
        default:
            isImageChanged = true
        }
        return isImageChanged || !contactAfterUpdate.isEqual(contactBeforeUpdate)
    }
    
    func setupValidationConditions(){
        isValidFirstName = {
            return self.contactAfterUpdate.presentationForFirstName.validation!()
        }
        isValidLastName = {
            return self.contactAfterUpdate.presentationForLastName.validation!()
        }
        isValidEmail = {
            return self.contactAfterUpdate.presentationForEmail.validation!()
        }
        isValidPhoneNumber = {
            return self.contactAfterUpdate.presentationForPhone.validation!()
        }
    }
    
    func setupCells(){
        cells.append(contactAfterUpdate.presentationForImage)
        cells.append(contactAfterUpdate.presentationForFirstName)
        cells.append(contactAfterUpdate.presentationForLastName)
        cells.append(contactAfterUpdate.presentationForPhone)
        cells.append(contactAfterUpdate.presentationForEmail)
        cells.append(contactAfterUpdate.presentationForBirthday)
        cells.append(contactAfterUpdate.presentationForHeight)
        cells.append(contactAfterUpdate.presentationForDriverLicense)
        if contactAfterUpdate.driverLicense != nil && !contactAfterUpdate.driverLicense!.isEmpty{
            cells.append(contactAfterUpdate.presentationForDriverLicenseText)
        }
        cells.append(contactAfterUpdate.presentationForNote)
    }
    
    func setupUI(){
        if contactBeforeUpdate != nil{
            navigationItem.title = NSLocalizedString("EDITING_NAVIGATION_TITLE", comment: "Editing")
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("SAVE_BUTTON_TEXT", comment: "Save")
        }else{
            navigationItem.rightBarButtonItem?.title = NSLocalizedString("ADD_BUTTON_TEXT", comment: "Add")
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func insertCell(at indexPath: IndexPath, with cellPresent: Presentation){
        cells.insert(cellPresent, at: indexPath.row)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
    }
    
    func removeCell(at indexPath: IndexPath){
        cells.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        
    }
    
    func showNoteViewController(indexPath: IndexPath){
        if let notesViewController = storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as? NotesViewController{
            notesViewController.notes = contactAfterUpdate.notes ?? ""
            notesViewController.returnBackNotes = {[unowned self] text in
                self.contactAfterUpdate.notes = text
                self.cells[indexPath.row] = self.contactAfterUpdate.presentationForNote
                self.tableView.reloadRows(at: [indexPath], with: .right)
            }
            navigationController?.pushViewController(notesViewController, animated: true)
        }
    }
    
    //MARK: Update cells
    func updateTextFields(text: String, cell: ContactFieldTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        contactAfterUpdate.setValue(text, forKey: cell.presentation.cellType.rawValue)
        cells[indexPath.row] = cell.presentation
        _ = Validation.isValidTextField(textField: cell.contactPropertyTextField, { (text) -> (Bool) in
            guard let validation = cell.presentation.validation else{
                return true
            }
            return validation()
        })
        checkValidation()
    }
    
    func updateDriverLicenseSwitch(isOn: Bool, cell: ContactSwitchTableViewCell){
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        let newIndexPath = IndexPath(item: indexPath.row+1, section: indexPath.section)
        if isOn{
            insertCell(at: newIndexPath, with: contactAfterUpdate.presentationForDriverLicenseText)
        }else{
            removeCell(at: newIndexPath)
            contactAfterUpdate.driverLicense = nil
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            assignImage(image)
        }
        dismiss(animated: true, completion: nil)
    }

     func changeImage(){
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
        imageChanges = .changed
        cells[indexPathForImageCell.row] = contactAfterUpdate.presentationForImage
        tableView.reloadRows(at: [indexPathForImageCell], with: .none)
        checkValidation()
    }
    
    func chooseImagePickerAction(source: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension NewContactViewController: UINavigationControllerDelegate{
    
}

//MARK: TableViewControllerDelegate
extension NewContactViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cells[indexPath.row].cellType {
        case .imagePhoto:
            pickImageButtonPressed()
            indexPathForImageCell = indexPath
        case .notes:
            showNoteViewController(indexPath: indexPath)
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
        return Presentation(keyboardType: nil, placeholder: nil, title: nil, dataType: .image(imagePhoto), cellType: .imagePhoto, validation: nil)
    }
    
    var presentationForFirstName: Presentation{
        return Presentation(keyboardType: .default, placeholder: NSLocalizedString("FIRSTNAME_PLACEHOLDER", comment: ""), title: NSLocalizedString("FIRSTNAME_TITLE", comment: ""), dataType: .text(firstName), cellType: .firstName){
            if self.firstName == nil || self.firstName!.isEmpty {
                return true
            }
            return Validation.isValidName(self.firstName!)
        }
    }
    
    var presentationForLastName: Presentation{
        return Presentation(keyboardType: .default, placeholder: NSLocalizedString("LASTNAME_PLACEHOLDER", comment: ""), title: NSLocalizedString("LASTNAME_TITLE", comment: ""), dataType: .text(lastName), cellType: .lastName){
            if self.lastName == nil || self.lastName!.isEmpty {
                return true
            }
            return Validation.isValidName(self.lastName!)
        }
    }
    
    var presentationForEmail: Presentation{
        return Presentation(keyboardType: .emailAddress, placeholder: NSLocalizedString("EMAIL_PLACEHOLDER", comment: ""), title: NSLocalizedString("EMAIL_TITLE", comment: ""), dataType: .text(email), cellType: .email){
            if self.email == nil || self.email!.isEmpty{
                return true
            }
            return Validation.isValidEmail(self.email!)
        }
    }
    
    var presentationForPhone: Presentation{
        return Presentation(keyboardType: .phonePad, placeholder: NSLocalizedString("PHONE_PLACEHOLDER", comment: ""), title: NSLocalizedString("PHONE_TITLE", comment: ""), dataType: .text(phoneNumber), cellType: .phoneNumber){
            if self.phoneNumber == nil || self.phoneNumber!.isEmpty {
                return true
            }
            return Validation.isValidPhoneNumber(self.phoneNumber!)
        }
    }
    
    var presentationForBirthday: Presentation{
        return Presentation(keyboardType: .default, placeholder: NSLocalizedString("BIRTHDAY_PLACEHOLDER", comment: ""), title: NSLocalizedString("BIRTHDAY_TITLE", comment: ""), dataType: .date(birthday), cellType: .birthday, validation: nil)
    }
    
    var presentationForHeight: Presentation{
        return Presentation(keyboardType: .default, placeholder: NSLocalizedString("HEIGHT_PLACEHOLDER", comment: ""), title: NSLocalizedString("HEIGHT_TITLE", comment: ""), dataType: .height(height), cellType: .height, validation: nil)
    }
    
    var presentationForDriverLicense: Presentation{
         return Presentation(keyboardType: nil, placeholder: nil, title: NSLocalizedString("EXIST_DRIVER_LICENSE_TITLE", comment: ""), dataType: nil, cellType: .driverLicenseSwitch, validation: nil)
    }
    
    var presentationForDriverLicenseText: Presentation{
        return Presentation(keyboardType: .numberPad, placeholder: NSLocalizedString("DRIVER_LICENSE_PLACEHOLDER", comment: ""), title: NSLocalizedString("DRIVER_LICENSE_TITLE", comment: ""), dataType: .text(driverLicense), cellType: .driverLicense, validation: nil)
    }
    
    var presentationForNote: Presentation{
        return Presentation(keyboardType: .default, placeholder: NSLocalizedString("NOTES_PLACEHOLDER", comment: ""), title: NSLocalizedString("NOTES_TITLE", comment: ""), dataType: .text(notes), cellType: .notes, validation: nil)
    }
    
}

//MARK: TableViewDataSource
extension NewContactViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let present = cells[indexPath.row]
        switch present.cellType {
        case .imagePhoto:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.imageCellId) as! ContactImageTableViewCell
            cell.presentation = present
            return cell
        case .driverLicenseSwitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.switchCellId) as! ContactSwitchTableViewCell
            cell.presentation = present
            cell.updateSwitchClosure = {[weak self] isOn, cell in
                self?.updateDriverLicenseSwitch(isOn: isOn, cell: cell)
            }
            if contactAfterUpdate.driverLicense != nil && !contactAfterUpdate.driverLicense!.isEmpty{
                cell.fieldSwitch.isOn = true
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellSetings.textFieldCellId) as! ContactFieldTableViewCell
            cell.presentation = present
            cell.updateClosure = {[weak self] text, cell in
                self?.updateTextFields(text: text, cell: cell)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let present = cells[indexPath.row]
        switch present.cellType {
        case .imagePhoto:
            return CGFloat(CellSetings.imageCellHeight)
        default:
            return CGFloat(CellSetings.regularCellHeight)
        }
    }
}
