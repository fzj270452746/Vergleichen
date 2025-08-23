//
//  VergleichenGameManager.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import Foundation

protocol VergleichenGameManagerDelegate: AnyObject {
    func vergleichenGameManager(_ manager: VergleichenGameManager, didUpdateScore score: Int)
    func vergleichenGameManager(_ manager: VergleichenGameManager, didUpdateHighScore highScore: Int)
    func vergleichenGameManager(_ manager: VergleichenGameManager, didCompleteRound result: VergleichenGameResult)
    func vergleichenGameManager(_ manager: VergleichenGameManager, didChangeState state: VergleichenGameState)
}

class VergleichenGameManager {
    
    // MARK: - Properties
    weak var vergleichenDelegate: VergleichenGameManagerDelegate?
    
    private(set) var vergleichenCurrentDifficulty: VergleichenGameDifficulty = .easy
    private(set) var vergleichenCurrentScore: Int = 0
    private(set) var vergleichenWinningStreak: Int = 0
    private(set) var vergleichenGameState: VergleichenGameState = .vergleichenWaiting
    private(set) var vergleichenTilePositions: [VergleichenTilePosition] = []
    private(set) var vergleichenSelectedIndices: Set<Int> = []
    
    // MARK: - UserDefaults Keys
    private let vergleichenEasyHighScoreKey = "VergleichenEasyHighScore"
    private let vergleichenMediumHighScoreKey = "VergleichenMediumHighScore"
    private let vergleichenHardHighScoreKey = "VergleichenHardHighScore"
    
    // MARK: - Initialization
    init() {
        vergleichenSetupInitialState()
    }
    
    // MARK: - Public Methods
    func vergleichenStartNewGame(difficulty: VergleichenGameDifficulty) {
        vergleichenCurrentDifficulty = difficulty
        // Only reset score and streak when starting a completely new game session
        // Individual rounds within a session will maintain the streak
        vergleichenSelectedIndices.removeAll()
        vergleichenGenerateGameBoard()
        vergleichenUpdateGameState(.vergleichenSelecting)
        vergleichenDelegate?.vergleichenGameManager(self, didUpdateScore: vergleichenCurrentScore)
    }
    
    func vergleichenResetGameSession() {
        // This method resets the entire game session including score and streak
        vergleichenCurrentScore = 0
        vergleichenWinningStreak = 0
        vergleichenDelegate?.vergleichenGameManager(self, didUpdateScore: vergleichenCurrentScore)
    }
    
    func vergleichenSelectTile(at index: Int) -> Bool {
        guard vergleichenGameState == .vergleichenSelecting,
              index < vergleichenTilePositions.count else {
            return false
        }
        
        if vergleichenSelectedIndices.contains(index) {
            // Deselect tile
            vergleichenSelectedIndices.remove(index)
            vergleichenTilePositions[index].vergleichenIsSelected = false
        } else {
            // Select tile if not at limit
            if vergleichenSelectedIndices.count < vergleichenCurrentDifficulty.vergleichenPlayerSelectionCount {
                vergleichenSelectedIndices.insert(index)
                vergleichenTilePositions[index].vergleichenIsSelected = true
            }
        }
        
        // Check if player has made required selections
        if vergleichenSelectedIndices.count == vergleichenCurrentDifficulty.vergleichenPlayerSelectionCount {
            vergleichenRevealAllTiles()
            vergleichenCalculateResult()
        }
        
        return true
    }
    
