//
//  VergleichenGameViewController.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import UIKit
import SnapKit

class VergleichenGameViewController: UIViewController {
    
    // MARK: - Properties
    private let vergleichenDifficulty: VergleichenGameDifficulty
    private let vergleichenGameManager = VergleichenGameManager()
    
    // MARK: - UI Components
    private let vergleichenHeaderView = VergleichenGameHeaderView()
    private let vergleichenScoreContainer = UIView()
    private let vergleichenCurrentScoreView = VergleichenScoreView()
    private let vergleichenHighScoreView = VergleichenScoreView()
    private let vergleichenGameBoardContainer = UIView()
    private let vergleichenControlsContainer = UIView()
    private let vergleichenBackButton = VergleichenCustomButton(style: .vergleichenSecondary)
    private let vergleichenNewGameButton = VergleichenCustomButton(style: .vergleichenPrimary)
    private let vergleichenResultLabel = UILabel()
    private let vergleichenSummaryContainer = UIView()
    private let vergleichenPlayerSumLabel = UILabel()
    private let vergleichenComputerSumLabel = UILabel()
    
    private var vergleichenTileViews: [VergleichenMahjongTileView] = []
    private var vergleichenParticleEmitter: CAEmitterLayer?
    
    // MARK: - Initialization
    init(difficulty: VergleichenGameDifficulty) {
        self.vergleichenDifficulty = difficulty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Orientation Support
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return vergleichenSupportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return vergleichenPreferredInterfaceOrientationForPresentation
    }
    
    override var shouldAutorotate: Bool {
        return vergleichenShouldAutorotate
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vergleichenSetupDeviceSpecificUI()
        vergleichenSetupUI()
        vergleichenSetupConstraints()
        vergleichenSetupActions()
        vergleichenSetupGameManager()
        vergleichenStartNewGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vergleichenAnimateGameBoardEntrance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.vergleichenUpdateGradientFrame()
    }
    
    // MARK: - UI Setup
    private func vergleichenSetupUI() {
        view.backgroundColor = UIColor.vergleichenPrimaryBackground
        view.vergleichenApplyGradientBackground()
        
        // Setup header
        vergleichenHeaderView.vergleichenConfigureWith(difficulty: vergleichenDifficulty)
        view.addSubview(vergleichenHeaderView)
        
        // Setup score container
        vergleichenScoreContainer.backgroundColor = .clear
        view.addSubview(vergleichenScoreContainer)
        
        vergleichenScoreContainer.addSubview(vergleichenCurrentScoreView)
        vergleichenScoreContainer.addSubview(vergleichenHighScoreView)
        
        // Setup game board container
        vergleichenGameBoardContainer.vergleichenApplyGameBoardStyle()
        view.addSubview(vergleichenGameBoardContainer)
        
        // Setup result label
        vergleichenResultLabel.font = UIFont.boldSystemFont(ofSize: 20)
        vergleichenResultLabel.textAlignment = .center
        vergleichenResultLabel.numberOfLines = 0
        vergleichenResultLabel.alpha = 0
        view.addSubview(vergleichenResultLabel)
        
        // Setup summary container
        vergleichenSummaryContainer.vergleichenApplyCardStyle()
        vergleichenSummaryContainer.alpha = 0
        view.addSubview(vergleichenSummaryContainer)
        
        vergleichenPlayerSumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        vergleichenPlayerSumLabel.textAlignment = .center
        vergleichenPlayerSumLabel.textColor = UIColor.systemBlue
        vergleichenSummaryContainer.addSubview(vergleichenPlayerSumLabel)
        
        vergleichenComputerSumLabel.font = UIFont.boldSystemFont(ofSize: 16)
        vergleichenComputerSumLabel.textAlignment = .center
        vergleichenComputerSumLabel.textColor = UIColor.systemRed
        vergleichenSummaryContainer.addSubview(vergleichenComputerSumLabel)
        
        // Setup controls
        vergleichenControlsContainer.backgroundColor = .clear
        view.addSubview(vergleichenControlsContainer)
        
        vergleichenBackButton.setTitle("Back to Menu", for: .normal)
        vergleichenControlsContainer.addSubview(vergleichenBackButton)
        
        vergleichenNewGameButton.setTitle("New Game", for: .normal)
        vergleichenControlsContainer.addSubview(vergleichenNewGameButton)
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenScoreContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenHeaderView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        vergleichenCurrentScoreView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(vergleichenHighScoreView)
        }
        
        vergleichenHighScoreView.snp.makeConstraints { make in
            make.leading.equalTo(vergleichenCurrentScoreView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        vergleichenGameBoardContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenScoreContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(vergleichenGameBoardContainer.snp.width).multipliedBy(0.8)
        }
        
        vergleichenResultLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenGameBoardContainer.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenSummaryContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenResultLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(80)
        }
        
        vergleichenPlayerSumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(vergleichenComputerSumLabel)
        }
        
        vergleichenComputerSumLabel.snp.makeConstraints { make in
            make.leading.equalTo(vergleichenPlayerSumLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        vergleichenControlsContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(100)
        }
        
        vergleichenBackButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(vergleichenNewGameButton)
        }
        
        vergleichenNewGameButton.snp.makeConstraints { make in
            make.leading.equalTo(vergleichenBackButton.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    private func vergleichenSetupActions() {
        vergleichenBackButton.addTarget(self, action: #selector(vergleichenBackButtonTapped), for: .touchUpInside)
        vergleichenNewGameButton.addTarget(self, action: #selector(vergleichenNewGameButtonTapped), for: .touchUpInside)
    }
    
    private func vergleichenSetupGameManager() {
        vergleichenGameManager.vergleichenDelegate = self
    }
    
    // MARK: - Game Setup
    private func vergleichenStartNewGame() {
        vergleichenGameManager.vergleichenStartNewGame(difficulty: vergleichenDifficulty)
        vergleichenUpdateScoreDisplays()
        vergleichenHideResultViews()
    }
    
    private func vergleichenCreateGameBoard() {
        // Remove existing tile views
        vergleichenTileViews.forEach { $0.removeFromSuperview() }
        vergleichenTileViews.removeAll()
        
        let gridSize = vergleichenDifficulty.vergleichenGridSize
        let tilePositions = vergleichenGameManager.vergleichenTilePositions
        
        // Calculate tile size and spacing using adaptive sizing
        let adapter = VergleichenDeviceAdapter.vergleichenShared
        let containerWidth = view.frame.width - adapter.vergleichenAdaptiveSpacing(32)
        let containerHeight = containerWidth * 0.8
        let containerSize = CGSize(width: containerWidth, height: containerHeight)
        
        let (tileSize, tileSpacing) = adapter.vergleichenCalculateGameBoardSize(for: vergleichenDifficulty, in: containerSize)
        let tileWidth = tileSize.width
        let tileHeight = tileSize.height
        
        // Calculate the total grid dimensions
        let totalGridWidth = CGFloat(gridSize.columns) * tileWidth + CGFloat(gridSize.columns - 1) * tileSpacing
        let totalGridHeight = CGFloat(gridSize.rows) * tileHeight + CGFloat(gridSize.rows - 1) * tileSpacing
        
        // Calculate centering offsets
        let horizontalOffset = (containerWidth - totalGridWidth) / 2
        let verticalOffset = (containerHeight - totalGridHeight) / 2
        
        for (index, tilePosition) in tilePositions.enumerated() {
            let tileView = VergleichenMahjongTileView()
            tileView.vergleichenConfigureWith(tilePosition: tilePosition, index: index)
            tileView.vergleichenOnTap = { [weak self] tileIndex in
                self?.vergleichenHandleTileTap(at: tileIndex)
            }
            
            vergleichenGameBoardContainer.addSubview(tileView)
            vergleichenTileViews.append(tileView)
            
            let row = tilePosition.vergleichenRow
            let column = tilePosition.vergleichenColumn
            
            tileView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(horizontalOffset + CGFloat(column) * (tileWidth + tileSpacing))
                make.top.equalToSuperview().offset(verticalOffset + CGFloat(row) * (tileHeight + tileSpacing))
                make.width.equalTo(tileWidth)
                make.height.equalTo(tileHeight)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func vergleichenBackButtonTapped() {
        // Show alert to ask if user wants to reset their score before leaving
        if vergleichenGameManager.vergleichenCurrentScore > 0 || vergleichenGameManager.vergleichenGetWinningStreak() > 0 {
            let alert = UIAlertController(title: "Leave Game", message: "Do you want to keep your current score and streak for next time?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Keep Score", style: .default) { _ in
                self.dismiss(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "Reset Score", style: .destructive) { _ in
                self.vergleichenGameManager.vergleichenResetGameSession()
                self.dismiss(animated: true)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func vergleichenNewGameButtonTapped() {
        vergleichenStartNewGame()
        vergleichenAnimateGameBoardEntrance()
    }
    
    private func vergleichenHandleTileTap(at index: Int) {
        let success = vergleichenGameManager.vergleichenSelectTile(at: index)
        if success {
            vergleichenUpdateTileDisplay(at: index)
            vergleichenAnimateTileSelection(at: index)
        }
    }
    
    // MARK: - UI Updates
    private func vergleichenUpdateTileDisplay(at index: Int) {
        guard index < vergleichenTileViews.count,
              index < vergleichenGameManager.vergleichenTilePositions.count else { return }
        
        let tilePosition = vergleichenGameManager.vergleichenTilePositions[index]
        vergleichenTileViews[index].vergleichenConfigureWith(tilePosition: tilePosition, index: index)
    }
    
    private func vergleichenUpdateAllTileDisplays() {
        for (index, tilePosition) in vergleichenGameManager.vergleichenTilePositions.enumerated() {
            if index < vergleichenTileViews.count {
                vergleichenTileViews[index].vergleichenConfigureWith(tilePosition: tilePosition, index: index)
            }
        }
    }
    
    private func vergleichenUpdateScoreDisplays() {
        let winningStreak = vergleichenGameManager.vergleichenGetWinningStreak()
        let currentScoreTitle = winningStreak > 0 ? "Score (Streak: \(winningStreak))" : "Current Score"
        
        vergleichenCurrentScoreView.vergleichenUpdateScore(vergleichenGameManager.vergleichenCurrentScore, title: currentScoreTitle)
        vergleichenHighScoreView.vergleichenUpdateScore(vergleichenGameManager.vergleichenGetHighScore(for: vergleichenDifficulty), title: "High Score")
    }
    
    private func vergleichenShowResultViews(with result: VergleichenGameResult) {
        vergleichenResultLabel.text = result.vergleichenMessage
        vergleichenResultLabel.textColor = result == .vergleichenWin ? UIColor.systemGreen : 
                                         result == .vergleichenTie ? UIColor.systemOrange : UIColor.systemRed
        
        vergleichenPlayerSumLabel.text = "Your Sum: \(vergleichenGameManager.vergleichenGetPlayerSum())"
        vergleichenComputerSumLabel.text = "Computer Sum: \(vergleichenGameManager.vergleichenGetComputerSum())"
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.vergleichenResultLabel.alpha = 1
            self.vergleichenSummaryContainer.alpha = 1
        })
        
        if result == .vergleichenWin {
            vergleichenCreateWinParticleEffect()
        }
    }
    
    private func vergleichenHideResultViews() {
        vergleichenResultLabel.alpha = 0
        vergleichenSummaryContainer.alpha = 0
        vergleichenRemoveParticleEffect()
    }
    
    // MARK: - Animations
    private func vergleichenAnimateGameBoardEntrance() {
        vergleichenCreateGameBoard()
        
        // Initial state - tiles hidden
        vergleichenTileViews.forEach { tileView in
            tileView.alpha = 0
            tileView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
        // Animate tiles entrance
        for (index, tileView) in vergleichenTileViews.enumerated() {
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                tileView.alpha = 1
                tileView.transform = .identity
            })
        }
    }
    
    private func vergleichenAnimateTileSelection(at index: Int) {
        guard index < vergleichenTileViews.count else { return }
        
        let tileView = vergleichenTileViews[index]
        UIView.animate(withDuration: 0.2, animations: {
            tileView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                tileView.transform = .identity
            }
        }
    }
    
    private func vergleichenAnimateTileReveal() {
        for tileView in vergleichenTileViews {
            tileView.vergleichenAnimateReveal()
        }
    }
    
    private func vergleichenCreateWinParticleEffect() {
        vergleichenParticleEmitter = CAEmitterLayer()
        guard let emitter = vergleichenParticleEmitter else { return }
        
        emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: 100)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 50
        cell.lifetime = 3.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.emissionRange = .pi / 4
        cell.scale = 0.5
        cell.scaleRange = 0.3
        cell.contents = UIImage(systemName: "star.fill")?.cgImage
        cell.color = UIColor.systemYellow.cgColor
        
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        
        // Remove after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.vergleichenRemoveParticleEffect()
        }
    }
    
    private func vergleichenRemoveParticleEffect() {
        vergleichenParticleEmitter?.removeFromSuperlayer()
        vergleichenParticleEmitter = nil
    }
}

// MARK: - VergleichenGameManagerDelegate
extension VergleichenGameViewController: VergleichenGameManagerDelegate {
    
    func vergleichenGameManager(_ manager: VergleichenGameManager, didUpdateScore score: Int) {
        vergleichenUpdateScoreDisplays()
    }
    
    func vergleichenGameManager(_ manager: VergleichenGameManager, didUpdateHighScore highScore: Int) {
        vergleichenUpdateScoreDisplays()
    }
    
    func vergleichenGameManager(_ manager: VergleichenGameManager, didCompleteRound result: VergleichenGameResult) {
        vergleichenShowResultViews(with: result)
    }
    
    func vergleichenGameManager(_ manager: VergleichenGameManager, didChangeState state: VergleichenGameState) {
        switch state {
        case .vergleichenRevealed:
            vergleichenAnimateTileReveal()
            vergleichenUpdateAllTileDisplays()
        case .vergleichenSelecting:
            vergleichenCreateGameBoard()
        default:
            break
        }
    }
}
