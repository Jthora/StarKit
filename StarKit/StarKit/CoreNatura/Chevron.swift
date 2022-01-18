//
//  Chevron.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/9/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import SwiftAA


open class Chevron {
    
    public let node:AstrologicalNode?
    public var longitude:Degree
    
    public init(node:AstrologicalNode) {
        self.node = node
        longitude = node.longitude
    }
    
    public init(longitude:Degree) {
        node = nil
        self.longitude = longitude
    }
    
    public var zodiac:Arcana.Zodiac {
        return Arcana.Zodiac.from(degree: longitude)
    }
    public var subZodiac:Arcana.Zodiac {
        return Arcana.Zodiac.subFrom(degree: longitude)
    }
    public var zodiacDistribution:Double {
        return abs(subZodiacDistribution-1)
    }
    public var subZodiacDistribution:Double {
        let value = abs(((longitude.value/360)*12).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    public var decan:Arcana.Decan {
        return Arcana.Decan.from(degree: longitude)
    }
    public var subDecan:Arcana.Decan {
        return Arcana.Decan.subFrom(degree: longitude)
    }
    public var decanDistribution:Double {
        return 1-subNaturaDistribution
    }
    public var subDecanDistribution:Double {
        let value = ((longitude.value.truncatingRemainder(dividingBy: 360/36)-(360/72))/(360/72))
        return value > 0 ? value : 1 + value
    }
    
    public var natura:Arcana.Natura {
        return Arcana.Natura.from(degree: longitude)
    }
    public var subNatura:Arcana.Natura {
        return Arcana.Natura.subFrom(degree: longitude)
    }
    public var naturaDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    public var subNaturaDistribution:Double {
        let value = abs((((longitude.value-7.5)/360)*24).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    public var element:Arcana.Element {
        return Arcana.Element.from(degree: longitude)
    }
    public var subElement:Arcana.Element {
        return Arcana.Element.subFrom(degree: longitude)
    }
    public var elementDistribution:Double {
        return abs(subNaturaDistribution-1)
    }
    public var subElementDistribution:Double {
        let value = abs((((longitude.value)/360)*12).truncatingRemainder(dividingBy: 1)-0.5)
        return value > 0 ? value : 1 + value
    }
    
    public var unlockLevel:Double? {
        guard let powerLevel = powerLevel else {return nil}
        return 1-powerLevel
    }
    public var powerLevel:Double? {
        guard let exaltation = exaltation else {return nil}
        // -180 to 180: (facingAngle - angleOfTarget + 180 + 360) % 360 - 180
        // 0 - 360: (facingAngle - angleOfTarget + 180 + 360) % 360
        let angleOffset = (((longitude.value - exaltation.value) + 180 + 180 + 360).truncatingRemainder(dividingBy: 360) - 180)
        let powerLevel = abs(angleOffset)/180
        return powerLevel
    }
    public var exaltation:Degree? {
        return body?.exaltation
    }
    public var body:CoreAstrology.AspectBody? {
        return node?.aspectBody
    }
    
    
}
