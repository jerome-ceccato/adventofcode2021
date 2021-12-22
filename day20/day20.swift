//
//  day20.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day20: AOCDay {
    struct Image {
        let enhancer: [Bool]
        let pixels: Set<Pixel>
    }
    
    struct Pixel: Hashable, Equatable {
        let x: Int
        let y: Int
    }
    
    func parseInput(_ raw: String) -> Image {
        let chunks = raw.components(separatedBy: "\n\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let enhancer = chunks[0].map { $0 == "#" }
        let pixelMap = chunks[1].components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }

        var pixels = Set<Pixel>()
        for y in 0 ..< pixelMap.count {
            for x in 0 ..< pixelMap[y].count {
                if pixelMap[y][x] == "#" {
                    pixels.insert(Pixel(x: x, y: y))
                }
            }
        }
        return Image(enhancer: enhancer, pixels: pixels)
    }
    
    func enhance(pixel: Pixel, input: Set<Pixel>, enhancer: [Bool]) -> Bool {
        var pixelValue = 0
        for yOffset in [-1, 0, 1] {
            for xOffset in [-1, 0, 1] {
                let target = Pixel(x: pixel.x + xOffset, y: pixel.y + yOffset)
                pixelValue = pixelValue << 1 + (input.contains(target) ? 1 : 0)
            }
        }
        return enhancer[pixelValue]
    }
    
    func process(input: Set<Pixel>, enhancer: [Bool], step: Int) -> Set<Pixel> {
        var targets = Set<Pixel>()
        
        input.forEach { pixel in
            for yOffset in -1 ... 1 {
                for xOffset in -1 ... 1 {
                    targets.insert(Pixel(x: pixel.x + xOffset, y: pixel.y + yOffset))
                }
            }
        }
        
        return targets.reduce(into: Set<Pixel>()) { output, pixel in
            if enhance(pixel: pixel, input: input, enhancer: enhancer) {
                output.insert(pixel)
            }
        }
    }
    
    func display(pixels: Set<Pixel>) -> String {
        let xCoords = pixels.map(\.x)
        let yCoords = pixels.map(\.y)
        
        let xRange = xCoords.min()! ... xCoords.max()!
        let yRange = yCoords.min()! ... yCoords.max()!
        
        var output = "\n"
        for y in yRange {
            for x in xRange {
                output += pixels.contains(Pixel(x: x, y: y)) ? "#" : "."
            }
            output += "\n"
        }
        return output
    }

    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        let processedInput = (0 ..< 2).reduce(input.pixels) { acc, step in
            return process(input: acc, enhancer: input.enhancer, step: step)
        }
        return processedInput.count
    }

    func part2(rawInput: String) -> CustomStringConvertible {
        // let input = parseInput(rawInput)
        
        return "Unimplemented"
    }
}
