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
    var contacts: [Contact] = []

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundView
        let us = UserDefaults.standard
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: contacts)
//        us.set(encodedData, forKey: "contacts")
//        us.synchronize()
        let decoded = us.data(forKey: "contacts")
        let decodedContacts = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Contact]
        contacts = decodedContacts
        contacts.first?.firstName = "123"
    }
    
    private func checkContacts(){
        tableView.backgroundView = backgroundView
        backgroundView.isHidden = !contacts.isEmpty
        if !contacts.isEmpty{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonItemPressed))
        }
        else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
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
        }
        else{
            navigationItem.rightBarButtonItem = nil
        }
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ContactInfoViewController") as? ContactInfoViewController{
            controller.update = {[unowned self] updatedContact in
                self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
            }
            controller.delete = {[unowned self] in
                self.deleteRowContact(indexPath: indexPath)
            }
            controller.contact = contacts[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteRowContact(indexPath: indexPath)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewContactNavigationController") as? UINavigationController{
                if let controller = navigationController.viewControllers.first as? NewContactViewController{
                    controller.editingContact = self.contacts[indexPath.row]
                    controller.update = {[unowned self] updatedContact in
                        self.updateContact(updatedContact: updatedContact, indexPath: indexPath)
                    }
                    controller.delete = {[unowned self] in
                        self.deleteRowContact(indexPath: indexPath)
                    }
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return [delete,edit]
    }
    
    private func deleteRowContact(at id: String){
        let index = contacts.firstIndex { $0.contactId == id }
        guard index != nil else {
            return
        }
        let indexPath = IndexPath(item: index!, section: 0)
        self.contacts.removeAll { $0.contactId == id }
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    private func deleteRowContact(indexPath: IndexPath){
        contacts.remove(at: indexPath.row)
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
    }
}
