//
//  VergleichenColorScheme.swift
//  Vergleichen
//
//  Created by Hades on 8/23/25.
//

import UIKit

// MARK: - Color Scheme Extension
extension UIColor {
    
    // MARK: - Primary Background Colors
    static let vergleichenPrimaryBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.08, green: 0.12, blue: 0.18, alpha: 1.0) // Deep navy for dark mode
        } else {
            return UIColor(red: 0.94, green: 0.96, blue: 0.98, alpha: 1.0) // Light blue-white
        }
    }
    
    static let vergleichenSecondaryBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.12, green: 0.16, blue: 0.22, alpha: 1.0) // Darker navy
        } else {
            return UIColor(red: 0.98, green: 0.99, blue: 1.0, alpha: 1.0) // Pure white with blue tint
        }
    }
    
    // MARK: - Game Board Colors
    static let vergleichenGameBoardBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.15, green: 0.20, blue: 0.28, alpha: 0.95) // Rich dark blue
        } else {
            return UIColor(red: 0.92, green: 0.95, blue: 0.98, alpha: 0.95) // Soft blue-white
        }
    }
    
    static let vergleichenGameBoardBorder = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.25, green: 0.35, blue: 0.45, alpha: 1.0) // Steel blue
        } else {
            return UIColor(red: 0.65, green: 0.75, blue: 0.85, alpha: 1.0) // Soft blue-gray
        }
    }
    
    // MARK: - Container Colors
    static let vergleichenContainerBackground = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.18, green: 0.24, blue: 0.32, alpha: 0.9) // Deep blue container
        } else {
            return UIColor(red: 0.96, green: 0.98, blue: 1.0, alpha: 0.9) // Light container
        }
    }
    
    static let vergleichenContainerBorder = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.30, green: 0.40, blue: 0.50, alpha: 1.0) // Medium blue-gray
        } else {
            return UIColor(red: 0.70, green: 0.80, blue: 0.90, alpha: 1.0) // Light blue-gray
        }
    }
    
    // MARK: - Accent Colors (keeping existing functionality colors)
    static let vergleichenPrimaryAccent = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // Red theme
    static let vergleichenSecondaryAccent = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0) // Green theme
    static let vergleichenTertiaryAccent = UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 1.0) // Gold theme
    
    // MARK: - Gradient Colors
    static let vergleichenGradientStart = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.10, green: 0.15, blue: 0.25, alpha: 1.0) // Dark gradient start
        } else {
            return UIColor(red: 0.90, green: 0.94, blue: 0.98, alpha: 1.0) // Light gradient start
        }
    }
    
    static let vergleichenGradientEnd = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.05, green: 0.08, blue: 0.15, alpha: 1.0) // Dark gradient end
        } else {
            return UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0) // Light gradient end
        }
    }
    
    // MARK: - Shadow Colors
    static let vergleichenShadowColor = UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.black.withAlphaComponent(0.6)
        } else {
            return UIColor(red: 0.60, green: 0.70, blue: 0.80, alpha: 0.3) // Soft blue shadow
        }
    }
}

// MARK: - Gradient Helper
extension UIView {
    
    func vergleichenApplyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.vergleichenGradientStart.cgColor,
            UIColor.vergleichenGradientEnd.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.name = "vergleichenGradientLayer"
        
        // Remove existing gradient layer if any
        layer.sublayers?.removeAll { $0.name == "vergleichenGradientLayer" }
        
        // Insert at the bottom
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func vergleichenUpdateGradientFrame() {
        if let gradientLayer = layer.sublayers?.first(where: { $0.name == "vergleichenGradientLayer" }) as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    func vergleichenApplyCardStyle() {
        backgroundColor = UIColor.vergleichenContainerBackground
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.vergleichenContainerBorder.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 12
        layer.shadowColor = UIColor.vergleichenShadowColor.cgColor
    }
    
    func vergleichenApplyGameBoardStyle() {
        backgroundColor = UIColor.vergleichenGameBoardBackground
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.vergleichenGameBoardBorder.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 16
        layer.shadowColor = UIColor.vergleichenShadowColor.cgColor
    }
}
