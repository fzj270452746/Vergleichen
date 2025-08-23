//
//  VergleichenMahjongTile.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import UIKit

// MARK: - Mahjong Tile Models
enum VergleichenMahjongSuit: String, CaseIterable {
    case yuan = "yuan"
    case wan = "wan"
    case tiao = "tiao"
    
    var vergleichenDisplayName: String {
        switch self {
        case .yuan: return "Dots"
        case .wan: return "Characters"
        case .tiao: return "Bamboo"
        }
    }
}

struct VergleichenMahjongTile: Equatable {
    let vergleichenSuit: VergleichenMahjongSuit
    let vergleichenValue: Int
    let vergleichenId: String
    
    init(suit: VergleichenMahjongSuit, value: Int) {
        self.vergleichenSuit = suit
        self.vergleichenValue = value
        self.vergleichenId = "Vergleichen_\(suit.rawValue)_\(value)"
    }
    
    var vergleichenImageName: String {
        return vergleichenId
    }
    
    static func vergleichenGenerateAllTiles() -> [VergleichenMahjongTile] {
        var tiles: [VergleichenMahjongTile] = []
        for suit in VergleichenMahjongSuit.allCases {
            for value in 1...9 {
                tiles.append(VergleichenMahjongTile(suit: suit, value: value))
            }
        }
        return tiles
    }
    
    static func == (lhs: VergleichenMahjongTile, rhs: VergleichenMahjongTile) -> Bool {
        return lhs.vergleichenId == rhs.vergleichenId
    }
}

// MARK: - Game Difficulty
enum VergleichenGameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var vergleichenGridSize: (rows: Int, columns: Int) {
        switch self {
        case .easy: return (2, 2)
        case .medium: return (2, 3)
        case .hard: return (2, 4)
        }
    }
    
    var vergleichenTotalTiles: Int {
        let size = vergleichenGridSize
        return size.rows * size.columns
    }
    
    var vergleichenPlayerSelectionCount: Int {
        return vergleichenTotalTiles / 2
    }
    
    var vergleichenDescription: String {
        switch self {
        case .easy:
            return "Select 2 tiles from 4 tiles (2x2 grid)"
        case .medium:
            return "Select 3 tiles from 6 tiles (2x3 grid)"
        case .hard:
            return "Select 4 tiles from 8 tiles (2x4 grid)"
        }
    }
}

// MARK: - Game State
enum VergleichenGameState {
    case vergleichenWaiting
    case vergleichenSelecting
    case vergleichenRevealed
    case vergleichenCompleted
}

// MARK: - Game Result
enum VergleichenGameResult {
    case vergleichenWin
    case vergleichenTie
    case vergleichenLose
    
    var vergleichenScoreChange: Int {
        switch self {
        case .vergleichenWin: return 10
        case .vergleichenTie: return 0
        case .vergleichenLose: return -10
        }
    }
    
    var vergleichenMessage: String {
        switch self {
        case .vergleichenWin: return "You Win! +10 points"
        case .vergleichenTie: return "It's a Tie! No points"
        case .vergleichenLose: return "You Lose! Score Reset"
        }
    }
}

// MARK: - Tile Position
struct VergleichenTilePosition {
    let vergleichenRow: Int
    let vergleichenColumn: Int
    let vergleichenTile: VergleichenMahjongTile
    var vergleichenIsSelected: Bool = false
    var vergleichenIsRevealed: Bool = false
    
    mutating func vergleichenToggleSelection() {
        vergleichenIsSelected.toggle()
    }
    
    mutating func vergleichenReveal() {
        vergleichenIsRevealed = true
    }
}
