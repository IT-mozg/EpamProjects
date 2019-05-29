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
            checkNumberOfRows()
            checkNumberOfContacts()
        }
    }
    private var contactSectionTitles = [String]()
    private var filteredContacts: [Contact] = []{
        didSet{
            searchResultController?.filteredContacts = filteredContacts
            searchResultController?.searchString = contactSearchController.searchBar.text
        }
    }
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
        setupUI()
        unarchiveContacts()
        checkNumberOfRows()
        checkNumberOfContacts()
    }
    
    // MARK: IBActions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func addNewButtonPressed(_ sender: Any) {
        addButtonItemPressed()
    }
}

    //MARK: private help methods
private extension MainTableViewController{
    private func checkNumberOfContacts(){
        contactSearchController.searchBar.isHidden = contactDictionary.values.flatMap({$0}).count <= ContactDefault.contactSearchBarShowAt
    }
    
    private func unarchiveContacts(){
        let userDefaults = UserDefaults.standard
        do{
            if let decoded = userDefaults.data(forKey: "contacts"){
                contactDictionary = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [String: [Contact]]
                reloadSectionTitles()
            }
        }catch {
            print(error)
        }
    }
    
    private func setupUI(){
        tableView.backgroundView = backgroundView
        tableView.tableFooterView = UIView(frame: .zero)
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
    }
    
    private func reloadSectionTitles(){
        contactSectionTitles = [String](contactDictionary.keys)
        contactSectionTitles = contactSectionTitles.sorted(by: <)
    }
    
    private func updateUserDefaults(){
        let userDefaults = UserDefaults.standard
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
    
    private func checkNumberOfRows(){
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
    
    private func goToNewContactController(indexPath: IndexPath){
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewContactViewController") as? NewContactViewController{
            controller.contactBeforeUpdate = getContact(at: indexPath)
            controller.update = {[unowned self] updatedContact in
                self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
            }
            controller.delete = {[unowned self] in
                self.deleteContact(at: indexPath)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func getContact(at indexPath: IndexPath) -> Contact?{
        if self.isFiltering{
            return self.filteredContacts[indexPath.row]
        }
        let contactKey = self.contactSectionTitles[indexPath.section]
        if let contactValues = self.contactDictionary[contactKey]{
            return contactValues[indexPath.row]
        }
        return nil
    }
    
    private func goToContactInfoController(indexPath: IndexPath){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ContactInfoViewController") as? ContactInfoViewController{
            controller.update = {[unowned self] updatedContact in
                self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
            }
            controller.delete = {[unowned self] in
                self.deleteContact(at: indexPath)
            }
            controller.contact = getContact(at: indexPath)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: Deleting contacts
extension MainTableViewController{
    private func deleteContact(at indexPath: IndexPath){
        if isFiltering{
            deleteIfFiltering(indexPath: indexPath)
        }
        else{
            deleteIfNotFiltering(indexPath: indexPath)
        }
    }
    
    private func deleteIfNotFiltering(indexPath: IndexPath){
        let contactKey = contactSectionTitles[indexPath.section]
        if var contactValues = contactDictionary[contactKey]{
            let id = contactValues[indexPath.row].contactId
            guard let index = contactValues.firstIndex(where: { (contact) in return contact.contactId == id})else{
                return
            }
            guard let section = contactSectionTitles.firstIndex(of: contactKey)else {return}
            contactValues.removeAll{$0.contactId == id}
            let isLast = checkIsEmptyArray(contactKey: contactKey, contactValues: contactValues)
            deleteTableRows(index, section, isLast)
        }
    }
    
    private func deleteIfFiltering(indexPath: IndexPath) {
        let id = filteredContacts[indexPath.row].contactId
        guard let index = filteredContacts.firstIndex(where: { $0.contactId == id }) else { return }
        let contactKey = contactSectionTitles[indexPath.section]
        filteredContacts.removeAll { $0.contactId == id }
        var isLast = false
        guard let section = contactSectionTitles.firstIndex(of: contactKey) else { return }
        if var contactValues = contactDictionary[contactKey]{
            contactValues.removeAll{$0.contactId == id}
            isLast = checkIsEmptyArray(contactKey: contactKey, contactValues: contactValues)
        }
        deleteTableRows(index, section, isLast)
    }
    
    private func deleteTableRows(_ row: Int,_ section: Int = 0,_ isLast: Bool = false){
        tableView.beginUpdates()
        
        let indexPath = IndexPath(item: row, section: section)
        self.tableView.deleteRows(at: [indexPath], with: .top)
        
        if isLast{
            let indexSet = IndexSet(arrayLiteral: section)
            tableView.deleteSections(indexSet, with: .automatic)
        }
        tableView.endUpdates()
    }
}

//MARK: Updating contacts
extension MainTableViewController{
    private func updateContact(updatedContact: Contact, indexPath: IndexPath){
        let name = updatedContact.contactName
        let updatedContactsKey = String(name.prefix(1))
        let oldContactsKey = contactSectionTitles[indexPath.section]
        if oldContactsKey == updatedContactsKey{
            if var contactValues = contactDictionary[updatedContactsKey]{
                contactValues[indexPath.row] = updatedContact
                contactDictionary[updatedContactsKey] = contactValues
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        else{
            deleteContact(at: indexPath)
            addNewContact(newItem: updatedContact)
        }
    }
}

// MARK: - Table view DataSource
extension MainTableViewController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRow(tableView, indexPath)
    }
}

// MARK: NewContactViewControllerDelegate
extension MainTableViewController: NewContactViewControllerDelegate{
    func addNewContact(newItem: Contact) {
        tableView.beginUpdates()
        let name = newItem.contactName
        let key = String(name.prefix(1))
        let row = contactDictionary[key]?.count
        var section = contactSectionTitles.firstIndex(of: key)
        if var contactValue = contactDictionary[key]{
            contactValue.append(newItem)
            contactDictionary[key] = contactValue
        }
        else{
            contactDictionary[key] = [newItem]
            reloadSectionTitles()
            section = contactSectionTitles.firstIndex(of: key)
            let indexSet = IndexSet(arrayLiteral: section!)
            tableView.insertSections(indexSet, with: .none)
        }
        let indexPath = IndexPath(item: row ?? 0, section: section!)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}

// MARK: Search
extension MainTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty{
            return
        }
        let searchResults = contactDictionary.values.flatMap{$0}
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
        goToContactInfoController(indexPath: indexPath)
        
    }
    
    func editActionsForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteContact(at: indexPath)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.goToNewContactController(indexPath: indexPath)
        }
        delete.backgroundColor = ContactDefault.deleteColor
        edit.backgroundColor = ContactDefault.editColor
        return [delete,edit]
    }
}
