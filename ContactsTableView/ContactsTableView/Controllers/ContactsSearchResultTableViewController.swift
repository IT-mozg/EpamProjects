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
            tableView.reloadData()
        }
    }
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        backgroundView.isHidden = !filteredContacts.isEmpty
        tableView.backgroundView = backgroundView
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
    
    private func findMostSimilarString(contact: Contact) -> NSAttributedString?{
        let searchItems = searchString.splitString(separator: " ")
        let findMatches = SearchStringHelper.findMatches
        if findMatches(searchItems, contact.phoneNumber){
            return replaceMatches(searchItems, contact.phoneNumber)
        }
        if findMatches(searchItems, contact.firstName){
            return replaceMatches(searchItems, contact.firstName)
        }
        if findMatches(searchItems, contact.lastName){
            return replaceMatches(searchItems, contact.lastName)
        }
        if findMatches(searchItems, contact.email){
            return replaceMatches(searchItems, contact.email)
        }
        return nil
    }
    
    private func replaceMatches(_ searchStringItems: [String], _ currentString: String) -> NSMutableAttributedString?{
        var attribute: NSMutableAttributedString?
        attribute = NSMutableAttributedString(string: currentString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        for j in searchStringItems{
            if currentString.lowercased().contains(j){
                let rangeString = attribute?.string.lowercased().range(of: j)
                let range = NSRange(rangeString!, in: attribute!.string)
                attribute?.setAttributes([.foregroundColor: UIColor.black], range: range)
            }
        }
        return attribute
    }
}
