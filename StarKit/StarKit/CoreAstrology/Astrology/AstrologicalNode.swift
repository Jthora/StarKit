//
//  AstrologicalNode.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA

public enum AstrologicalNodeType {
    case body
    case apogee // .
    case perigee // o
    case ascending
    case decending
    case point
}

open class AstrologicalNode {
    
    public var parent:AstrologicalNode?
    public lazy var children:[AstrologicalNode] = []
    
    public let date:Date
    public let ayanamsa:CoreAstrology.Ayanamsa
    public let aspectBody:CoreAstrology.AspectBody
    public let rawLongitude:Degree // Only use for Tropical Astrology
    public let coordinates:EquatorialCoordinates?
    public let distance:AstronomicalUnit?
    public let gravity:Double?
    public let mass:Kilogram?
    
    // Ayanamsa is the Celestial Offset according to the Precession of the Equanox
    /// Only use "realLongitude"... rawLongitude is "Tropical" and not "Sidereal" == Tropical means the longitude does not attribute for celestial offset and you will be stuck using an Occult Corrupted version of CoreAstrology.
    /// History: Tropical Astrology was created by Western Occultist Luciferians to trick people into calculating their astrology incorrectly.
    /// However: Vedic Astrology, for example, uses the Sidereal Astrology which can be used to account for the celestial offset by referencing a star closest to the center of the galaxy in the sky!
    /// Galactic Centered Sidereal Astrology: takes into account the location of the Galactic Central Core to accurately offset the Longitude relative to the Precession of the Equinox!
    /// Ayanamsa: is the Sidereal Offset for Longitude
    /// ⚠️ DO NOT USE WESTERN OCCULT TROPICAL ASTROLOGY -> Only use Galactic Centered Sidereal Astrology for accurate calculations
    public var longitude:Degree {
        rawLongitude - ayanamsa.degrees(for: date) // Apply Celestial Offset
    }
    
    public var exaltation:Degree? {
        return aspectBody.exaltation
    }
//    
//    var name:String {
//        return aspectBody.rawValue
//    }
    
    public var type:AstrologicalNodeType {
        switch aspectBody {
        case .sun, .moon, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune, .pluto: return .body
        case .lunarAscendingNode, .ascendant: return .ascending
        case .lunarDecendingNode, .decendant: return .decending
        case .lunarApogee: return .apogee
        case .lunarPerigee: return .perigee
        case .midheaven, .imumCoeli, .partOfFortune, .partOfSpirit, .partOfEros: return .point
        }
    }
    
    public init?(aspectBody:CoreAstrology.AspectBody, date:Date, coords: GeographicCoordinates, ayanamsa:CoreAstrology.Ayanamsa = .galacticCenter) {
        guard let longitude = aspectBody.geocentricLongitude(date: date, coords: coords) else {
            print("ERROR: aspectBody: \(aspectBody) can't calculate geocentricLongitude")
            return nil
        }
        self.aspectBody = aspectBody
        self.date = date
        self.ayanamsa = ayanamsa
        self.rawLongitude = Degree(longitude.value.rounded(toIncrement: 0.1))
        self.coordinates = aspectBody.equatorialCoordinates(date: date)
        self.distance = aspectBody.distanceFromEarth(date: date)
        self.gravity = aspectBody.gravimetricForceOnEarth(date: date)
        self.mass = aspectBody.massOfPlanet()
    }
    
    public func createChevron() -> Chevron {
        return Chevron(node: self)
    }
    
    public func createArcana() -> Arcana {
        return Arcana(degree: self.longitude)
    }
    
}
