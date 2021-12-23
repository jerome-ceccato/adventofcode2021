//
//  day21.swift
//  adventofcode2021
//
//  Created by Jerome Ceccato on 18/12/2021.
//

import Foundation

final class Day21: AOCDay {
    class Dice {
        var rolls = 0
        var value = 0
        
        func roll() -> Int {
            rolls += 1
            value = (value % 100) + 1
            return value
        }
        
        func roll3() -> Int {
            return roll() + roll() + roll()
        }
    }
    
    class Player {
        var position: Int
        var score: Int = 0
        
        init(pos: Int) {
            position = pos - 1
        }
    }
    
    func parseInput(_ raw: String) -> (p1: Int, p2: Int) {
        let positions = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
            .compactMap { line in
                Int(line.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))
            }
        return (p1: positions[0], p2: positions[1])
    }
    
    func part1(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        let player1 = Player(pos: input.p1)
        let player2 = Player(pos: input.p2)
        let dice = Dice()
        
        var hasWinner: Bool {
            return player1.score >= 1000 || player2.score >= 1000
        }
        
        func gameScore() -> Int {
            if player1.score >= 1000 {
                return player2.score * dice.rolls
            } else {
                return player1.score * dice.rolls
            }
        }
        
        while !hasWinner {
            for player in [player1, player2] {
                let roll = dice.roll3()
                player.position = (player.position + roll) % 10
                player.score += player.position + 1
                
                if hasWinner {
                    break
                }
            }
        }
        return gameScore()
    }
    
    struct PlayerState: Hashable, Equatable {
        let position: Int
        let score: Int
    }
    
    func part2(rawInput: String) -> CustomStringConvertible {
        let input = parseInput(rawInput)
        
        var p1States = Set<PlayerState>()
        var p2States = Set<PlayerState>()
        p1States.insert(PlayerState(position: input.p1, score: 0))
        p2States.insert(PlayerState(position: input.p2, score: 0))
        
        return "a lot"
    }
}
