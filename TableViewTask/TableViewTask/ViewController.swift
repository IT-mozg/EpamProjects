//
//  ViewController.swift
//  TableViewTask
//
//  Created by Vlad on 4/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var structures = [Structure(name: "some name1", insertion: "insertion1", selection: "selection1", removing: "removing1", description: "desc"),
                      Structure(name: "some name2", insertion: "insertion1", selection: "selection1", removing: "removing1", description: "desc"),
                      Structure(name: "some name3", insertion: "insertion1", selection: "selection1", removing: "removing1", description: "desc")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return structures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            //UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = structures[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = storyboard?.instantiateViewController(withIdentifier: "StructureViewController") as! StructureViewController
        dvc.structure = structures[indexPath.row]
        self.navigationController?.pushViewController(dvc, animated: true)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail"{
//            if let indexPath = self.tableView.indexPathForSelectedRow{
//                let dvc = segue.destination as! StructureViewController
//                dvc.structure = structures[indexPath.row]
//            }
//        }
//    }
    
}

