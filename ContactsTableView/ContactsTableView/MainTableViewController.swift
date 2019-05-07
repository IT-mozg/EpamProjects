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
    var contacts: [Contact] = [
        Contact(firstName: "Stive", lastName: "Jobs", email: "asd@asd.asd", phoneNumber: "+380935942213", imagePhoto: "avatar"),
        Contact(firstName: "Stive", lastName: "Jobs", email: "asd@asd.asd", phoneNumber: "+380935942213", imagePhoto: "avatar"),
        Contact(firstName: "Stive", lastName: "Jobs", email: "asd@asd.asd", phoneNumber: "+380935942213", imagePhoto: "avatar"),
        Contact(firstName: "Stive", lastName: "Jobs", email: "asd@asd.asd", phoneNumber: "+380935942213", imagePhoto: "avatar"),
        Contact(firstName: "Stive", lastName: "Jobs", email: "asd@asd.asd", phoneNumber: "+380935942213", imagePhoto: "avatar")]

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        if contacts.isEmpty{
            backgroundView.isHidden = false
            tableView.backgroundView = backgroundView
        }
        else{
            backgroundView.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
        cell.contactImage?.image = UIImage(named: contacts[indexPath.row].imagePhoto)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewContact"{
            if let destination = segue.destination as? NewContactViewController{
                destination.delegate = self
            }
        }
    }
   

}

extension MainTableViewController: NewContactViewControllerDelegate{
    func addNewContact(_ contactController: NewContactViewController, newItem: Contact) {
        contactController.delegate = self
        let count = contacts.count
        contacts.append(newItem)
        let indexPath = IndexPath(item: count, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    
}
