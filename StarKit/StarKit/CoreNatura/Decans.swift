//
//  Decans.swift
//  PsiKit
//
//  Created by Jordan Trana on 11/28/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

extension Arcana {
    
    /// 36 Decans - Egyptian Conversion
    public enum Decan: Int, CaseIterable {
        
        public static let count:Double = 36
        
        public static func from(degree:Degree) -> Decan {
            let decanIndex = Int((degree.value/(count/360)).truncatingRemainder(dividingBy: count))
            return Decan(rawValue: decanIndex)!
        }
        
        public static func subFrom(degree: Degree) -> Decan {
            let decanAccurate = (degree.value/(count/360)).truncatingRemainder(dividingBy: count)
            if decanAccurate.truncatingRemainder(dividingBy: 1) > 0.5 {
                var index = abs(Int(decanAccurate)+1)
                if index > Int(count)-1 { index = 0 }
                return Decan(rawValue: index)!
            } else {
                var index = Int(decanAccurate)-1
                if index < 0 { index = Int(count)-1 }
                return Decan(rawValue: index)!
            }
        }
        
        /// Aries
        case child // 1
        case star // 2
        case pioneer // 3
        
        /// Taurus
        case manifestation
        case teacher
        case natural
        
        /// Gemini
        case freedom
        case newLanguage
        case seeker
        
        /// Cancer
        case empath
        case unconventional
        case pursuader
        
        /// Leo
        case authority
        case balancedStrength
        case leadership
        
        /// Virgo
        case systemBuilders
        case enigma
        case literalist
        
        /// Libra
        case perfection
        case society
        case thearter
        
        /// Scorpio
        case intensity
        case depth
        case charm
        
        ///Sagittarius
        case independent
        case originator
        case titan
        
        /// Capricorn
        case ruler
        case determination
        case dominance
        
        /// Aquarius
        case genius
        case youthAndEase
        case acceptance
        
        /// Pisces
        case spirit
        case loner
        case dancersAndDreamers
        
        public var degrees:Double {
            return Double(self.rawValue) * (360/Decan.count)
        }
        
        public var zodiac:Zodiac {
            switch self {
            case .child, .star, .pioneer: return .aries
            case .manifestation, .teacher, .natural: return .taurus
            case .freedom, .newLanguage, .seeker: return .gemini
            case .empath, .unconventional, .pursuader: return .cancer
            case .authority, .balancedStrength, .leadership: return .leo
            case .systemBuilders, .enigma, .literalist: return .virgo
            case .perfection, .society, .thearter: return .libra
            case .intensity, .depth, .charm: return .scorpio
            case .independent, .originator, .titan: return .sagittarius
            case .ruler, .determination, .dominance: return .capricorn
            case .genius, .youthAndEase, .acceptance: return .aquarius
            case .spirit, .loner, .dancersAndDreamers: return .pisces
            }
        }
    }
    
}
