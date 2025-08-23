

import UIKit
import SnapKit

class VergleichenRulesViewController: UIViewController {
    
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
    
    // MARK: - UI Components
    private let vergleichenScrollView = UIScrollView()
    private let vergleichenContentView = UIView()
    private let vergleichenTitleLabel = UILabel()
    private let vergleichenCloseButton = VergleichenCustomButton(style: .vergleichenSecondary)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vergleichenSetupDeviceSpecificUI()
        vergleichenSetupUI()
        vergleichenSetupConstraints()
        vergleichenSetupActions()
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
        vergleichenScrollView.showsVerticalScrollIndicator = true
        vergleichenScrollView.alwaysBounceVertical = true
        view.addSubview(vergleichenScrollView)
        
        vergleichenContentView.backgroundColor = .clear
        vergleichenScrollView.addSubview(vergleichenContentView)
        
        // Setup title
        vergleichenTitleLabel.text = "How to Play"
        vergleichenTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        vergleichenTitleLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        vergleichenTitleLabel.textAlignment = .center
        vergleichenContentView.addSubview(vergleichenTitleLabel)
        
        // Set title label constraints here to avoid conflicts
        vergleichenTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        
        // Setup close button
        vergleichenCloseButton.setTitle("Got It!", for: .normal)
        vergleichenContentView.addSubview(vergleichenCloseButton)
        
        // Setup rules content
        vergleichenSetupRulesContent()
        

    }
    
    private func vergleichenSetupRulesContent() {
        let rulesData = [
            ("🎯 Game Objective", "Compare the sum of your selected tiles with the computer's tiles to score points!"),
            ("🎲 Three Difficulties", """
            • Easy: Select 2 tiles from 4 (2×2 grid)
            • Medium: Select 3 tiles from 6 (2×3 grid)  
            • Hard: Select 4 tiles from 8 (2×4 grid)
            """),
            ("🀄️ Mahjong Tiles", """
            Three suits with values 1-9:
            • Dots (yuan): ●●●
            • Characters (wan): 萬萬萬
            • Bamboo (tiao): |||
            """),
            ("🎮 How to Play", """
            1. Choose your difficulty level
            2. Tap tiles to select them (they'll glow blue)
            3. Once you've selected enough tiles, all tiles reveal
            4. Your sum vs Computer sum determines the result
            """),
            ("📊 Scoring System", """
            • Win (Your sum > Computer sum): +10 points
            • Tie (Your sum = Computer sum): 0 points  
            • Lose (Your sum < Computer sum): -10 points
            
            Note: Your score cannot go below 0
            """),
            ("🏆 High Scores", "Each difficulty level tracks its own high score. Try to beat your personal best!"),
            ("💡 Strategy Tips", """
            • Remember: Higher numbers are better!
            • In harder difficulties, you select more tiles
            • Think carefully about your tile selection
            • Practice with Easy mode first
            """)
        ]
        
        var previousView: UIView = vergleichenTitleLabel
        
        for (title, content) in rulesData {
            let sectionView = vergleichenCreateRuleSection(title: title, content: content)
            vergleichenContentView.addSubview(sectionView)
            
            sectionView.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(20)
            }
            
            previousView = sectionView
        }
        
        // Update close button constraint to be relative to last section
        vergleichenCloseButton.snp.makeConstraints { make in
            make.top.equalTo(previousView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func vergleichenCreateRuleSection(title: String, content: String) -> UIView {
        let containerView = UIView()
        containerView.vergleichenApplyCardStyle()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = content
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        contentLabel.numberOfLines = 0
        containerView.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        return containerView
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        vergleichenContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // Title label constraints are set in vergleichenSetupRulesContent method
        // to avoid conflicts with dynamic content layout
    }
    
    private func vergleichenSetupActions() {
        vergleichenCloseButton.addTarget(self, action: #selector(vergleichenCloseButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func vergleichenCloseButtonTapped() {
        dismiss(animated: true)
    }
}
