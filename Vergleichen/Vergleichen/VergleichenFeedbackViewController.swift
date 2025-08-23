//
//  VergleichenFeedbackViewController.swift
//  Vergleichen
//
//  Created by Hades on 8/23/25.
//

import UIKit
import SnapKit
import MessageUI

enum VergleichenFeedbackType: String, CaseIterable {
    case general = "General Feedback"
    case bugReport = "Bug Report"
    case featureRequest = "Feature Request"
    case gameBalance = "Game Balance"
    case uiUx = "UI/UX Feedback"
    
    var vergleichenDescription: String {
        switch self {
        case .general:
            return "Share your thoughts about the game"
        case .bugReport:
            return "Report a bug or technical issue"
        case .featureRequest:
            return "Suggest new features or improvements"
        case .gameBalance:
            return "Feedback about game difficulty or balance"
        case .uiUx:
            return "Comments about user interface and experience"
        }
    }
    
    var vergleichenIcon: String {
        switch self {
        case .general:
            return "💬"
        case .bugReport:
            return "🐛"
        case .featureRequest:
            return "💡"
        case .gameBalance:
            return "⚖️"
        case .uiUx:
            return "🎨"
        }
    }
}

class VergleichenFeedbackViewController: UIViewController {
    
    // MARK: - UI Components
    private let vergleichenScrollView = UIScrollView()
    private let vergleichenContentView = UIView()
    
    private let vergleichenTitleLabel = UILabel()
    private let vergleichenSubtitleLabel = UILabel()
    
    private let vergleichenRatingContainer = UIView()
    private let vergleichenRatingLabel = UILabel()
    private let vergleichenStarStackView = UIStackView()
    private var vergleichenStarButtons: [UIButton] = []
    private var vergleichenCurrentRating: Int = 0
    
    private let vergleichenFeedbackTypeContainer = UIView()
    private let vergleichenFeedbackTypeLabel = UILabel()
    private let vergleichenFeedbackTypeStackView = UIStackView()
    private var vergleichenSelectedFeedbackType: VergleichenFeedbackType = .general
    
    private let vergleichenMessageContainer = UIView()
    private let vergleichenMessageLabel = UILabel()
    private let vergleichenMessageTextView = UITextView()
    private let vergleichenCharacterCountLabel = UILabel()
    
    private let vergleichenContactContainer = UIView()
    private let vergleichenContactLabel = UILabel()
    private let vergleichenEmailTextField = UITextField()
    private let vergleichenIncludeDeviceInfoSwitch = UISwitch()
    private let vergleichenDeviceInfoLabel = UILabel()
    
    private let vergleichenActionContainer = UIView()
    private let vergleichenSubmitButton = UIButton(type: .system)
    private let vergleichenCancelButton = UIButton(type: .system)
    
    private let vergleichenAlternativeContactContainer = UIView()
    private let vergleichenAlternativeContactLabel = UILabel()
    private let vergleichenEmailButton = UIButton(type: .system)
    private let vergleichenTwitterButton = UIButton(type: .system)
    private let vergleichenAppStoreButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let vergleichenMaxCharacters = 1000
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vergleichenSetupUI()
        vergleichenSetupConstraints()
        vergleichenSetupActions()
        vergleichenSetupDeviceSpecificUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        view.addSubview(vergleichenScrollView)
        vergleichenScrollView.addSubview(vergleichenContentView)
        vergleichenScrollView.showsVerticalScrollIndicator = false
        vergleichenScrollView.keyboardDismissMode = .onDrag
        
        // Title
        vergleichenTitleLabel.text = "We Value Your Feedback!"
        vergleichenTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        vergleichenTitleLabel.textAlignment = .center
        vergleichenTitleLabel.textColor = UIColor.label
        vergleichenTitleLabel.numberOfLines = 0
        vergleichenContentView.addSubview(vergleichenTitleLabel)
        
