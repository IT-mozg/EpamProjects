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
    
    var structure: Structure = Structure(name: "", insertion: "", selection: "", removing: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = structure.name
        insertLabel.text = structure.insertion
        selectLabel.text = structure.selection
        removeLabel.text = structure.removing
        descLabel.text = structure.description
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
