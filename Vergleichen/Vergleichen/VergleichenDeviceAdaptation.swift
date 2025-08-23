//
//  VergleichenDeviceAdaptation.swift
//  Vergleichen
//
//  Created by Hades on 8/22/25.
//

import UIKit

// MARK: - Device Adaptation Helper
class VergleichenDeviceAdapter {
    
    static let vergleichenShared = VergleichenDeviceAdapter()
    
    private init() {}
    
    // MARK: - Device Type Detection
    var vergleichenIsIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var vergleichenIsIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var vergleichenIsSmallDevice: Bool {
        return UIScreen.main.bounds.height <= 667 // iPhone 8 and smaller
    }
    
    var vergleichenIsLargeDevice: Bool {
        return UIScreen.main.bounds.height >= 896 // iPhone 11 Pro and larger
    }
    
    // MARK: - Screen Dimensions
    var vergleichenScreenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var vergleichenScreenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var vergleichenSafeAreaInsets: UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }
        return .zero
    }
    
    // MARK: - Adaptive Sizing
    func vergleichenAdaptiveFont(size: CGFloat) -> UIFont {
        let scaleFactor: CGFloat
        
        if vergleichenIsIPad {
            scaleFactor = 1.2
        } else if vergleichenIsSmallDevice {
            scaleFactor = 0.9
        } else if vergleichenIsLargeDevice {
            scaleFactor = 1.1
        } else {
            scaleFactor = 1.0
        }
        
        return UIFont.systemFont(ofSize: size * scaleFactor)
    }
    
    func vergleichenAdaptiveBoldFont(size: CGFloat) -> UIFont {
        let scaleFactor: CGFloat
        
        if vergleichenIsIPad {
            scaleFactor = 1.2
        } else if vergleichenIsSmallDevice {
            scaleFactor = 0.9
        } else if vergleichenIsLargeDevice {
            scaleFactor = 1.1
        } else {
            scaleFactor = 1.0
        }
        
        return UIFont.boldSystemFont(ofSize: size * scaleFactor)
    }
    
    func vergleichenAdaptiveSpacing(_ baseSpacing: CGFloat) -> CGFloat {
        let scaleFactor: CGFloat
        
        if vergleichenIsIPad {
            scaleFactor = 1.5
        } else if vergleichenIsSmallDevice {
            scaleFactor = 0.8
        } else {
            scaleFactor = 1.0
        }
        
        return baseSpacing * scaleFactor
    }
    
    func vergleichenAdaptiveCornerRadius(_ baseRadius: CGFloat) -> CGFloat {
        let scaleFactor: CGFloat
        
        if vergleichenIsIPad {
            scaleFactor = 1.3
        } else if vergleichenIsSmallDevice {
            scaleFactor = 0.9
        } else {
            scaleFactor = 1.0
        }
        
        return baseRadius * scaleFactor
    }
    
    func vergleichenAdaptiveHeight(_ baseHeight: CGFloat) -> CGFloat {
        let scaleFactor: CGFloat
        
        if vergleichenIsIPad {
            scaleFactor = 1.4
        } else if vergleichenIsSmallDevice {
            scaleFactor = 0.9
        } else {
            scaleFactor = 1.0
        }
        
        return baseHeight * scaleFactor
    }
    
    // MARK: - Game Board Sizing
    func vergleichenCalculateGameBoardSize(for difficulty: VergleichenGameDifficulty, in containerSize: CGSize) -> (tileSize: CGSize, spacing: CGFloat) {
        let gridSize = difficulty.vergleichenGridSize
        let baseSpacing: CGFloat = vergleichenIsIPad ? 12 : 8
        let spacing = vergleichenAdaptiveSpacing(baseSpacing)
        
        let availableWidth = containerSize.width - 32 // margins
        let availableHeight = containerSize.height - 32 // margins
        
        let totalSpacingWidth = CGFloat(gridSize.columns - 1) * spacing
        let totalSpacingHeight = CGFloat(gridSize.rows - 1) * spacing
        
        let tileWidth = (availableWidth - totalSpacingWidth) / CGFloat(gridSize.columns)
        let tileHeight = (availableHeight - totalSpacingHeight) / CGFloat(gridSize.rows)
        
        // Ensure tiles are square and fit within bounds
        let tileSize = min(tileWidth, tileHeight)
        
        return (CGSize(width: tileSize, height: tileSize), spacing)
    }
}

// MARK: - UIView Extensions for Adaptive Layout
extension UIView {
    
    func vergleichenSetupForDevice() {
        if VergleichenDeviceAdapter.vergleichenShared.vergleichenIsIPad {
            // iPad specific adjustments
            layer.cornerRadius = VergleichenDeviceAdapter.vergleichenShared.vergleichenAdaptiveCornerRadius(layer.cornerRadius)
            if let button = self as? UIButton {
                button.titleLabel?.font = VergleichenDeviceAdapter.vergleichenShared.vergleichenAdaptiveBoldFont(size: 18)
            }
        }
    }
    
    func vergleichenAddShadowForDevice() {
        let shadowRadius: CGFloat = VergleichenDeviceAdapter.vergleichenShared.vergleichenIsIPad ? 8 : 4
        let shadowOpacity: Float = VergleichenDeviceAdapter.vergleichenShared.vergleichenIsIPad ? 0.4 : 0.3
        
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: 0, height: shadowRadius / 2)
        layer.shadowColor = UIColor.black.cgColor
    }
}

// MARK: - UIViewController Extensions for Device Adaptation
extension UIViewController {
    
    @objc func vergleichenSetupDeviceSpecificUI() {
        // iPad specific adjustments
        if VergleichenDeviceAdapter.vergleichenShared.vergleichenIsIPad {
            // Adjust modal presentation for iPad
            if presentingViewController != nil {
                modalPresentationStyle = .formSheet
                preferredContentSize = CGSize(width: 540, height: 720)
            }
        }
    }
    
    var vergleichenSupportedInterfaceOrientations: UIInterfaceOrientationMask {
        if VergleichenDeviceAdapter.vergleichenShared.vergleichenIsIPad {
            return [.portrait, .portraitUpsideDown]
        } else {
            return .portrait
        }
    }
    
    var vergleichenPreferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    var vergleichenShouldAutorotate: Bool {
        return false
    }
}
