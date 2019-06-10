//
//  Algorithm.swift
//  TimeSort
//
//  Created by Vlad on 5/30/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

protocol Sortable{
    var title: String {get}
    func sort(array: [Int]) -> [Int]
}
