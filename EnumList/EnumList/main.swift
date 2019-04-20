//
//  main.swift
//  EnumList
//
//  Created by Vlad on 4/18/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

var list = EnumList<Int>()
list.append(value: 0)
list.append(value: 1)
list.append(value: 2)
list.append(value: 3)

//print(list.getAt(index: 3))
//print(list.getAt(index: 1))
//print(list.getAt(index: 0))
//print(list.getAt(index: 2))

var list2 = EnumList<Int>()
list2.add(value: 0)
list2.add(value: 1)
list2.add(value: 2)
list2.add(value: 3)

print(list2.getAt2(index: 3))
print(list2.getAt2(index: 1))
print(list2.getAt2(index: 0))
print(list2.getAt2(index: 2))
