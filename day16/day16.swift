//
//  day16.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day16: AOCDay {
    func parseInput(_ raw: String) -> String {
        return raw.trimmingCharacters(in: .whitespacesAndNewlines).map { char in
            let hex = Int(String(char), radix: 16)!
            let binary = String(hex, radix: 2)
            return (binary.count < 4 ? String(repeating: "0", count: 4 - binary.count) : "") + binary
        }.joined(separator: "")
    }
    
    func consume(bits: Int, input: inout String) -> String {
        let prefix = input.prefix(bits)
        input.removeSubrange(input.startIndex ..< input.index(input.startIndex, offsetBy: prefix.count))
        return String(prefix)
    }
    
    func consumeAsInt(bits: Int, input: inout String) -> Int {
        return Int(consume(bits: bits, input: &input), radix: 2)!
    }
   
    func decode(input: inout String) -> Int {
        let version = consumeAsInt(bits: 3, input: &input)
        let type = consumeAsInt(bits: 3, input: &input)
        
        var total = version
        if type == 4 {
            while consume(bits: 5, input: &input).starts(with: "1") {}
        } else {
            if consumeAsInt(bits: 1, input: &input) == 0 {
                let length = consumeAsInt(bits: 15, input: &input)
                var subpackets = consume(bits: length, input: &input)
                while !subpackets.isEmpty {
                    total += decode(input: &subpackets)
                }
            } else {
                let nSubpackets = consumeAsInt(bits: 11, input: &input)
                for _ in 0 ..< nSubpackets {
                    total += decode(input: &input)
                }
            }
        }
        return total
    }

    func part1(rawInput: String) -> CustomStringConvertible {
        var input = parseInput(rawInput)
        return decode(input: &input)
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        // let input = parseInput(rawInput)
        
        return "Unimplemented"
    }
}
