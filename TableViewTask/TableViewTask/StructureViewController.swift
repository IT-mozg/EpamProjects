//
//  StructureViewController.swift
//  TableViewTask
//
//  Created by Vlad on 4/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class StructureViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var insertLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var removeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var structure: Structure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = structure?.name
        insertLabel.text = structure?.insertion
        selectLabel.text = structure?.selection
        removeLabel.text = structure?.removing
        descLabel.text = structure?.description
    }
}
