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
    var isEnabledTextField: Bool = true
    var dataType: DataType?
    var cellType: CellType
    var validation: (()->(Bool))?
    
    init(keyboardType: UIKeyboardType?, placeholder: String?, title: String?, dataType: DataType?, cellType: CellType, validation: (()->(Bool))?) {
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.title = title
        self.dataType = dataType
        self.cellType = cellType
        self.validation = validation
    }
    
    init (keyboardType: UIKeyboardType?, placeholder: String?, title: String?,isEnabledTextField: Bool, dataType: DataType?, cellType: CellType, validation: (()->(Bool))?){
        self.init(keyboardType: keyboardType, placeholder: placeholder, title: title, dataType: dataType, cellType: cellType, validation: validation)
        self.isEnabledTextField = isEnabledTextField
    }
    
    mutating func updateDataType(_ dataType: DataType){
        self.dataType = dataType
    }
}
