//
//  Presentation.swift
//  ContactsTableView
//
//  Created by Vlad on 5/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

struct Presentation{
    let keyboardType: UIKeyboardType?
    let placeholder: String?
    let title: String?
    var dataType: DataType?
    var cellType: CellType
    var validation: (()->(Bool))?
    
    mutating func updateDataType(_ dataType: DataType){
        self.dataType = dataType
    }
}
