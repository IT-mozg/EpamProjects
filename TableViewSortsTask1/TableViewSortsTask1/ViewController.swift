//
//  ViewController.swift
//  TableViewSortsTask1
//
//  Created by Vlad on 5/2/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

let cellIdentifier = "cell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var array: [Int] = []
    
    private func getArray(count: Int) -> [Int]{
        var arr: [Int] = []
        var item :Int
        for _ in 0..<count{
            item = Int(arc4random_uniform(20) + 1)
            arr.append(item)
        }
        return arr
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        array = getArray(count: 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(array[indexPath.row])
        return cell
    }
    

    


}

