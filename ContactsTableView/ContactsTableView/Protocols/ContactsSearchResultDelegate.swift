//
//  Contact.swift
//  ContactsTableView
//
//  Created by Vlad on 5/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

protocol ContactsSearchResultDelegate: class{
    func didSelectRow(_ tableView: UITableView, _ indexPath: IndexPath)
    func editActionsForRow(_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]?
}
