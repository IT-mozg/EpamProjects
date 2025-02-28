//
//  ContactsSearchResultTableViewController.swift
//  ContactsTableView
//
//  Created by Vlad on 5/14/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ContactsSearchResultTableViewController: UITableViewController {
    weak var delegate: ContactsSearchResultDelegate?
    var searchString: String!
    
    var filteredContacts = [Contact](){
        didSet{
            backgroundView.isHidden = !filteredContacts.isEmpty
            tableView.reloadData()
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundView
        backgroundView.isHidden = !filteredContacts.isEmpty
        tableView.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell")!
        cell.textLabel?.attributedText = findMostSimilarString(contact: filteredContacts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRow(tableView, indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return delegate?.editActionsForRow(tableView, indexPath)
    }
}

private extension ContactsSearchResultTableViewController{
     func findMostSimilarString(contact: Contact) -> NSAttributedString?{
        let searchItems = searchString.splitString(separator: " ")
        let findMatches = SearchStringHelper.findMatches
        if findMatches(searchItems, contact.phoneNumber){
            return replaceMatches(searchItems, contact.phoneNumber!)
        }
        if findMatches(searchItems, contact.firstName){
            return replaceMatches(searchItems, contact.firstName!)
        }
        if findMatches(searchItems, contact.lastName){
            return replaceMatches(searchItems, contact.lastName!)
        }
        if findMatches(searchItems, contact.email){
            return replaceMatches(searchItems, contact.email!)
        }
        return nil
    }
    
     func replaceMatches(_ searchStringItems: [String], _ currentString: String) -> NSMutableAttributedString{
        let attribute = NSMutableAttributedString(string: currentString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        for currentSearchString in searchStringItems{
            if currentString.lowercased().contains(currentSearchString){
                let rangeString = attribute.string.lowercased().range(of: currentSearchString)!
                let range = NSRange(rangeString, in: attribute.string)
                attribute.setAttributes([.foregroundColor: UIColor.black], range: range)
            }
        }
        return attribute
    }
}
