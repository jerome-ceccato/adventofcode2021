//
//  main.swift
//  day01
//
//  Created by Jerome Ceccato on 01/12/2021.
//

import Foundation

func readInput() -> [Int] {
    let path = Bundle.main.path(forResource: "input", ofType: "txt")!
    let raw = try! String(contentsOfFile: path, encoding: .utf8)
    return raw.components(separatedBy: "\n").compactMap(Int.init)
}

func part1(input: [Int]) {
    var n = 0
    for i in 1 ..< input.count {
        n += (input[i] > input[i - 1]) ? 1 : 0
    }
    print("part1: \(n)")
}

func part2(input: [Int]) {
    var n = 0
    for i in 3 ..< input.count {
        n += (input[i] > input[i - 3]) ? 1 : 0
    }
    print("part2: \(n)")
}

let input = readInput()
part1(input: input)
part2(input: input)
