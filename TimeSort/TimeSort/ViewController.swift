//
//  ViewController.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var algorithms = [SortResultManager]()
    private var dataArrayCells = [[String]]()
    private var progressCounter: Float = 0.0{
        didSet {
            print(progressCounter)
            DispatchQueue.main.async {
                self.progressView.setProgress(self.progressCounter, animated: true)
            }
            if progressCounter >= 0.98{
                self.refreshBarButtonItem.isEnabled = true
            }
        }
    }
    private var counter: Float{
        let algCount = algorithms.count
        let numberOfArrays = algorithms.first!.arraysToSort.count
        return Float(1) / Float(algCount * numberOfArrays)
    }
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupArrays()
        setupCellData()
    }
    @IBAction func refreshBarButtonPressed(_ sender: UIBarButtonItem) {
        progressCounter = 0.0
        refreshBarButtonItem.isEnabled = false
        sortAllArrays()
    }
    
    private func setupCellData(){
        for alg in algorithms{
            dataArrayCells.append(alg.getDefaultStringResult())
        }
    }

    private func sortAllArrays(){
        var result = 0.0
        let algorithms = self.algorithms
        let queue = DispatchQueue.global(qos: .utility)
        for alg in 0..<algorithms.count{
            queue.async {
                for array in 0..<algorithms[alg].arraysToSort.count{
                        result = algorithms[alg].sortType.getAverageTimeOfSort(array: algorithms[alg].arraysToSort[array].resultArray, times: 50)
                        self.dataArrayCells[alg][array] = "\(algorithms[alg].arraysToSort[array].arrayType) - \(algorithms[alg].arraysToSort[array].count.rawValue): \(NSString(format: "%.5f",  -result))"
                        self.progressCounter += self.counter
                        DispatchQueue.main.async {
                            self.tableView.reloadRows(at: [IndexPath(item: array, section: alg)], with: .none)
                        }
                }
            }
        }
    }
    
    private func setupArrays(){
        var array = [ArrayToSort]()
        array.append(ArrayToSort(arrayType: .random, count: .oneTones))
        array.append(ArrayToSort(arrayType: .random, count: .fourTones))
        array.append(ArrayToSort(arrayType: .random, count: .eightTones))
        array.append(ArrayToSort(arrayType: .ascending, count: .oneTones))
        array.append(ArrayToSort(arrayType: .ascending, count: .fourTones))
        array.append(ArrayToSort(arrayType: .ascending, count: .eightTones))
        array.append(ArrayToSort(arrayType: .descendicg, count: .oneTones))
        array.append(ArrayToSort(arrayType: .descendicg, count: .fourTones))
        array.append(ArrayToSort(arrayType: .descendicg, count: .eightTones))
        array.append(ArrayToSort(arrayType: .partly, count: .oneTones))
        array.append(ArrayToSort(arrayType: .partly, count: .fourTones))
        array.append(ArrayToSort(arrayType: .partly, count: .eightTones))
        setupAlgorithm(array: array)
    }
    
    private func setupAlgorithm(array: [ArrayToSort]){
        algorithms.append(SortResultManager(sortType: .select, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .insert, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .shell, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .heap, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .merge, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .quick, arraysToSort: array))
        algorithms.append(SortResultManager(sortType: .bubble, arraysToSort: array))
    }
}

extension ViewController: UITableViewDelegate{
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return algorithms[section].sortType.rawValue
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return algorithms.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArrayCells[section].count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataArrayCells[indexPath.section][indexPath.row]
        return cell
    }
    
}
