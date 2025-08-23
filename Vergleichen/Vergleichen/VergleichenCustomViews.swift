//
//  VergleichenCustomViews.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import UIKit
import SnapKit

// MARK: - Custom Button
class VergleichenCustomButton: UIButton {
    
    enum VergleichenButtonStyle {
        case vergleichenPrimary
        case vergleichenSecondary
        case vergleichenDifficulty
        case vergleichenGame
    }
    
    private let vergleichenStyle: VergleichenButtonStyle
    
    init(style: VergleichenButtonStyle) {
        self.vergleichenStyle = style
        super.init(frame: .zero)
        vergleichenSetupAppearance()
        vergleichenSetupAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func vergleichenSetupAppearance() {
        let adapter = VergleichenDeviceAdapter.vergleichenShared
        layer.cornerRadius = adapter.vergleichenAdaptiveCornerRadius(12)
        layer.shadowOffset = CGSize(width: 0, height: adapter.vergleichenAdaptiveSpacing(4))
        layer.shadowOpacity = adapter.vergleichenIsIPad ? 0.4 : 0.3
        layer.shadowRadius = adapter.vergleichenAdaptiveSpacing(8)
        titleLabel?.font = adapter.vergleichenAdaptiveBoldFont(size: 18)
        
        switch vergleichenStyle {
        case .vergleichenPrimary:
            backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // Red theme
            setTitleColor(.white, for: .normal)
            layer.shadowColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 0.5).cgColor
            
        case .vergleichenSecondary:
            backgroundColor = UIColor.vergleichenContainerBackground
            setTitleColor(UIColor.label, for: .normal)
            layer.shadowColor = UIColor.vergleichenShadowColor.cgColor
            layer.borderWidth = 2
            layer.borderColor = UIColor.vergleichenContainerBorder.cgColor
            
        case .vergleichenDifficulty:
            backgroundColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0) // Green theme
            setTitleColor(.white, for: .normal)
            layer.shadowColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 0.5).cgColor
            
