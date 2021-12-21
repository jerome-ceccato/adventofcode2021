//
//  day17.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day17: AOCDay {
    typealias BoundingBox = (x: ClosedRange<Int>, y: ClosedRange<Int>)

    func parseInput(_ raw: String) -> BoundingBox {
        let numbers = raw.components(separatedBy: "target area: x=")[1]
            .components(separatedBy: ", y=")
            .flatMap { $0.components(separatedBy: "..") }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .compactMap(Int.init)
        
        return (x: numbers[0] ... numbers[1], y: numbers[2] ... numbers[3])
    }
    
    func usableXRange(bbox: BoundingBox) -> ClosedRange<Int> {
        let target = bbox.x
        let lowest = (1...).first { n in (n * (n + 1) / 2) >= target.lowerBound }!
        let highest = (lowest...).first { n in
            var distance = 0
            var n = n
            while n > 0 {
                distance += n
                n -= 1
                if target.contains(distance) {
                    return false
                }
            }
            return true
        }!
        return (lowest - 1) ... highest
    }
    
    func usableYRange(bbox: BoundingBox, xRange: ClosedRange<Int>) -> ClosedRange<Int> {
        func iterationsToTarget(target: Int) -> Int {
            var distance = 0
            var n = target
            while n > 0 {
                distance += n
                n -= 1
                if bbox.x.contains(distance) {
                    return target - n
                }
            }
            fatalError()
        }
        
        let lowestIterations = iterationsToTarget(target: xRange.upperBound)
        let highestIterations = iterationsToTarget(target: xRange.lowerBound)
        
        let lowest = bbox.y.lowerBound + (lowestIterations * (lowestIterations + 1) / 2)
        let highest = bbox.y.upperBound + (highestIterations * (highestIterations + 1) / 2)
        return lowest ... highest
    }
    
    func canHit(target: BoundingBox, velocityX: Int, velocityY: Int) -> Bool {
        var vx = velocityX, vy = velocityY
        var x = 0, y = 0
        while x <= target.x.upperBound, y >= target.y.lowerBound {
            if target.x.contains(x) && target.y.contains(y) {
                return true
            }
            x += vx
            y += vy
            if vx > 0 {
                vx -= 1
            }
            vy -= 1
        }
        return false
    }

    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        let targetX = usableXRange(bbox: input)
        let targetY = -100 ... 200 //usableYRange(bbox: input, xRange: targetX)
        print("x: \(targetX) - y: \(targetY)")

        var highestY = -1
        var n = 0
        for x in targetX {
            for y in targetY {
                if canHit(target: input, velocityX: x, velocityY: y) {
                    print("Solution: (\(x), \(y))")
                    highestY = max(highestY, y * (y + 1) / 2)
                    n += 1
                }
            }
        }
        return "Highest: \(highestY), total: \(n)"
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        // let input = parseInput(rawInput)
        
        return "Unimplemented"
    }
}
