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

    //MARK: Properties
    private var contactDictionary = [String: [Contact]](){
        didSet{
            updateUserDefaults()
        }
    }
    private var contactSectionTitles = [String]()
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
    
    //MARK: IBOutlets
    @IBOutlet weak var backgroundView: UIView!
    
    //MARK: Notify methods
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
        do{
            if let decoded = userDefaults.data(forKey: "contacts"){
                contactDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [String: [Contact]]
                contactSectionTitles = [String](contactDictionary.keys)
                contactSectionTitles = contactSectionTitles.sorted(by: <)
            }
        }catch {
            print(error)
        }
        checkUpdates()
    }
    
    // MARK: IBActions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        navigationItem.leftBarButtonItem!.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func addNewButtonPressed(_ sender: Any) {
        addButtonItemPressed()
    }
    
    //MARK: private help methods
    private func contactDictionaryToArray() -> [Contact]{
        var result = [Contact]()
        for contacts in contactDictionary.values{
            for item in contacts{
                result.append(item)
            }
        }
        return result
    }
    
    private func updateUserDefaults(){
        do{
            let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: contactDictionary, requiringSecureCoding: false)
            userDefaults.set(encodedData, forKey: "contacts")
            userDefaults.synchronize()
        }catch{
            print(error)
        }
    }

    @objc private func addButtonItemPressed(){
        if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactNavigationController") as? UINavigationController{
            if let viewController = navigationController.viewControllers.first as? NewContactViewController{
                viewController.delegate = self
                self.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    private func checkUpdates(){
        backgroundView.isHidden = !contactDictionary.isEmpty
        if !contactDictionary.isEmpty{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemPressed))
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonPressed))
        }
        else{
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func checkIsEmptyArray(contactKey: String, contactValues: [Contact]) -> Bool{
        let isLast = contactValues.isEmpty
        contactDictionary[contactKey] = contactValues
        if isLast{
            contactDictionary.removeValue(forKey: contactKey)
            contactSectionTitles.removeAll{$0 == contactKey}
        }
        return isLast
    }
}

// MARK: Deleting contacts
extension MainTableViewController{
    private func deleteRowContact(_ indexPath: IndexPath){
        if isFiltering{
            deleteIfFiltering(indexPath: indexPath)
        }
        else{
            deleteIfNotFiltering(indexPath: indexPath)
        }
        checkUpdates()
    }
    
    private func deleteIfNotFiltering(indexPath: IndexPath){
        let contactKey = contactSectionTitles[indexPath.section]
        if var contactValues = contactDictionary[contactKey]{
            let id = contactValues[indexPath.row].contactId
            let index = contactValues.firstIndex { $0.contactId == id }
            guard index != nil else {
                return
            }
            let section = contactSectionTitles.firstIndex(of: contactKey)!
            contactValues.removeAll{$0.contactId == id}
            let isLast = checkIsEmptyArray(contactKey: contactKey, contactValues: contactValues)
            deleteTableRows(index!, section, isLast)
        }
    }
    
    private func deleteIfFiltering(indexPath: IndexPath) {
        let id = filteredContacts[indexPath.row].contactId
        let index = filteredContacts.firstIndex { $0.contactId == id }
        let contactKey = contactSectionTitles[indexPath.section]
        guard index != nil else {
            return
        }
        filteredContacts.removeAll { $0.contactId == id }
        var isLast = false
        let section = contactSectionTitles.firstIndex(of: contactKey)!
        if var contactValues = contactDictionary[contactKey]{
            contactValues.removeAll{$0.contactId == id}
            isLast = checkIsEmptyArray(contactKey: contactKey, contactValues: contactValues)
        }
        deleteTableRows(index!, section, isLast)
    }
    
    private func deleteTableRows(_ id: Int,_ section: Int = 0,_ isLast: Bool = false){
        tableView.beginUpdates()
        
        let indexPath = IndexPath(item: id, section: section)
        self.tableView.deleteRows(at: [indexPath], with: .top)
        
        if isLast{
            for i in 0...contactSectionTitles.count{
                let indexSet = IndexSet(arrayLiteral: i)
                tableView.deleteSections(indexSet, with: .none)
            }
            for i in 0..<contactSectionTitles.count{
                let indexSet = IndexSet(arrayLiteral: i)
                tableView.insertSections(indexSet, with: .none)
            }
        }
        tableView.endUpdates()
    }
}

//MARK: Updating contacts
extension MainTableViewController{
    private func updateContact(updatedContact: Contact, indexPath: IndexPath){
        let updatedContactsKey = String(updatedContact.firstName.prefix(1))
        let oldContactsKey = contactSectionTitles[indexPath.section]
        if oldContactsKey == updatedContactsKey{
            if var contactValues = contactDictionary[updatedContactsKey]{
                contactValues[indexPath.row] = updatedContact
                contactDictionary[updatedContactsKey] = contactValues
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else{
            addNewContact(newItem: updatedContact)
            deleteRowContact(indexPath)
        }
    }
}

// MARK: - Table view data source
extension MainTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkUpdates()
        let contactKey = contactSectionTitles[section]
        if let contactValues = contactDictionary[contactKey]{
            return contactValues.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as! MainContactTableViewCell
        let contactKey = contactSectionTitles[indexPath.section]
        if let contactValues = contactDictionary[contactKey]{
            cell.updateWith(model: contactValues[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactSectionTitles[section]
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: TableViewControllerDelegate
extension MainTableViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(tableView, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRow(tableView, indexPath)
    }
}

// MARK: NewContactViewControllerDelegate
extension MainTableViewController: NewContactViewControllerDelegate{
    func addNewContact(newItem: Contact) {
        let key = String(newItem.firstName.prefix(1))
        if var contactValue = contactDictionary[key]{
            contactValue.append(newItem)
            contactDictionary[key] = contactValue
        }
        else{
            contactDictionary[key] = [newItem]
        }
        contactSectionTitles = [String](contactDictionary.keys)
        contactSectionTitles = contactSectionTitles.sorted(by: {$0 < $1})
        tableView.reloadData()
    }
}

// MARK: Search
extension MainTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty{
            return
        }
        let searchResults = contactDictionaryToArray()
        let searchItems = searchController.searchBar.text!.splitString(separator: " ")
        filteredContacts = searchResults.filter { (contact) -> Bool in
            let findMatches = SearchStringHelper.findMatches
            return findMatches(searchItems, contact.firstName) || findMatches(searchItems, contact.lastName) ||
                findMatches(searchItems, contact.phoneNumber) || findMatches(searchItems, contact.email)
        }
        tableView.reloadData()
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
                let contactKey = contactSectionTitles[indexPath.section]
                    if let contactValues = contactDictionary[contactKey]{
                    controller.contact = contactValues[indexPath.row]
                }
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
                        let contactKey = self.contactSectionTitles[indexPath.section]
                        if let contactValues = self.contactDictionary[contactKey]{
                            controller.editingContact = contactValues[indexPath.row]
                        }
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
