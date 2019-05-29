//
//  NewContactViewControllerDelegate.swift
//  ContactsTableView
//
//  Created by Vlad on 5/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

protocol NewContactViewControllerDelegate: class{
    func addNewContact(newItem: Contact)
}
