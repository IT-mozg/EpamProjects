//
//  CellType.swift
//  ContactsTableView
//
//  Created by Vlad on 5/22/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum CellType{
    case image(Presentation)
    case firstName(Presentation)
    case lastName(Presentation)
    case email(Presentation)
    case phone(Presentation)
    case birthday(Presentation)
    case height(Presentation)
    case driverLicenseSwitch(Presentation)
    case note(Presentation)
}
