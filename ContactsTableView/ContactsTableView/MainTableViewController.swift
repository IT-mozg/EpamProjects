//
//  MainTableViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/6/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit
let mainCellID = "MainCell"

class MainTableViewController: UITableViewController {
    var contacts: [Contact] = []{
        didSet{
            updateUserDefault()
        }
    }
    var userDefaults: UserDefaults!

    private var filteredContacts: [Contact] = []
    private var contactSearchController: UISearchController!
    private var searchBarIsEmpty: Bool{
        guard let text = contactSearchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
    private var isFiltering: Bool{
        return contactSearchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        unurchiveContacts()
    }
    
    private func updateUserDefault(){
        do{
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: contacts, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "contacts")
            userDefaults.synchronize()
        }catch{}
    }
    
    private func unurchiveContacts(){
        userDefaults = UserDefaults.standard

        do{
            if let decoded = userDefaults.data(forKey: "contacts"){
                contacts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [Contact]
            }
        }catch {
            print(error)
        }
    }
    
    private func setupUI(){
        tableView.backgroundView = backgroundView
        // setup searchController
        contactSearchController = UISearchController(searchResultsController: nil)
        contactSearchController.searchResultsUpdater = self
        contactSearchController.obscuresBackgroundDuringPresentation = false
        contactSearchController.searchBar.placeholder = "Search contact"
        navigationItem.searchController = contactSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func updateUserDefaults(){
        do{
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject:contacts, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "contacts")
            userDefaults.synchronize()
        }catch{}
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        navigationItem.leftBarButtonItem!.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func addNewButtonPressed(_ sender: Any) {
        addButtonItemPressed()
    }
    
    @objc func addButtonItemPressed(){
        if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactNavigationController") as? UINavigationController{
            if let viewController = navigationController.viewControllers.first as? NewContactViewController{
                viewController.delegate = self
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        backgroundView.isHidden = !contacts.isEmpty
        if !contacts.isEmpty{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemPressed))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        }
        else{
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
        }
        updateUserDefaults()
        if isFiltering{
            return filteredContacts.count
        }
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as! MainContactTableViewCell
        if isFiltering{
            cell.updateWith(model: filteredContacts[indexPath.row])
        }else{
            cell.updateWith(model: contacts[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: TableViewControllerDelegate
extension MainTableViewController{
    
    private func updateContact(updatedContact: Contact, indexPath: IndexPath){
        self.contacts[indexPath.row] = updatedContact
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        updateUserDefaults()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ContactInfoViewController") as? ContactInfoViewController{
            controller.update = {[unowned self] updatedContact in
                self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
            }
            controller.delete = {[unowned self] in
                self.deleteRowContact(indexPath)
            }
            if isFiltering{
                controller.contact = filteredContacts[indexPath.row]
            }
            else{
                controller.contact = contacts[indexPath.row]
            }
            navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteRowContact(indexPath)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactNavigationController") as? UINavigationController{
                if let controller = navigationController.viewControllers.first as? NewContactViewController{
                    if self.isFiltering{
                        controller.editingContact = self.filteredContacts[indexPath.row]
                    }
                    else{
                        controller.editingContact = self.contacts[indexPath.row]
                    }
                    controller.update = {[unowned self] updatedContact in
                        self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
                    }
                    controller.delete = {[unowned self] in
                        self.deleteRowContact(indexPath)
                    }
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
        delete.backgroundColor = ContactDefault.deleteColor
        edit.backgroundColor = ContactDefault.editColor
        return [delete,edit]
    }
    
    private func deleteRowContact(_ indexPath: IndexPath){
        if isFiltering{
            deleteRowContact(at: filteredContacts[indexPath.row].contactId)
        }
        else{
            deleteRowContact(at: contacts[indexPath.row].contactId)
        }
    }
    
    private func deleteRowContact(at id: String){
        var index: Int?
        if isFiltering{
            index = filteredContacts.firstIndex { $0.contactId == id }
            guard index != nil else {
                return
            }
            filteredContacts.removeAll { $0.contactId == id }
            deleteTableRows(index!)
        }
        index = contacts.firstIndex { $0.contactId == id }
        guard index != nil else {
            return
        }
        self.contacts.removeAll { $0.contactId == id }
        deleteTableRows(index!)
        updateUserDefaults()
    }
    
    private func deleteTableRows(_ id: Int){
        let indexPath = IndexPath(item: id, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
}

// MARK: NewContactViewControllerDelegate
extension MainTableViewController: NewContactViewControllerDelegate{
    func addNewContact(newItem: Contact) {
        backgroundView.isHidden = true
        let count = contacts.count
        contacts.append(newItem)
        let indexPath = IndexPath(item: count, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        updateUserDefaults()
    }
}

// MARK: Search
extension MainTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = contacts

        let searchItems = splitString(string: searchController.searchBar.text!, separator: " ")
        
        let filteredResult = searchResults.filter { (contact) -> Bool in
            let firstNameItems = splitString(string: contact.firstName, separator: " ")
            for firstNameItem in firstNameItems{
                for searchItem in searchItems{
                    if firstNameItem.contains(searchItem.lowercased()){
                        return true
                    }
                }
            }
            
            let lastNameItems = splitString(string: contact.lastName, separator: " ")
            for lastNameItem in lastNameItems{
                for searchItem in searchItems{
                    if lastNameItem.contains(searchItem.lowercased()){
                        return true
                    }
                }
            }
            
            for earchItem in searchItems{
                if contact.email.lowercased().contains(earchItem){
                    return true
                }
            }
            
            for earchItem in searchItems{
                if contact.phoneNumber.lowercased().contains(earchItem){
                    return true
                }
            }
            return false
        }
        
        self.filteredContacts = filteredResult
        tableView.reloadData()
    }
    
    private func splitString(string: String, separator: String) -> [String]{
        let thisString = string.lowercased()
        let strippedName = thisString.trimmingCharacters(in: CharacterSet.whitespaces)
        return strippedName.components(separatedBy: separator)
    }
}
