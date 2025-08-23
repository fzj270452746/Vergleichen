//
//  VergleichenHomeViewController.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import UIKit
import SnapKit

class VergleichenHomeViewController: UIViewController {
    
    // MARK: - UI Components
    private let vergleichenScrollView = UIScrollView()
    private let vergleichenContentView = UIView()
    private let vergleichenTitleLabel = UILabel()
    private let vergleichenSubtitleLabel = UILabel()
    private let vergleichenHighScoresContainer = UIView()
    private let vergleichenDifficultyButtonsContainer = UIView()
    private let vergleichenRulesButton = VergleichenCustomButton(style: .vergleichenSecondary)
    private let vergleichenFeedbackButton = VergleichenCustomButton(style: .vergleichenSecondary)
    
    private var vergleichenEasyButton: VergleichenCustomButton!
    private var vergleichenMediumButton: VergleichenCustomButton!
    private var vergleichenHardButton: VergleichenCustomButton!
    
    private var vergleichenEasyScoreView: VergleichenScoreView!
    private var vergleichenMediumScoreView: VergleichenScoreView!
    private var vergleichenHardScoreView: VergleichenScoreView!
    
    private let vergleichenGameManager = VergleichenGameManager()
    
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
        vergleichenUpdateHighScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vergleichenUpdateHighScores()
        vergleichenAnimateEntrance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.vergleichenUpdateGradientFrame()
    }
    
    // MARK: - UI Setup
    private func vergleichenSetupUI() {
        view.backgroundColor = UIColor.vergleichenPrimaryBackground
        view.vergleichenApplyGradientBackground()
        
        // Setup scroll view
        vergleichenScrollView.showsVerticalScrollIndicator = false
        vergleichenScrollView.alwaysBounceVertical = true
        view.addSubview(vergleichenScrollView)
        
        vergleichenContentView.backgroundColor = .clear
        vergleichenScrollView.addSubview(vergleichenContentView)
        
        // Setup title
        let adapter = VergleichenDeviceAdapter.vergleichenShared
        vergleichenTitleLabel.text = "Mahjong Vergleichen"
        vergleichenTitleLabel.font = adapter.vergleichenAdaptiveBoldFont(size: 32)
        vergleichenTitleLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        vergleichenTitleLabel.textAlignment = .center
        vergleichenTitleLabel.numberOfLines = 0
        vergleichenContentView.addSubview(vergleichenTitleLabel)
        
        // Setup subtitle
        vergleichenSubtitleLabel.text = "Choose Your Challenge"
        vergleichenSubtitleLabel.font = adapter.vergleichenAdaptiveFont(size: 18)
        vergleichenSubtitleLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        vergleichenSubtitleLabel.textAlignment = .center
        vergleichenContentView.addSubview(vergleichenSubtitleLabel)
        
        // Setup high scores container
        vergleichenHighScoresContainer.vergleichenApplyCardStyle()
        vergleichenHighScoresContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        vergleichenHighScoresContainer.layer.shadowOpacity = 0.3
        vergleichenHighScoresContainer.layer.shadowRadius = 8
        vergleichenHighScoresContainer.layer.shadowColor = UIColor.black.cgColor
        vergleichenContentView.addSubview(vergleichenHighScoresContainer)
        
        // Setup score views
        vergleichenEasyScoreView = VergleichenScoreView()
        vergleichenMediumScoreView = VergleichenScoreView()
        vergleichenHardScoreView = VergleichenScoreView()
        
        vergleichenHighScoresContainer.addSubview(vergleichenEasyScoreView)
        vergleichenHighScoresContainer.addSubview(vergleichenMediumScoreView)
        vergleichenHighScoresContainer.addSubview(vergleichenHardScoreView)
        
        // Setup difficulty buttons container
        vergleichenDifficultyButtonsContainer.backgroundColor = .clear
        vergleichenContentView.addSubview(vergleichenDifficultyButtonsContainer)
        
        // Setup difficulty buttons
        vergleichenEasyButton = VergleichenCustomButton(style: .vergleichenDifficulty)
        vergleichenEasyButton.setTitle("Easy", for: .normal)
        vergleichenDifficultyButtonsContainer.addSubview(vergleichenEasyButton)
        
        vergleichenMediumButton = VergleichenCustomButton(style: .vergleichenDifficulty)
        vergleichenMediumButton.setTitle("Medium", for: .normal)
        vergleichenDifficultyButtonsContainer.addSubview(vergleichenMediumButton)
        
        vergleichenHardButton = VergleichenCustomButton(style: .vergleichenDifficulty)
        vergleichenHardButton.setTitle("Hard", for: .normal)
        vergleichenDifficultyButtonsContainer.addSubview(vergleichenHardButton)
        
        // Setup action buttons
        vergleichenRulesButton.setTitle("How to Play", for: .normal)
        vergleichenContentView.addSubview(vergleichenRulesButton)
        
        vergleichenFeedbackButton.setTitle("Feedback", for: .normal)
        vergleichenContentView.addSubview(vergleichenFeedbackButton)
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        vergleichenContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        vergleichenTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenHighScoresContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenSubtitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(120)
        }
        
        // High score views layout
        vergleichenEasyScoreView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(vergleichenMediumScoreView)
        }
        
        vergleichenMediumScoreView.snp.makeConstraints { make in
            make.leading.equalTo(vergleichenEasyScoreView.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview().inset(16)
            make.width.equalTo(vergleichenHardScoreView)
        }
        
        vergleichenHardScoreView.snp.makeConstraints { make in
            make.leading.equalTo(vergleichenMediumScoreView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        vergleichenDifficultyButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenHighScoresContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        // Difficulty buttons layout
        vergleichenEasyButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        vergleichenMediumButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenEasyButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        vergleichenHardButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenMediumButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        vergleichenRulesButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenDifficultyButtonsContainer.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        vergleichenFeedbackButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenRulesButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func vergleichenSetupActions() {
        vergleichenEasyButton.addTarget(self, action: #selector(vergleichenEasyButtonTapped), for: .touchUpInside)
        vergleichenMediumButton.addTarget(self, action: #selector(vergleichenMediumButtonTapped), for: .touchUpInside)
        vergleichenHardButton.addTarget(self, action: #selector(vergleichenHardButtonTapped), for: .touchUpInside)
        vergleichenRulesButton.addTarget(self, action: #selector(vergleichenRulesButtonTapped), for: .touchUpInside)
        vergleichenFeedbackButton.addTarget(self, action: #selector(vergleichenFeedbackButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func vergleichenEasyButtonTapped() {
        vergleichenStartGame(difficulty: .easy)
    }
    
    @objc private func vergleichenMediumButtonTapped() {
        vergleichenStartGame(difficulty: .medium)
    }
    
    @objc private func vergleichenHardButtonTapped() {
        vergleichenStartGame(difficulty: .hard)
    }
    
    @objc private func vergleichenRulesButtonTapped() {
        vergleichenShowRules()
    }
    
    @objc private func vergleichenFeedbackButtonTapped() {
        vergleichenShowFeedback()
    }
    
    // MARK: - Navigation
    private func vergleichenStartGame(difficulty: VergleichenGameDifficulty) {
        let gameVC = VergleichenGameViewController(difficulty: difficulty)
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    private func vergleichenShowRules() {
        let rulesVC = VergleichenRulesViewController()
        rulesVC.modalPresentationStyle = .pageSheet
        present(rulesVC, animated: true)
    }
    
    private func vergleichenShowFeedback() {
        let feedbackVC = VergleichenFeedbackViewController()
        feedbackVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = feedbackVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
            }
        }
        present(feedbackVC, animated: true)
    }
    
    // MARK: - Helper Methods
    private func vergleichenUpdateHighScores() {
        vergleichenEasyScoreView.vergleichenUpdateScore(vergleichenGameManager.vergleichenGetHighScore(for: .easy), title: "Easy\nHigh Score")
        vergleichenMediumScoreView.vergleichenUpdateScore(vergleichenGameManager.vergleichenGetHighScore(for: .medium), title: "Medium\nHigh Score")
        vergleichenHardScoreView.vergleichenUpdateScore(vergleichenGameManager.vergleichenGetHighScore(for: .hard), title: "Hard\nHigh Score")
    }
    
    private func vergleichenAnimateEntrance() {
        // Initial state - hidden
        vergleichenTitleLabel.alpha = 0
        vergleichenTitleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        
        vergleichenSubtitleLabel.alpha = 0
        vergleichenSubtitleLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        
        vergleichenHighScoresContainer.alpha = 0
        vergleichenHighScoresContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        vergleichenDifficultyButtonsContainer.alpha = 0
        vergleichenDifficultyButtonsContainer.transform = CGAffineTransform(translationX: 0, y: 50)
        
        vergleichenRulesButton.alpha = 0
        vergleichenFeedbackButton.alpha = 0
        
        // Animate entrance
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.vergleichenTitleLabel.alpha = 1
            self.vergleichenTitleLabel.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut, animations: {
            self.vergleichenSubtitleLabel.alpha = 1
            self.vergleichenSubtitleLabel.transform = .identity
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.vergleichenHighScoresContainer.alpha = 1
            self.vergleichenHighScoresContainer.transform = .identity
        })
        
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.vergleichenDifficultyButtonsContainer.alpha = 1
            self.vergleichenDifficultyButtonsContainer.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.9, options: .curveEaseOut, animations: {
            self.vergleichenRulesButton.alpha = 1
        })
        
        UIView.animate(withDuration: 0.6, delay: 1.0, options: .curveEaseOut, animations: {
            self.vergleichenFeedbackButton.alpha = 1
        })
    }
}
