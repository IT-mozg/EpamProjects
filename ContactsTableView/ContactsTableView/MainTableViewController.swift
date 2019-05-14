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
    private var contacts: [Contact] = []
    private var filteredContacts: [Contact] = []{
        didSet{
            searchResultController?.filteredContacts = filteredContacts
            searchResultController?.searchString = contactSearchController.searchBar.text
        }
    }
    private var userDefaults: UserDefaults!
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
    private var searchResultController: ContactsSearchResultTableViewController?
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup background
        tableView.backgroundView = backgroundView
        
        // setup searchController
        searchResultController = storyboard?.instantiateViewController(withIdentifier: "ContactsSearchResultTableViewController") as? ContactsSearchResultTableViewController
        searchResultController!.delegate = self
        contactSearchController = UISearchController(searchResultsController: searchResultController)
        contactSearchController.searchResultsUpdater = self
        contactSearchController.obscuresBackgroundDuringPresentation = false
        contactSearchController.searchBar.placeholder = "Search contact"
        contactSearchController.searchBar.delegate = self
        navigationItem.searchController = contactSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // unarchive contacts
        userDefaults = UserDefaults.standard
        if let decoded = userDefaults.data(forKey: "contacts"){
            let decodedContacts = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Contact]
            contacts = decodedContacts
        }
    }
    
    private func updateUserDefaults(){
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
        userDefaults.set(encodedData, forKey: "contacts")
        userDefaults.synchronize()
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
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as! MainContactTableViewCell
        cell.updateWith(model: contacts[indexPath.row])
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
        didSelectRow(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRow(tableView, indexPath)
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
            contacts.removeAll { $0.contactId == id }
            deleteTableRows(index!)
        }else{
            index = contacts.firstIndex { $0.contactId == id }
            guard index != nil else {
                return
            }
            contacts.removeAll { $0.contactId == id }
            deleteTableRows(index!)
        }
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
        if searchBarIsEmpty{
            return
        }
        let searchResults = contacts
        let searchItems = splitString(string: searchController.searchBar.text!, by: " ")
        let filteredResult = searchResults.filter { (contact) -> Bool in
            return findMatches(searchItems, contact.firstName) || findMatches(searchItems, contact.lastName) ||
                findMatches(searchItems, contact.phoneNumber) || findMatches(searchItems, contact.email)
        }
        
        self.filteredContacts = filteredResult
        tableView.reloadData()
    }
    
    private func findMatches(_ searchStringItems: [String], _ currentString: String) -> Bool{
        for j in searchStringItems{
            if currentString.lowercased().contains(j){
                return true
            }
        }
        return false
    }
    
    private func splitString(string: String, by: String) -> [String]{
        let thisString = string.lowercased()
        let strippedName = thisString.trimmingCharacters(in: CharacterSet.whitespaces)
        return strippedName.components(separatedBy: " ")
    }
}

extension MainTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contactSearchController.isActive = false
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contactSearchController.isActive = false
        tableView.reloadData()
    }
}

// MARK: ContactsSearchResultDelegate
extension MainTableViewController: ContactsSearchResultDelegate{
    func didSelectRow(_ tableView: UITableView, _ indexPath: IndexPath) {
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
    
    func editActionsForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]? {
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
        delete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [delete,edit]
    }
    
    
}
