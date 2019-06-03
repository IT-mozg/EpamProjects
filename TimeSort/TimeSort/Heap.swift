//
//  HeapSort.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class Heap : Sortable{
    var title: String{
        get{
            return "Heap"
        }
    }
    
    func sort(array: [Int]) -> [Int] {
        return sortHeap(array: array)
    }
    
    private func sink(array:[Int], index: Int, max: Int) -> [Int]{
        var index = index
        var arr = array
        var bigInteger, leftChild, rightChild: Int
        while index < max {
            bigInteger = index
            leftChild = index * 2 + 1
            rightChild = leftChild + 1
            
            if leftChild < max && arr[leftChild] > arr[bigInteger]{
                bigInteger = leftChild
            }
            if rightChild < max && arr[rightChild] > arr[bigInteger]{
                bigInteger = rightChild
            }
            
            if index == bigInteger{
                return arr
            }
            
            arr.swapAt(index, bigInteger)
            index = bigInteger
        }
        return arr
    }
    
    func buildHeap(array: [Int]) -> [Int]{
        var arr = array
        var index = Int(floor(Double(arr.count / 2))) - 1
        while index >= 0{
            arr = sink(array: arr, index: index, max: arr.count)
            index -= 1
        }
        return arr
    }
    func sortHeap(array: [Int]) -> [Int]{
        var arr = buildHeap(array: array)
        var end = arr.count - 1
        while end >= 0 {
            arr.swapAt(0, end)
            arr = sink(array: arr, index: 0, max: end)
            end -= 1
        }
        return arr
    }
}
