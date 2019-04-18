//
//  main.swift
//  EnumList
//
//  Created by Vlad on 4/18/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

var list = EnumList<Int>()
list = list.append(value: 0)!

list = list.append(value: 1)!

list = list.append(value: 2)!

list = list.append(value: 3)!


print(list.getAt(index: 1))
print(list.getAt(index: 0))
