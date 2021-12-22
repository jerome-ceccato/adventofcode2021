//
//  day19.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day19: AOCDay {
    struct Point: CustomStringConvertible, Comparable, Equatable, Hashable {
        let x: Int
        let y: Int
        let z: Int
        
        var description: String {
            return "\(x),\(y),\(z)"
        }
        
        static func + (lhs: Point, rhs: Point) -> Point {
            return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
        }
        
        static func - (lhs: Point, rhs: Point) -> Point {
            return Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
        }
        
        static func < (lhs: Point, rhs: Point) -> Bool {
            return lhs.x < rhs.x ||
            (lhs.x == rhs.x && lhs.y < rhs.y) ||
            (lhs.x == rhs.x && lhs.y == rhs.y && lhs.z < rhs.z)
        }
    }
    
    struct Scanner: CustomStringConvertible {
        let name: String
        let points: [Point]
        
        var description: String {
            return "\n--- \(name) ---\n" + points.map(\.description).joined(separator: "\n")
        }
    }

    func parseInput(_ raw: String) -> [Scanner] {
        func parsePoint(_ line: String) -> Point {
            let pts = line.trimmingCharacters(in: .whitespaces).components(separatedBy: ",").compactMap(Int.init)
            return Point(x: pts[0], y: pts[1], z: pts[2])
        }
        
        func parseScanner(_ chunk: String) -> Scanner {
            let lines = chunk.components(separatedBy: "\n")
            let name = lines[0].trimmingCharacters(in: CharacterSet(charactersIn: "- "))
            let points = lines
                .suffix(from: 1)
                .filter { !$0.isEmpty }
                .map(parsePoint(_:))
            return Scanner(name: name, points: points)
        }
        
        return raw.components(separatedBy: "\n\n")
            .filter { !$0.isEmpty }
            .map(parseScanner(_:))
    }
    
    func coordinate(from point: Point, target: Int) -> Int {
        let sign = target < 0 ? -1 : 1
        let coord = abs(target)
        switch coord {
        case 1:
            return point.x * sign;
        case 2:
            return point.y * sign;
        case 3:
            return point.z * sign;
        default:
            fatalError()
        }
    }

    func allPossibleRotations(for scanner: [Point]) -> [[Point]] {
        let range = [-3, -2, -1, 1, 2, 3]
        var options = [[Point]]()
        for a in range {
            for b in range {
                for c in range {
                    if abs(a) == abs(b) || abs(b) == abs(c) || abs(a) == abs(c) {
                        continue
                    }
                    
                    options.append(scanner.map({ p in
                        return Point(
                            x: coordinate(from: p, target: a),
                            y: coordinate(from: p, target: b),
                            z: coordinate(from: p, target: c))
                    }).sorted())
                }
            }
        }
        return options
    }
    
    func translate(lhs: [Point], rhs: [Point]) -> [Point]? {
        let rhsRotations = allPossibleRotations(for: rhs)
        for rota in rhsRotations {
            var transations = [Point: Int]()
            for p1 in lhs {
                for p2 in rota {
                    let diff = p2 - p1
                    transations[diff, default: 0] += 1
                    if transations[diff, default: 0] >= 12 {
                        return rota.map { $0 - diff }
                    }
                }
            }
        }
        return nil
    }

    func trySolve(normalized: inout [[Point]], unnormalized: inout [[Point]]) {
        for n in 0 ..< normalized.count {
            for u in 0 ..< unnormalized.count {
                if let points = translate(lhs: normalized[n], rhs: unnormalized[u]) {
                    unnormalized.remove(at: u)
                    normalized.append(points)
                    return
                }
            }
        }
        fatalError()
    }
    
    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        var normalized = [input[0].points]
        var unnormalized = input.suffix(from: 1).map(\.points)
        while !unnormalized.isEmpty {
            print(unnormalized.count)
            trySolve(normalized: &normalized, unnormalized: &unnormalized)
        }
        
        let points = normalized.reduce(into: Set<Point>()) { acc, pts in
            pts.forEach { acc.insert($0) }
        }
        
        return points.count
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        var normalized = [input[0].points]
        var unnormalized = input.suffix(from: 1).map(\.points)
        while !unnormalized.isEmpty {
            print(unnormalized.count)
            trySolve(normalized: &normalized, unnormalized: &unnormalized)
        }
        
        let points = normalized.reduce(into: Set<Point>()) { acc, pts in
            pts.forEach { acc.insert($0) }
        }
        
        return points.count
    }
}
