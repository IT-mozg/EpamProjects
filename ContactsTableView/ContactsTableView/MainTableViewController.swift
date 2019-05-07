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
        checkContacts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    private func checkContacts(){
        if contacts.isEmpty{
            backgroundView.isHidden = false
            tableView.backgroundView = backgroundView
        }
        else{
            backgroundView.isHidden = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as! MainContactTableViewCell
        
        cell.firstNameLabel.text = contacts[indexPath.row].firstName
        cell.lastNameLabel.text = contacts[indexPath.row].lastName
        cell.contactImage?.image = contacts[indexPath.row].imagePhoto
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact"{
            if let destination = segue.destination as? NewContactViewController{
                destination.delegate = self
            }
        }
    }
   

}

//MARK: TableViewControllerDelegate
extension MainTableViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ContactInfoViewController") as? ContactInfoViewController{
            controller.indexPath = indexPath
            controller.delegate = self
            controller.dataSource = self
            controller.contact = contacts[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteRowContact(at: indexPath)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewContactViewController") as? NewContactViewController{
                controller.editingContact = self.contacts[indexPath.row]
                controller.dataSource = self
                controller.indexPath = indexPath
                self.navigationController?.pushViewController(controller, animated: true)
                //self.present(controller, animated: true, completion: nil)
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        edit.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return [delete,edit]
    }
    
    internal func updateContact(contact: Contact){
        
    }
    
    private func deleteRowContact(at indexPath: IndexPath){
        self.contacts.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        checkContacts()
    }
}

// MARK: NewContactViewControllerDelegate
extension MainTableViewController: NewContactViewControllerDelegate{
    func addNewContact(newItem: Contact) {
        let count = contacts.count
        contacts.append(newItem)
        let indexPath = IndexPath(item: count, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
}

extension MainTableViewController: NewContactViewControllerDataCource{
    func updateContact(updatedContact: Contact, at indexPath: IndexPath) {
        contacts[indexPath.row] = updatedContact
        tableView.reloadData()
    }
}

// MARK: ContactInfoViewControllerDelegate
extension MainTableViewController: ContactInfoViewControllerDelegate{
    func deleteContact(at indexPath: IndexPath) {
        deleteRowContact(at: indexPath)
    }
}
