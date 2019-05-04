//
//  main.swift
//  Sorts
//
//  Created by Vlad on 4/23/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation
var array : [Int]
 func getArray(count: Int) -> [Int]{
    var arr: [Int] = []
    var k :Int
    for _ in 0..<count{
        k = Int(arc4random_uniform(30) + 1)
        arr.append(k)
    }
    return arr
}
array = getArray(count:16)



func sink(arr:[Int], index: Int, max: Int) -> [Int]{
    var i = index
    var A = arr
    var bigInteger, leftChild, rightChild: Int
    while i < max {
        bigInteger = i
        leftChild = i * 2 + 1
        rightChild = leftChild + 1
        
        if leftChild < max && A[leftChild] > A[bigInteger]{
            bigInteger = leftChild
        }
        if rightChild < max && A[rightChild] > A[bigInteger]{
            bigInteger = rightChild
        }
        
        if i == bigInteger{
            return A
        }
        
        A.swapAt(i, bigInteger)
        i = bigInteger
    }
    return A
}

func buildHeap(array: [Int]) -> [Int]{
    var A = array
  //  print(A)
    var i = Int(floor(Double(A.count / 2))) - 1
    while i >= 0{
        A = sink(arr: A, index: i, max: A.count)
        i -= 1
       // print(A)
    }
    //print(A)
    return A
}
func sortHeap(array: [Int]) -> [Int]{
    var A = buildHeap(array: array)
    var end = A.count - 1
    while end >= 0 {
        A.swapAt(0, end)
        A = sink(arr: A, index: 0, max: end)
        end -= 1
    }
    return A
}

func insertSort(array: [Int], step: Int) -> [Int]{
    var a = array
    var j, bigInteger, x: Int
    for i in 0..<a.count
    {
        bigInteger = i + step
        if bigInteger >= a.count{
            break
        }
        x = a[bigInteger]
        j = bigInteger-step
        while j >= 0 && a[j] > x{
            a[j+step] = a[j]
            j -= step
        }
        a[j+step] = x
    }
    return a
}
func shellSort(array: [Int]) -> [Int]{
    var arr = array
    var step = arr.count/2
    while step > 0 {
        arr = insertSort(array: arr, step: step)
        step /= 2
    }
    return arr
}

print(shellSort(array: array))
