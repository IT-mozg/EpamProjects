//
//  TableViewController.swift
//  TableViewSortsTask1
//
//  Created by Vlad on 5/2/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    @IBOutlet weak var nextButtonItem: UIBarButtonItem!
    @IBOutlet weak var sortTypeSC: UISegmentedControl!
    
    var array: [[Int]] = [[]]
    var sortTypesArray = ["Insertion", "Merge"]
    var counter = 0
    var countOfSections = 1
    var numberOfRowsInSection = 0
    
    private func getArray(count: Int) -> [Int]{
        var arr: [Int] = []
        var item :Int
        for _ in 0..<count{
            item = Int(arc4random_uniform(20) + 1)
            arr.append(item)
        }
        return arr
    }
    
    private func setSegmentControlConfiguration(){
        for i in 0..<sortTypesArray.count{
            sortTypeSC.setTitle(sortTypesArray[i], forSegmentAt: i)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        array[0] = getArray(count: 10)
        numberOfRowsInSection = array.count
        nextButtonItem.title = "Next"
        setSegmentControlConfiguration()
    }
    
    private func moveRowsForInsert(){
        guard counter < array[0].count else {return}
        guard let (old, new) = insert() else{return}
        let indexPath = IndexPath(item: old, section: 0)
        let toIndexPath = IndexPath(item: new, section: 0)
        let from = IndexPath(item: new-1, section: 0)
        
        tableView.moveRow(at: indexPath, to: toIndexPath)
        tableView.moveRow(at: from, to: indexPath)
    }
    
    private func moveRowsForMergeSort(){
        
    }
    
    @IBAction func sortArrayNextButtonPressed(_ sender: UIBarButtonItem) {
        switch sortTypeSC.selectedSegmentIndex {
        case 0:
            moveRowsForInsert()
        case 1:
            let indexSet = IndexSet(arrayLiteral: 7)
            tableView.insertSections(indexSet, with: .bottom)
        default:
            break
        }
        
    }
    
    @IBAction func changeSortType(_ sender: UISegmentedControl) {
        counter = 0
        array = [[]]
        array[0] = getArray(count: 10)
        countOfSections = 1
        numberOfRowsInSection = array.count
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = String(array[indexPath.section][indexPath.row])
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    
}

//MARK: sorts
extension TableViewController{
    private func insert() -> (old: Int, new: Int)?{
        var j, x: Int
        j = 0
        var tmp: Int
        while counter < array[0].count{
            x = array[0][counter]
            j = counter-1
            while j >= 0{
                if array[0][j] > x{
                    tmp = array[0][j+1]
                    array[0][j+1] = array[0][j]
                    array[0][j] = tmp
                    counter = j
                    return (old: j, new: j+1)
                }
                j -= 1
            }
            counter += 1
        }
        return nil
    }
    private func mergeSort(array: [[Int]], _ p: Int, _ r: Int, _ section: Int) -> [[Int]]{
        var arr = array
        //if p >= r {return arr}
        if array[section].count <= 2 {
            return array
        }
        let q = (r+p)/2
        
        arr = splitArray(array: arr, at: section)
        tableView.reloadData()
        
        arr = mergeSort(array: arr, p, q, section)
        arr = mergeSort(array: arr, q+1, r, section+1)
        return arr
    }
    
    private func merge(array: [Int], _ p: Int, _ q: Int, _ r: Int) -> [Int]{
        var arr = array
        let n1 = q-p+1
        let n2 = r - q
        var left = Array(repeating: 0, count: n1+1)
        var right = Array(repeating: 0, count: n2+1)
        
        for i in 1...n1{
            left[i-1] = arr[p+i-1]
        }
        for i in 1...n2{
            right[i-1] = arr[q+i]
        }
        left[n1] = Int.max
        right[n2] = Int.max
        var i = 0
        var j = 0
        for k in p...r{
            if left[i] <= right[j]{
                arr[k] = left[i]
                i += 1
            }else{
                arr[k] = right[j]
                j += 1
            }
        }
        
        return arr
    }
    
    func splitArray(array: [[Int]], at: Int) -> [[Int]]{
        let divided = array[at].divideInHalf()
        return insert(toArray: array, from: divided, at: at)
    }
    
    func insert(toArray: [[Int]], from: [[Int]], at: Int) -> [[Int]]{
        var a = toArray
        a.remove(at: at)
        var index = from.count-1
        while index >= 0{
            a.insert(from[index], at: at)
            index -= 1
        }
        return a
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func divideInHalf() -> [[Element]]{
        var arr: [[Element]] = [[],[]]
        let count = self.count
        for i in 0..<count{
            if i < count/2{
                arr[0].append(self[i])
            }else{
                arr[1].append(self[i])
            }
        }
        return arr
    }
}
