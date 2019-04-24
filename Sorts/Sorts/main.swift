//
//  main.swift
//  Sorts
//
//  Created by Vlad on 4/23/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation
var array : [Int]
 func setArray(N: Int) -> [Int]{
    var arr: [Int] = []
    var k :Int
    for _ in 0..<N{
        k = Int(arc4random_uniform(100) + 1)
        arr.append(k)
    }
    return arr
}
array = setArray(N:100)
func sink(arr:[Int], i: Int, max: Int) -> [Int]{
    var i = i
    var A = arr
    var big_i, childl, childr: Int
    while i < max {
        big_i = i
        childl = i * 2 + 1
        childr = childl + 1
        
        if childl < max && A[childl] > A[big_i]{
            big_i = childl
        }
        if childr < max && A[childr] > A[big_i]{
            big_i = childr
        }
        
        if i == big_i{
            return A
        }
        
        A.swapAt(i, big_i)
        i = big_i
    }
    return A
}

func buildHeap(array: [Int]) -> [Int]{
    var A = array
  //  print(A)
    var i = Int(floor(Double(A.count / 2))) - 1
    while i >= 0{
        A = sink(arr: A, i: i, max: A.count)
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
        A = sink(arr: A, i: 0, max: end)
        end -= 1
    }
    return A
}
print(sortHeap(array: array))
