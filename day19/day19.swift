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
    
    func rotations(for point: Point) -> [Point] {
        let range = [-3, -2, -1, 1, 2, 3]
        var rota = [Point]()
        for a in range {
            for b in range {
                for c in range {
                    if abs(a) == abs(b) || abs(b) == abs(c) || abs(a) == abs(c) {
                        continue
                    }
                    rota.append(Point(
                        x: coordinate(from: point, target: a),
                        y: coordinate(from: point, target: b),
                        z: coordinate(from: point, target: c)))
                }
            }
        }
        return rota
    }
    
    func allPossibleRotations(for scanner: Scanner) -> [[Point]] {
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
    
    func compareScans(lhs: [[Point]], rhs: [[Point]]) -> Point? {
        for lhsr in lhs {
            for rhsr in rhs {
                var transations = [Point: Int]()
                for p1 in lhsr {
                    for p2 in rhsr {
                        let diff = p2 - p1
                        transations[diff, default: 0] += 1
                        if transations[diff, default: 0] >= 12 {
                            return diff
                        }
                    }
                }
            }
        }
        return nil
    }
    
    // diff = other - ref
    // ref + diff = other
    // ref = other - diff
    
    /*
     -618,-824,-621
     -537,-823,-458
     -447,-329,318
     404,-588,-901
     544,-627,-890
     528,-643,409
     -661,-816,-575
     390,-675,-793
     423,-701,434
     -345,-311,381
     459,-707,401
     -485,-357,347
     These same 12 beacons (in the same order) but from the perspective of scanner 1 are:

     686,422,578
     605,423,415
     515,917,-361
     -336,658,858
     -476,619,847
     -460,603,-452
     729,430,532
     -322,571,750
     -355,545,-477
     413,935,-424
     -391,539,-444
     553,889,-390

     */
    
    func convert(reference: [Point], other: [Point], offset: Point) -> [Point] {
        //let options = rotations(for: offset)
        let options = [Point(x: 686 - -618, y: 422 - -824, z: 578 - -621)]
        for option in options {
            var hits = 0
            for point in other {
                let offsetPoint = point - option
                print(offsetPoint)
                if reference.contains(offsetPoint) {
                    hits += 1
                }
                
                if hits >= 12 {
                    return other.map { $0 + offset }
                }
            }
            print("hits: \(hits)")
        }
        fatalError()
    }
    
    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        let scanRotations = input.map(allPossibleRotations(for:))
    
        //let firstOffset = compareScans(lhs: [input[0].points], rhs: allPossibleRotations(for: input[1]))!
        //convert(reference: input[0].points, other: input[1].points, offset: firstOffset)
        
        var translations = [String: Point]()
        for i in 0 ..< scanRotations.count {
            for j in i ..< scanRotations.count {
                if i != j {
                    let offset = compareScans(lhs: scanRotations[i], rhs: scanRotations[j])
                    print("\(i)-\(j): \(String(describing: offset))")
                    if let offset = offset {
                        translations["\(i)-\(j)"] = offset
                    }
                }
            }
        }
        print(translations)
        
        let correctPoints = [
            // 0
            input[0].points,
            // 1
            convert(reference: input[0].points, other: input[1].points, offset: translations["0-1"]!),
            // 3
            convert(reference: input[0].points,
                    other: convert(reference: input[1].points, other: input[3].points, offset: translations["1-3"]!),
                    offset: translations["0-1"]!),
            // 4
            convert(reference: input[0].points,
                    other: convert(reference: input[1].points, other: input[4].points, offset: translations["1-4"]!),
                    offset: translations["0-1"]!),
            
            // 2
            convert(reference: input[0].points,
                    other: convert(reference: input[1].points,
                                   other: convert(reference: input[4].points, other: input[2].points, offset: translations["2-4"]!),
                                   offset: translations["1-4"]!),
                    offset: translations["0-1"]!),
        ]
        
        print(correctPoints)
        return "done"
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        // let input = parseInput(rawInput)
        
        return "Unimplemented"
    }
}