    func vergleichenGetHighScore(for difficulty: VergleichenGameDifficulty) -> Int {
        let key = vergleichenGetHighScoreKey(for: difficulty)
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func vergleichenResetGame() {
        vergleichenSelectedIndices.removeAll()
        for i in 0..<vergleichenTilePositions.count {
            vergleichenTilePositions[i].vergleichenIsSelected = false
            vergleichenTilePositions[i].vergleichenIsRevealed = false
        }
        vergleichenUpdateGameState(.vergleichenSelecting)
    }
    
    // MARK: - Private Methods
    private func vergleichenSetupInitialState() {
        vergleichenUpdateGameState(.vergleichenWaiting)
    }
    
    private func vergleichenGenerateGameBoard() {
        vergleichenTilePositions.removeAll()
        
        let totalTiles = vergleichenCurrentDifficulty.vergleichenTotalTiles
        let allTiles = VergleichenMahjongTile.vergleichenGenerateAllTiles()
        let selectedTiles = Array(allTiles.shuffled().prefix(totalTiles))
        
        let gridSize = vergleichenCurrentDifficulty.vergleichenGridSize
        var index = 0
        
        for row in 0..<gridSize.rows {
            for column in 0..<gridSize.columns {
                let tilePosition = VergleichenTilePosition(
                    vergleichenRow: row,
                    vergleichenColumn: column,
                    vergleichenTile: selectedTiles[index]
                )
                vergleichenTilePositions.append(tilePosition)
                index += 1
            }
        }
    }
    
    private func vergleichenRevealAllTiles() {
        for i in 0..<vergleichenTilePositions.count {
            vergleichenTilePositions[i].vergleichenReveal()
        }
        vergleichenUpdateGameState(.vergleichenRevealed)
    }
    
    private func vergleichenCalculateResult() {
        let selectedTiles = vergleichenSelectedIndices.map { vergleichenTilePositions[$0].vergleichenTile }
        let unselectedTiles = vergleichenTilePositions.enumerated().compactMap { index, tilePosition in
            vergleichenSelectedIndices.contains(index) ? nil : tilePosition.vergleichenTile
        }
        
        let playerSum = selectedTiles.reduce(0) { $0 + $1.vergleichenValue }
        let computerSum = unselectedTiles.reduce(0) { $0 + $1.vergleichenValue }
        
        let result: VergleichenGameResult
        if playerSum > computerSum {
            result = .vergleichenWin
        } else if playerSum == computerSum {
            result = .vergleichenTie
        } else {
            result = .vergleichenLose
        }
        
        vergleichenUpdateScore(with: result)
        vergleichenUpdateGameState(.vergleichenCompleted)
        vergleichenDelegate?.vergleichenGameManager(self, didCompleteRound: result)
    }
    
    private func vergleichenUpdateScore(with result: VergleichenGameResult) {
        switch result {
        case .vergleichenWin:
            // Win: Add points and increment streak
            vergleichenWinningStreak += 1
            vergleichenCurrentScore += result.vergleichenScoreChange
            
        case .vergleichenTie:
            // Tie: No score change, but streak continues
            break
            
        case .vergleichenLose:
            // Lose: Reset score to 0 and reset streak
            vergleichenCurrentScore = 0
            vergleichenWinningStreak = 0
        }
        
        // Check and update high score in real-time
        let currentHighScore = vergleichenGetHighScore(for: vergleichenCurrentDifficulty)
        if vergleichenCurrentScore > currentHighScore {
            let key = vergleichenGetHighScoreKey(for: vergleichenCurrentDifficulty)
            UserDefaults.standard.set(vergleichenCurrentScore, forKey: key)
            vergleichenDelegate?.vergleichenGameManager(self, didUpdateHighScore: vergleichenCurrentScore)
        }
        
        vergleichenDelegate?.vergleichenGameManager(self, didUpdateScore: vergleichenCurrentScore)
    }
    
    private func vergleichenGetHighScoreKey(for difficulty: VergleichenGameDifficulty) -> String {
        switch difficulty {
        case .easy: return vergleichenEasyHighScoreKey
        case .medium: return vergleichenMediumHighScoreKey
        case .hard: return vergleichenHardHighScoreKey
        }
    }
    
    private func vergleichenUpdateGameState(_ newState: VergleichenGameState) {
        vergleichenGameState = newState
        vergleichenDelegate?.vergleichenGameManager(self, didChangeState: newState)
    }
}

// MARK: - Extensions
extension VergleichenGameManager {
    
    func vergleichenGetPlayerSum() -> Int {
        let selectedTiles = vergleichenSelectedIndices.map { vergleichenTilePositions[$0].vergleichenTile }
        return selectedTiles.reduce(0) { $0 + $1.vergleichenValue }
    }
    
    func vergleichenGetComputerSum() -> Int {
        let unselectedTiles = vergleichenTilePositions.enumerated().compactMap { index, tilePosition in
            vergleichenSelectedIndices.contains(index) ? nil : tilePosition.vergleichenTile
        }
        return unselectedTiles.reduce(0) { $0 + $1.vergleichenValue }
    }
    
    func vergleichenCanSelectMoreTiles() -> Bool {
        return vergleichenSelectedIndices.count < vergleichenCurrentDifficulty.vergleichenPlayerSelectionCount
    }
    
    func vergleichenGetWinningStreak() -> Int {
        return vergleichenWinningStreak
    }
}
