//
//  UIDevice+Extensions.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 07/05/2026.
//

#if canImport(UIKit)
import UIKit

extension UIDevice {
    static var isSimulator: Bool = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()
    
    static var isIpad: Bool = {
        return UIDevice.current.userInterfaceIdiom == .pad
    }()
    
    static var isIPhone: Bool = {
        return UIDevice.current.userInterfaceIdiom == .phone
    }()

}
#endif
