//
//  day19.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day19: AOCDay {
    struct Point: CustomStringConvertible, Comparable, Equatable {
        let x: Int
        let y: Int
        let z: Int
        
        var description: String {
            return "\(x),\(y),\(z)"
        }
        
        static func + (lhs: Point, rhs: Point) -> Point {
            return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
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
    
    func allPossibleRotations(for scanner: Scanner) -> [[Point]] {
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
        
        let range = [-3, -2, -1, 1, 2, 3]
        var options = [[Point]]()
        for a in range {
            for b in range {
                for c in range {
                    if abs(a) == abs(b) || abs(b) == abs(c) || abs(a) == abs(c) {
                        continue
                    }
                    
                    options.append(scanner.points.map({ p in
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
    
    func matches(lhs: [Point], rhs: [Point]) -> Int {
        return (0 ..< lhs.count).reduce(0) { acc, i in
            return acc + (lhs[i] == rhs[i] ? 1 : 0)
        }
    }
    
    func compareScans(lhs: [[Point]], rhs: [[Point]]) -> Point? {
        for lhsr in lhs {
            for rhsr in rhs {
                for leftPoint in lhsr {
                    for rightPoint in rhsr {
                        let offset = Point(
                            x: leftPoint.x - rightPoint.x,
                            y: leftPoint.y - rightPoint.y,
                            z: leftPoint.z - rightPoint.z)
                        
                        let nMatches = matches(lhs: lhsr, rhs: rhsr.map { $0 + offset })
                        if nMatches >= 8 {
                            return offset
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        let scanRotations = input.map(allPossibleRotations(for:))
        
        for i in 0 ..< scanRotations.count {
            for j in 0 ..< scanRotations.count {
                if i != j {
                    let offset = compareScans(lhs: scanRotations[i], rhs: scanRotations[j])
                    print("\(i)-\(j): \(offset)")
                }
            }
        }
        return "done"
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        // let input = parseInput(rawInput)
        
        return "Unimplemented"
    }
}
