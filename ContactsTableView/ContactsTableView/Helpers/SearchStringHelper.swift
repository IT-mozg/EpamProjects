//
//  SearchStringHelper.swift
//  ContactsTableView
//
//  Created by Vlad on 5/16/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class SearchStringHelper{
    static func findMatches(_ searchStringItems: [String], _ currentString: String?) -> Bool{
        for currentSearchStringItem in searchStringItems{
            if currentString?.lowercased().contains(currentSearchStringItem) ?? false{
                return true
            }
        }
        return false
    }
}