        // Subtitle
        vergleichenSubtitleLabel.text = "Help us improve Mahjong Vergleichen by sharing your thoughts and experiences."
        vergleichenSubtitleLabel.font = UIFont.systemFont(ofSize: 16)
        vergleichenSubtitleLabel.textAlignment = .center
        vergleichenSubtitleLabel.textColor = UIColor.secondaryLabel
        vergleichenSubtitleLabel.numberOfLines = 0
        vergleichenContentView.addSubview(vergleichenSubtitleLabel)
        
        // Rating Section
        vergleichenSetupRatingSection()
        
        // Feedback Type Section
        vergleichenSetupFeedbackTypeSection()
        
        // Message Section
        vergleichenSetupMessageSection()
        
        // Contact Section
        vergleichenSetupContactSection()
        
        // Action Buttons
        vergleichenSetupActionButtons()
        
        // Alternative Contact Methods
        vergleichenSetupAlternativeContactSection()
    }
    
    private func vergleichenSetupRatingSection() {
        vergleichenRatingContainer.vergleichenApplyCardStyle()
        vergleichenRatingContainer.layer.cornerRadius = 12
        vergleichenContentView.addSubview(vergleichenRatingContainer)
        
        vergleichenRatingLabel.text = "How would you rate your experience?"
        vergleichenRatingLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenRatingLabel.textColor = UIColor.label
        vergleichenRatingContainer.addSubview(vergleichenRatingLabel)
        
        vergleichenStarStackView.axis = .horizontal
        vergleichenStarStackView.distribution = .fillEqually
        vergleichenStarStackView.spacing = 8
        vergleichenRatingContainer.addSubview(vergleichenStarStackView)
        
        // Create star buttons
        for i in 1...5 {
            let starButton = UIButton(type: .system)
            starButton.setTitle("☆", for: .normal)
            starButton.setTitle("★", for: .selected)
            starButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            starButton.setTitleColor(UIColor.systemGray3, for: .normal)
            starButton.setTitleColor(UIColor.systemYellow, for: .selected)
            starButton.tag = i
            vergleichenStarButtons.append(starButton)
            vergleichenStarStackView.addArrangedSubview(starButton)
        }
    }
    
    private func vergleichenSetupFeedbackTypeSection() {
        vergleichenFeedbackTypeContainer.vergleichenApplyCardStyle()
        vergleichenFeedbackTypeContainer.layer.cornerRadius = 12
        vergleichenContentView.addSubview(vergleichenFeedbackTypeContainer)
        
        vergleichenFeedbackTypeLabel.text = "What type of feedback do you have?"
        vergleichenFeedbackTypeLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenFeedbackTypeLabel.textColor = UIColor.label
        vergleichenFeedbackTypeContainer.addSubview(vergleichenFeedbackTypeLabel)
        
        vergleichenFeedbackTypeStackView.axis = .vertical
        vergleichenFeedbackTypeStackView.spacing = 8
        vergleichenFeedbackTypeContainer.addSubview(vergleichenFeedbackTypeStackView)
        
        // Create feedback type buttons
        for feedbackType in VergleichenFeedbackType.allCases {
            let button = vergleichenCreateFeedbackTypeButton(for: feedbackType)
            vergleichenFeedbackTypeStackView.addArrangedSubview(button)
        }
    }
    
    private func vergleichenCreateFeedbackTypeButton(for type: VergleichenFeedbackType) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.tertiarySystemBackground
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        
        let title = "\(type.vergleichenIcon) \(type.rawValue)\n\(type.vergleichenDescription)"
        button.setTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.label, for: .normal)
        
        // Set initial selection
        if type == vergleichenSelectedFeedbackType {
            vergleichenSelectFeedbackTypeButton(button)
        }
        
        return button
    }
    
    private func vergleichenSetupMessageSection() {
        vergleichenMessageContainer.vergleichenApplyCardStyle()
        vergleichenMessageContainer.layer.cornerRadius = 12
        vergleichenContentView.addSubview(vergleichenMessageContainer)
        
        vergleichenMessageLabel.text = "Tell us more (optional)"
        vergleichenMessageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenMessageLabel.textColor = UIColor.label
        vergleichenMessageContainer.addSubview(vergleichenMessageLabel)
        
        vergleichenMessageTextView.backgroundColor = UIColor.tertiarySystemBackground
        vergleichenMessageTextView.layer.cornerRadius = 8
        vergleichenMessageTextView.layer.borderWidth = 1
        vergleichenMessageTextView.layer.borderColor = UIColor.systemGray4.cgColor
        vergleichenMessageTextView.font = UIFont.systemFont(ofSize: 16)
        vergleichenMessageTextView.textColor = UIColor.label
        vergleichenMessageTextView.delegate = self
        vergleichenMessageContainer.addSubview(vergleichenMessageTextView)
        
        vergleichenCharacterCountLabel.text = "0/\(vergleichenMaxCharacters)"
        vergleichenCharacterCountLabel.font = UIFont.systemFont(ofSize: 12)
        vergleichenCharacterCountLabel.textColor = UIColor.secondaryLabel
        vergleichenCharacterCountLabel.textAlignment = .right
        vergleichenMessageContainer.addSubview(vergleichenCharacterCountLabel)
    }
    
    private func vergleichenSetupContactSection() {
        vergleichenContactContainer.vergleichenApplyCardStyle()
        vergleichenContactContainer.layer.cornerRadius = 12
        vergleichenContentView.addSubview(vergleichenContactContainer)
        
        vergleichenContactLabel.text = "Contact Information (optional)"
        vergleichenContactLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenContactLabel.textColor = UIColor.label
        vergleichenContactContainer.addSubview(vergleichenContactLabel)
        
        vergleichenEmailTextField.backgroundColor = UIColor.tertiarySystemBackground
        vergleichenEmailTextField.layer.cornerRadius = 8
        vergleichenEmailTextField.layer.borderWidth = 1
        vergleichenEmailTextField.layer.borderColor = UIColor.systemGray4.cgColor
        vergleichenEmailTextField.placeholder = "your.email@example.com"
        vergleichenEmailTextField.keyboardType = .emailAddress
        vergleichenEmailTextField.autocapitalizationType = .none
        vergleichenEmailTextField.autocorrectionType = .no
        vergleichenEmailTextField.font = UIFont.systemFont(ofSize: 16)
        vergleichenEmailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        vergleichenEmailTextField.leftViewMode = .always
        vergleichenContactContainer.addSubview(vergleichenEmailTextField)
        
        vergleichenDeviceInfoLabel.text = "Include device information for technical support"
        vergleichenDeviceInfoLabel.font = UIFont.systemFont(ofSize: 14)
        vergleichenDeviceInfoLabel.textColor = UIColor.label
        vergleichenDeviceInfoLabel.numberOfLines = 0
        vergleichenContactContainer.addSubview(vergleichenDeviceInfoLabel)
        
        vergleichenIncludeDeviceInfoSwitch.isOn = true
        vergleichenIncludeDeviceInfoSwitch.onTintColor = UIColor.systemBlue
        vergleichenContactContainer.addSubview(vergleichenIncludeDeviceInfoSwitch)
    }
    
    private func vergleichenSetupActionButtons() {
        vergleichenActionContainer.backgroundColor = UIColor.clear
        vergleichenContentView.addSubview(vergleichenActionContainer)
        
        vergleichenSubmitButton.backgroundColor = UIColor.systemBlue
        vergleichenSubmitButton.setTitle("Send Feedback", for: .normal)
        vergleichenSubmitButton.setTitleColor(UIColor.white, for: .normal)
        vergleichenSubmitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenSubmitButton.layer.cornerRadius = 12
        vergleichenActionContainer.addSubview(vergleichenSubmitButton)
        
        vergleichenCancelButton.backgroundColor = UIColor.systemGray5
        vergleichenCancelButton.setTitle("Cancel", for: .normal)
        vergleichenCancelButton.setTitleColor(UIColor.label, for: .normal)
        vergleichenCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        vergleichenCancelButton.layer.cornerRadius = 12
        vergleichenActionContainer.addSubview(vergleichenCancelButton)
    }
    
    private func vergleichenSetupAlternativeContactSection() {
        vergleichenAlternativeContactContainer.vergleichenApplyCardStyle()
        vergleichenAlternativeContactContainer.layer.cornerRadius = 12
        vergleichenContentView.addSubview(vergleichenAlternativeContactContainer)
        
        vergleichenAlternativeContactLabel.text = "Other Ways to Reach Us"
        vergleichenAlternativeContactLabel.font = UIFont.boldSystemFont(ofSize: 18)
        vergleichenAlternativeContactLabel.textColor = UIColor.label
        vergleichenAlternativeContactLabel.textAlignment = .center
        vergleichenAlternativeContactContainer.addSubview(vergleichenAlternativeContactLabel)
        
        // Email button
        vergleichenEmailButton.backgroundColor = UIColor.systemBlue
        vergleichenEmailButton.setTitle("📧 Email Support", for: .normal)
        vergleichenEmailButton.setTitleColor(UIColor.white, for: .normal)
        vergleichenEmailButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        vergleichenEmailButton.layer.cornerRadius = 8
        vergleichenAlternativeContactContainer.addSubview(vergleichenEmailButton)
        
        // Twitter button
        vergleichenTwitterButton.backgroundColor = UIColor.systemBlue
        vergleichenTwitterButton.setTitle("🐦 Follow Us", for: .normal)
        vergleichenTwitterButton.setTitleColor(UIColor.white, for: .normal)
        vergleichenTwitterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        vergleichenTwitterButton.layer.cornerRadius = 8
        vergleichenAlternativeContactContainer.addSubview(vergleichenTwitterButton)
        
        // App Store button
        vergleichenAppStoreButton.backgroundColor = UIColor.systemGreen
        vergleichenAppStoreButton.setTitle("⭐ Rate on App Store", for: .normal)
        vergleichenAppStoreButton.setTitleColor(UIColor.white, for: .normal)
        vergleichenAppStoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        vergleichenAppStoreButton.layer.cornerRadius = 8
        vergleichenAlternativeContactContainer.addSubview(vergleichenAppStoreButton)
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
        
        // Rating Section
        vergleichenRatingContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenSubtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenRatingLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenStarStackView.snp.makeConstraints { make in
            make.top.equalTo(vergleichenRatingLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        // Feedback Type Section
        vergleichenFeedbackTypeContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenRatingContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenFeedbackTypeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenFeedbackTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(vergleichenFeedbackTypeLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        // Message Section
        vergleichenMessageContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenFeedbackTypeContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenMessageLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenMessageTextView.snp.makeConstraints { make in
            make.top.equalTo(vergleichenMessageLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(120)
        }
        
        vergleichenCharacterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenMessageTextView.snp.bottom).offset(8)
            make.trailing.bottom.equalToSuperview().inset(16)
        }
        
        // Contact Section
        vergleichenContactContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenMessageContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenContactLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(vergleichenContactLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        vergleichenDeviceInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(vergleichenEmailTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(vergleichenIncludeDeviceInfoSwitch.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(16)
        }
        
        vergleichenIncludeDeviceInfoSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(vergleichenDeviceInfoLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        // Action Buttons
        vergleichenActionContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenContactContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        vergleichenSubmitButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        vergleichenCancelButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenSubmitButton.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // Alternative Contact Section
        vergleichenAlternativeContactContainer.snp.makeConstraints { make in
            make.top.equalTo(vergleichenActionContainer.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        vergleichenAlternativeContactLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        vergleichenEmailButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenAlternativeContactLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        vergleichenTwitterButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenEmailButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        vergleichenAppStoreButton.snp.makeConstraints { make in
            make.top.equalTo(vergleichenTwitterButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func vergleichenSetupActions() {
        // Star rating buttons
        for starButton in vergleichenStarButtons {
            starButton.addTarget(self, action: #selector(vergleichenStarButtonTapped(_:)), for: .touchUpInside)
        }
        
        // Feedback type buttons
        for case let button as UIButton in vergleichenFeedbackTypeStackView.arrangedSubviews {
            button.addTarget(self, action: #selector(vergleichenFeedbackTypeButtonTapped(_:)), for: .touchUpInside)
        }
        
        // Action buttons
        vergleichenSubmitButton.addTarget(self, action: #selector(vergleichenSubmitButtonTapped), for: .touchUpInside)
        vergleichenCancelButton.addTarget(self, action: #selector(vergleichenCancelButtonTapped), for: .touchUpInside)
        
        // Alternative contact buttons
        vergleichenEmailButton.addTarget(self, action: #selector(vergleichenEmailButtonTapped), for: .touchUpInside)
        vergleichenTwitterButton.addTarget(self, action: #selector(vergleichenTwitterButtonTapped), for: .touchUpInside)
        vergleichenAppStoreButton.addTarget(self, action: #selector(vergleichenAppStoreButtonTapped), for: .touchUpInside)
        
        // Keyboard handling
        NotificationCenter.default.addObserver(self, selector: #selector(vergleichenKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(vergleichenKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Tap to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vergleichenDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func vergleichenSetupDeviceSpecificUI() {
        super.vergleichenSetupDeviceSpecificUI()
        
        // Device-specific adjustments if needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad specific adjustments
            vergleichenScrollView.contentInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        }
    }
    
    // MARK: - Actions
    @objc private func vergleichenStarButtonTapped(_ sender: UIButton) {
        vergleichenCurrentRating = sender.tag
        vergleichenUpdateStarRating()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    @objc private func vergleichenFeedbackTypeButtonTapped(_ sender: UIButton) {
        // Find the feedback type
        if let index = vergleichenFeedbackTypeStackView.arrangedSubviews.firstIndex(of: sender) {
            vergleichenSelectedFeedbackType = VergleichenFeedbackType.allCases[index]
            vergleichenUpdateFeedbackTypeSelection()
        }
    }
    
    @objc private func vergleichenSubmitButtonTapped() {
        vergleichenSubmitFeedback()
    }
    
    @objc private func vergleichenCancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func vergleichenEmailButtonTapped() {
        vergleichenOpenEmailSupport()
    }
    
    @objc private func vergleichenTwitterButtonTapped() {
        vergleichenOpenTwitter()
    }
    
    @objc private func vergleichenAppStoreButtonTapped() {
        vergleichenOpenAppStore()
    }
    
    @objc private func vergleichenDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func vergleichenKeyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        vergleichenScrollView.contentInset.bottom = keyboardHeight
        vergleichenScrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc private func vergleichenKeyboardWillHide(notification: NSNotification) {
        vergleichenScrollView.contentInset.bottom = 0
        vergleichenScrollView.scrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Helper Methods
    private func vergleichenUpdateStarRating() {
        for (index, starButton) in vergleichenStarButtons.enumerated() {
            starButton.isSelected = index < vergleichenCurrentRating
        }
    }
    
    private func vergleichenUpdateFeedbackTypeSelection() {
        for (index, button) in vergleichenFeedbackTypeStackView.arrangedSubviews.enumerated() {
            if let feedbackButton = button as? UIButton {
                let isSelected = index == VergleichenFeedbackType.allCases.firstIndex(of: vergleichenSelectedFeedbackType)
                vergleichenSelectFeedbackTypeButton(feedbackButton, isSelected: isSelected)
            }
        }
    }
    
    private func vergleichenSelectFeedbackTypeButton(_ button: UIButton, isSelected: Bool = true) {
        if isSelected {
            button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.borderWidth = 2
        } else {
            button.backgroundColor = UIColor.tertiarySystemBackground
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    private func vergleichenSubmitFeedback() {
        // Validate and collect feedback data
        let feedbackData = vergleichenCollectFeedbackData()
        
        // Show confirmation
        let alert = UIAlertController(
            title: "Thank You!",
            message: "Your feedback has been recorded. We appreciate your input and will use it to improve Mahjong Vergleichen.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Send via Email", style: .default) { _ in
            self.vergleichenSendFeedbackViaEmail(feedbackData)
        })
        
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            self.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    private func vergleichenCollectFeedbackData() -> [String: Any] {
        var data: [String: Any] = [:]
        
        data["rating"] = vergleichenCurrentRating
        data["feedbackType"] = vergleichenSelectedFeedbackType.rawValue
        data["message"] = vergleichenMessageTextView.text ?? ""
        data["email"] = vergleichenEmailTextField.text ?? ""
        data["timestamp"] = Date()
        
        if vergleichenIncludeDeviceInfoSwitch.isOn {
            data["deviceInfo"] = vergleichenGetDeviceInfo()
        }
        
        return data
    }
    
    private func vergleichenGetDeviceInfo() -> [String: Any] {
        let device = UIDevice.current
        return [
            "deviceModel": vergleichenGetDeviceModel(),
            "systemName": device.systemName,
            "systemVersion": device.systemVersion,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            "buildNumber": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown",
            "screenSize": "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)",
            "screenScale": UIScreen.main.scale
        ]
    }
    
    private func vergleichenGetDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private func vergleichenSendFeedbackViaEmail(_ feedbackData: [String: Any]) {
        guard MFMailComposeViewController.canSendMail() else {
            vergleichenShowEmailNotAvailableAlert()
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["feedback@vergleichen.com"])
        mailComposer.setSubject("Mahjong Vergleichen Feedback - \(vergleichenSelectedFeedbackType.rawValue)")
        
        var body = "Feedback Type: \(vergleichenSelectedFeedbackType.rawValue)\n"
        body += "Rating: \(vergleichenCurrentRating > 0 ? String(repeating: "⭐", count: vergleichenCurrentRating) : "Not provided")\n\n"
        
        if let message = feedbackData["message"] as? String, !message.isEmpty {
            body += "Message:\n\(message)\n\n"
        }
        
        if let email = feedbackData["email"] as? String, !email.isEmpty {
            body += "Contact Email: \(email)\n\n"
        }
        
        if let deviceInfo = feedbackData["deviceInfo"] as? [String: Any] {
            body += "Device Information:\n"
            for (key, value) in deviceInfo {
                body += "- \(key): \(value)\n"
            }
        }
        
        mailComposer.setMessageBody(body, isHTML: false)
        present(mailComposer, animated: true)
    }
    
    private func vergleichenShowEmailNotAvailableAlert() {
        let alert = UIAlertController(
            title: "Email Not Available",
            message: "Please send your feedback to feedback@vergleichen.com manually.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Copy Email", style: .default) { _ in
            UIPasteboard.general.string = "feedback@vergleichen.com"
        })
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func vergleichenOpenEmailSupport() {
        if let url = URL(string: "mailto:feedback@vergleichen.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func vergleichenOpenTwitter() {
        // Replace with actual Twitter handle
        if let url = URL(string: "https://twitter.com/vergleichen_app") {
            UIApplication.shared.open(url)
        }
    }
    
    private func vergleichenOpenAppStore() {
        // Replace with actual App Store ID
        if let url = URL(string: "https://apps.apple.com/app/id123456789") {
            UIApplication.shared.open(url)
        }
    }
    
    private func vergleichenAnimateEntrance() {
        let allViews = [
            vergleichenTitleLabel, vergleichenSubtitleLabel, vergleichenRatingContainer,
            vergleichenFeedbackTypeContainer, vergleichenMessageContainer,
            vergleichenContactContainer, vergleichenActionContainer, vergleichenAlternativeContactContainer
        ]
        
        // Initially hide all views
        allViews.forEach { $0.alpha = 0; $0.transform = CGAffineTransform(translationX: 0, y: 30) }
        
        // Animate them in sequence
        for (index, view) in allViews.enumerated() {
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                view.alpha = 1
                view.transform = .identity
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextViewDelegate
extension VergleichenFeedbackViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if updatedText.count <= vergleichenMaxCharacters {
            vergleichenCharacterCountLabel.text = "\(updatedText.count)/\(vergleichenMaxCharacters)"
            vergleichenCharacterCountLabel.textColor = updatedText.count > vergleichenMaxCharacters * 9 / 10 ? .systemRed : .secondaryLabel
            return true
        }
        return false
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension VergleichenFeedbackViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                let alert = UIAlertController(title: "Thank You!", message: "Your feedback has been sent successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true)
                })
                self.present(alert, animated: true)
            }
        }
    }
}
