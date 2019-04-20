//
//  main.swift
//  Task3
//
//  Created by Vlad on 4/20/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

let students = ["stud1","stud2","stud3","stud4","stud5",
                "stud6","stud7","stud8","stud9","stud10"]

let monday = ["stud1","stud2","stud5","stud6","stud7"]
let tuesday = ["stud1","stud3","stud6","stud8","stud10","stud5"]
let wednesday = ["stud1","stud3","stud7","stud9","stud10","stud2"]

let journal = ["monday" : monday, "tuesday": tuesday, "wednesday": wednesday]
func isPresent(stud: String, day: [String]) -> Bool{
    for s in day{
        if s == stud{
            return true
        }
    }
    return false
}

func presentThreeDays() -> [String]{
    var stud: [String] = []
    for m in monday{
        if isPresent(stud: m, day: tuesday) && isPresent(stud: m, day: wednesday){
            stud.append(m)
        }
    }
    return stud
}
//print(presentThreeDays())

// present on mondey and on wednesday but not tusday
func presentMonAndWed() -> [String]{
    var stud: [String] = []
    for m in monday{
        if isPresent(stud: m, day: wednesday) && !isPresent(stud: m, day: tuesday) {
            stud.append(m)
        }
    }
    return stud
}

//print(presentMonAndWed())

// present only two days
func presentTwoDays() -> [String]{
    var stud: [String] = presentMonAndWed()
    for m in monday{
        if isPresent(stud: m, day: tuesday) && !isPresent(stud: m, day: wednesday) {
            stud.append(m)
            
        }
    }
    for t in tuesday{
        if isPresent(stud: t, day: wednesday) && !isPresent(stud: t, day: monday) {
            stud.append(t)
        }
    }
    return stud
}

//print(presentTwoDays())

var d = MyDictionary<Int, Int>()

d.updateValue(key: 5, value: 5)

d.updateValue(key: 2, value: 3)
d.updateValue(key: 3, value: 3)
d.updateValue(key: 1, value: 1)
d.updateValue(key: 4, value: 4)
d.updateValue(key: 0, value: 0)


d.updateValue(key: 9, value: 9)
d.updateValue(key: 7, value: 7)
d.updateValue(key: 6, value: 6)
d.updateValue(key: 10, value: 10)
d.updateValue(key: 8, value: 8)

print(d.getAt(key: 5))
d.remove(key: 5)
print(d.getAt(key: 5))
