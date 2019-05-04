//
//  ViewController.swift
//  TableViewTask
//
//  Created by Vlad on 4/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var structures = [Structure(name: "Array", insertion: "O(n)",
                                selection: "O(n)", removing: "O(n)", description: "In computer science, an array data structure, or simply an array, is a data structure consisting of a collection of elements (values or variables), each identified by at least one array index or key. An array is stored such that the position of each element can be computed from its index tuple by a mathematical formula.[1][2][3] The simplest type of data structure is a linear array, also called one-dimensional array."),
                      Structure(name: "List", insertion: "O(1)",
                                selection: "O(n)", removing: "O(1)", description: "In computer science, a Linked list is a linear collection of data elements, whose order is not given by their physical placement in memory. Instead, each element points to the next. It is a data structure consisting of a collection of nodes which together represent a sequence. In its most basic form, each node contains: data, and a reference (in other words, a link) to the next node in the sequence. "),
                      Structure(name: "HashTable", insertion: "O(1)",
                                selection: "O(1)", removing: "O(1)", description: "In computing, a hash table (hash map) is a data structure that implements an associative array abstract data type, a structure that can map keys to values. A hash table uses a hash function to compute an index into an array of buckets or slots, from which the desired value can be found."),
                      Structure(name: "Dictionary", insertion: "O(1)",
                              selection: "O(1)", removing: "O(1)", description: "A dictionary is a general-purpose data structure for storing a group of objects. A dictionary has a set of keys and each key has a single associated value. When presented with a key, the dictionary will return the associated value."),
                      Structure(name: "BinaryTree", insertion: "O(log(n))",
                              selection: "O(log(n))", removing: "O(log(n))", description: "In computer science, a binary tree is a tree data structure in which each node has at most two children, which are referred to as the left child and the right child. A recursive definition using just set theory notions is that a (non-empty) binary tree is a tuple (L, S, R), where L and R are binary trees or the empty set and S is a singleton set. Some authors allow the binary tree to be the empty set as well")]

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

