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
    var numberOfRowsInSection = 10
    var maxSize = 10
    var isSplited = false
    var currentSection = 0
    
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
        array[0] = getArray(count: maxSize)
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
    
    private func deleteSections(){
        for i in 0..<array.count{
            tableView.deleteSections(IndexSet(arrayLiteral: i), with: .none)
        }
    }
    private func insertSections(){
        for i in 0..<array.count{
            tableView.insertSections(IndexSet(arrayLiteral: i), with: .top)
        }
    }
    
    @IBAction func sortArrayNextButtonPressed(_ sender: UIBarButtonItem) {
        switch sortTypeSC.selectedSegmentIndex {
        case 0:
            moveRowsForInsert()
        case 1:
            
            tableView.beginUpdates()
            if !isSplited{
                deleteSections()
                array = splitArray(array: array)
                countOfSections = array.count
                insertSections()
                if array.count == maxSize{
                    isSplited = true
                }
            }
            else{
                if currentSection >= array.count || currentSection+1 >= array.count{
                    currentSection = 0
                }
                    deleteSections()
                    let arr = mergeArr(leftArr: array[currentSection], rightArr: array[currentSection+1])
                    array.remove(at: currentSection)
                    array.remove(at: currentSection)
                    array.insert(arr, at: currentSection)
                    countOfSections = array.count
                    insertSections()
                    currentSection += 1
                
            }
            tableView.endUpdates()
        default:
            break
        }
        
    }
    
    @IBAction func changeSortType(_ sender: UISegmentedControl) {
        counter = 0
        array = [[]]
        array[0] = getArray(count: maxSize)
        countOfSections = 1
        numberOfRowsInSection = array.count
        currentSection = 0
        isSplited = false
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
        return countOfSections
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
    
    private func mergeArr(leftArr: [Int], rightArr: [Int]) -> [Int]{
        var arr: [Int] = []
        var left = leftArr
        var right = rightArr
        
        left.append(Int.max)
        right.append(Int.max)
        var i = 0
        var j = 0
        let maxSize = leftArr.count + rightArr.count
        for _ in 0..<maxSize{
            if left[i] <= right[j]{
                arr.append(left[i])
                i += 1
            }else{
                arr.append(right[j])
                j += 1
            }
        }
        
        return arr
    }
    
    func splitArray(array: [[Int]]) -> [[Int]]{
        var arr = array
        var a = 0
        while  a < arr.count{
            if arr[a].count < 2{
                a += 1
                continue
            }
            arr = insert(toArray: arr, from: arr[a].split(), at: a)
            a += 2
        }
        return arr
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
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