        case .vergleichenGame:
            backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 1.0) // Gold theme
            setTitleColor(UIColor(red: 0.3, green: 0.2, blue: 0.1, alpha: 1.0), for: .normal)
            layer.shadowColor = UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 0.5).cgColor
        }
    }
    
    private func vergleichenSetupAnimations() {
        addTarget(self, action: #selector(vergleichenButtonTouchDown), for: .touchDown)
        addTarget(self, action: #selector(vergleichenButtonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func vergleichenButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func vergleichenButtonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

// MARK: - Mahjong Tile View
class VergleichenMahjongTileView: UIView {
    
    private let vergleichenImageView = UIImageView()
    private let vergleichenSelectionOverlay = UIView()
    private let vergleichenGlowLayer = CALayer()
    
    private(set) var vergleichenTilePosition: VergleichenTilePosition?
    private(set) var vergleichenIndex: Int = 0
    
    var vergleichenOnTap: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vergleichenSetupViews()
        vergleichenSetupConstraints()
        vergleichenSetupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func vergleichenSetupViews() {
        backgroundColor = UIColor.vergleichenContainerBackground
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.vergleichenContainerBorder.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.vergleichenShadowColor.cgColor
        
        // Setup image view
        vergleichenImageView.contentMode = .scaleAspectFit
        vergleichenImageView.clipsToBounds = true
        vergleichenImageView.layer.cornerRadius = 6
        addSubview(vergleichenImageView)
        
        // Setup selection overlay
        vergleichenSelectionOverlay.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        vergleichenSelectionOverlay.layer.cornerRadius = 8
        vergleichenSelectionOverlay.isHidden = true
        addSubview(vergleichenSelectionOverlay)
        
        // Setup glow effect
        vergleichenGlowLayer.cornerRadius = 8
        vergleichenGlowLayer.shadowOffset = .zero
        vergleichenGlowLayer.shadowRadius = 10
        vergleichenGlowLayer.shadowOpacity = 0.8
        vergleichenGlowLayer.shadowColor = UIColor.systemBlue.cgColor
        vergleichenGlowLayer.isHidden = true
        layer.insertSublayer(vergleichenGlowLayer, at: 0)
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        vergleichenSelectionOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func vergleichenSetupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vergleichenHandleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func vergleichenHandleTap() {
        vergleichenOnTap?(vergleichenIndex)
        vergleichenAnimateTap()
    }
    
    private func vergleichenAnimateTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
    }
    
    func vergleichenConfigureWith(tilePosition: VergleichenTilePosition, index: Int) {
        self.vergleichenTilePosition = tilePosition
        self.vergleichenIndex = index
        
        if tilePosition.vergleichenIsRevealed {
            vergleichenImageView.image = UIImage(named: tilePosition.vergleichenTile.vergleichenImageName)
        } else {
            vergleichenImageView.image = UIImage(named: "Vergleichen_Cover")
        }
        
        vergleichenUpdateSelectionState(tilePosition.vergleichenIsSelected)
    }
    
    private func vergleichenUpdateSelectionState(_ isSelected: Bool) {
        vergleichenSelectionOverlay.isHidden = !isSelected
        vergleichenGlowLayer.isHidden = !isSelected
        
        if isSelected {
            vergleichenGlowLayer.frame = bounds
        }
    }
    
    func vergleichenAnimateReveal() {
        guard let tilePosition = vergleichenTilePosition else { return }
        
        UIView.transition(with: vergleichenImageView, duration: 0.6, options: .transitionFlipFromRight, animations: {
            self.vergleichenImageView.image = UIImage(named: tilePosition.vergleichenTile.vergleichenImageName)
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        vergleichenGlowLayer.frame = bounds
    }
}

// MARK: - Score Display View
class VergleichenScoreView: UIView {
    
    private let vergleichenTitleLabel = UILabel()
    private let vergleichenScoreLabel = UILabel()
    private let vergleichenContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vergleichenSetupViews()
        vergleichenSetupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func vergleichenSetupViews() {
        vergleichenContainer.backgroundColor = UIColor.vergleichenContainerBackground
        vergleichenContainer.layer.cornerRadius = 12
        vergleichenContainer.layer.borderWidth = 2
        vergleichenContainer.layer.borderColor = UIColor.vergleichenContainerBorder.cgColor
        vergleichenContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        vergleichenContainer.layer.shadowOpacity = 0.3
        vergleichenContainer.layer.shadowRadius = 4
        vergleichenContainer.layer.shadowColor = UIColor.black.cgColor
        addSubview(vergleichenContainer)
        
        vergleichenTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        vergleichenTitleLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        vergleichenTitleLabel.textAlignment = .center
        vergleichenTitleLabel.numberOfLines = 2
        vergleichenTitleLabel.adjustsFontSizeToFitWidth = true
        vergleichenTitleLabel.minimumScaleFactor = 0.8
        vergleichenContainer.addSubview(vergleichenTitleLabel)
        
        vergleichenScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        vergleichenScoreLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        vergleichenScoreLabel.textAlignment = .center
        vergleichenContainer.addSubview(vergleichenScoreLabel)
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vergleichenTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        vergleichenScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
    func vergleichenUpdateScore(_ score: Int, title: String) {
        vergleichenTitleLabel.text = title
        vergleichenScoreLabel.text = "\(score)"
        
        // Animate score update
        UIView.animate(withDuration: 0.3, animations: {
            self.vergleichenScoreLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.vergleichenScoreLabel.transform = .identity
            }
        }
    }
}

// MARK: - Game Header View
class VergleichenGameHeaderView: UIView {
    
    private let vergleichenTitleLabel = UILabel()
    private let vergleichenDifficultyLabel = UILabel()
    private let vergleichenInstructionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vergleichenSetupViews()
        vergleichenSetupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func vergleichenSetupViews() {
        backgroundColor = UIColor.vergleichenContainerBackground
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor.vergleichenContainerBorder.cgColor
        
        vergleichenTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        vergleichenTitleLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        vergleichenTitleLabel.textAlignment = .center
        vergleichenTitleLabel.text = "Mahjong Vergleichen"
        addSubview(vergleichenTitleLabel)
        
        vergleichenDifficultyLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenDifficultyLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
        vergleichenDifficultyLabel.textAlignment = .center
        addSubview(vergleichenDifficultyLabel)
        
        vergleichenInstructionLabel.font = UIFont.systemFont(ofSize: 14)
        vergleichenInstructionLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        vergleichenInstructionLabel.textAlignment = .center
        vergleichenInstructionLabel.numberOfLines = 0
        addSubview(vergleichenInstructionLabel)
    }
    
    private func vergleichenSetupConstraints() {
        vergleichenTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenDifficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenDifficultyLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func vergleichenConfigureWith(difficulty: VergleichenGameDifficulty) {
        vergleichenDifficultyLabel.text = "\(difficulty.rawValue) Mode"
        vergleichenInstructionLabel.text = difficulty.vergleichenDescription
    }
}
