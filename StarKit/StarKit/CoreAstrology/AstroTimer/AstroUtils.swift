//
//  AstroUtils.swift
//  HelmKit
//
//  Created by Jordan Trana on 7/28/18.
//  Copyright © 2018 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA


struct AstroUtils {
    
    /// Get Closest Date for Aspect realtive to Date
    
    static let astrologyPlanets:[CoreAstrology.AspectBody] = [.mercury,
                                                     .venus,
                                                     .mars,
                                                     .jupiter,
                                                     .saturn,
                                                     .uranus,
                                                     .neptune,
                                                     .pluto]
    
    static func getNextAspectsBetweenMoonAndPlanets(date:Date, coords:GeographicCoordinates, useOrbRange:Bool = true) -> [AstroAspectTimeReport] {
        var reports:[AstroAspectTimeReport] = []
        
        for planet in astrologyPlanets {
            if let report = getClosestAspectForMoon(with: planet, date:date, coords:coords) {
                guard !useOrbRange || report.withinRange else {  continue }
                reports.append(report)
            }
        }
        
        return reports
    }
    
    // if returns nil that means none within timeRange
    static func getClosestAspectForMoon(closeTo date:Date) -> AstroAspectTimeReport? {
        
        let moonCurrentAngle = Astronomy.moonPhaseAngle()
        let relation = closestAspectRelationForAngle(angle: moonCurrentAngle)
        
        let aspect = CoreAstrology.Aspect(primarybody: .moon, relation: relation, secondaryBody: .sun)
        return AstroAspectTimeReport(date: date, aspect: aspect, distance: relation.degrees)
    }
    
    static func getClosestAspectForMoon(with planet:CoreAstrology.AspectBody, date:Date, coords:GeographicCoordinates) -> AstroAspectTimeReport? {
        
        let moonPhaseAngle = Astronomy.moonPhaseAngle()
        guard let planetPhaseAngle = planet.geocentricLongitude(date: date, coords: coords) else {
            return nil
        }
        let relation = closestAspectRelationForAngle(angle: moonPhaseAngle - planetPhaseAngle)
        
        let orbitPeriod = planet.orbitPeriodInSeconds()
        let secondsUntil:TimeInterval = TimeInterval(relation.degrees.value/360.0)*orbitPeriod
        let date = Date(timeIntervalSinceNow: secondsUntil)
        
        let aspect = CoreAstrology.Aspect(primarybody: .moon, relation: relation, secondaryBody: .sun)
        return AstroAspectTimeReport(date: date, aspect: aspect, distance: relation.degrees)
    }
    
    static func closestAspectRelationForAngle(angle:Degree) -> (CoreAstrology.AspectRelation) {
        var closestAspectRelation:CoreAstrology.AspectRelationType = .opposition
        var degreeDiff:Degree = 360
        
        for aspect in CoreAstrology.AspectRelationType.allCases {
            let thisDegreeDiff:Degree = abs(aspect.degree - angle)
            if degreeDiff > thisDegreeDiff {
                closestAspectRelation = aspect
                degreeDiff = thisDegreeDiff
            }
        }
        
        let aspectRelation = CoreAstrology.AspectRelation(degrees: degreeDiff, forceWith: closestAspectRelation)
        return aspectRelation
    }
    
    static func closestAspectRelation(for angle:Degree) -> CoreAstrology.AspectRelation {
        return closestAspectRelationForAngle(angle: angle)
    }
}

struct AstroAspectTimeReport {
    
    /// Date and Time the Aspect is to occur
    var date:Date
    
    /// The Aspect itself
    var aspect:CoreAstrology.Aspect
    
    /// Angle Distance
    var distance:Degree
    
    /// Convenience
    var primaryBody:CoreAstrology.AspectBody { return aspect.primaryBody }
    var secondaryBody:CoreAstrology.AspectBody { return aspect.secondaryBody }
    var relation:CoreAstrology.AspectRelation { return aspect.relation }
    
    /// Calculations for Primary Body Distance
    var primaryBodyDistance:Meter { return 0 }
    var primaryBodyAngleRemaining:Degree { return 0 }
    
    /// Calculations for Secondary Body Distance
    var secondBodyDistance:Meter { return 0 }
    var secondBodyAngleRemaining:Degree { return 0 }
    
    /// Calculations for remainin
    var timeOffset:TimeInterval { return date.timeIntervalSince(Date()) }
    
    /// Is this aspect within Orb Range
    var withinRange:Bool { return relation.type.orb > abs(distance) }
}




extension Astronomy.PlanetsAvailable {
    func toAstrology() -> CoreAstrology.AspectBody {
        switch self {
        case .earth: return .sun
        case .mercury: return .mercury
        case .venus: return .venus
        case .mars: return .mars
        case .jupiter: return .jupiter
        case .saturn: return .saturn
        case .uranus: return .uranus
        case .neptune: return .neptune
        case .pluto: return .pluto
        }
    }
    
    func toPlanet() -> Planet? {
        switch self {
        case .mercury: return Planet.mercury
        case .venus: return Planet.venus
        case .mars: return Planet.mars
        case .jupiter: return Planet.jupiter
        case .saturn: return Planet.saturn
        case .uranus: return Planet.uranus
        case .neptune: return Planet.neptune
        case .pluto: return Planet.pluto
        default: return nil
        }
    }
}

extension CoreAstrology.AspectBody {
    
    func celestialLongitude(_ date:Date? = nil) -> Degree? {
        if let date = date {
            switch self {
            case .sun: return Planet.earthAA(date).position().celestialLongitude
            case .mercury: return Planet.mercuryAA(date).position().celestialLongitude
            case .venus: return Planet.venusAA(date).position().celestialLongitude
            case .mars: return Planet.marsAA(date).position().celestialLongitude
            case .jupiter: return Planet.jupiterAA(date).position().celestialLongitude
            case .saturn: return Planet.saturnAA(date).position().celestialLongitude
            case .uranus: return Planet.uranusAA(date).position().celestialLongitude
            case .neptune: return Planet.neptuneAA(date).position().celestialLongitude
            case .pluto: return Planet.plutoAA(date).position().celestialLongitude
            default: return nil
            }
        }
        switch self {
        case .sun: return Planet.earthAA.position().celestialLongitude
        case .mercury: return Planet.mercuryAA.position().celestialLongitude
        case .venus: return Planet.venusAA.position().celestialLongitude
        case .mars: return Planet.marsAA.position().celestialLongitude
        case .jupiter: return Planet.jupiterAA.position().celestialLongitude
        case .saturn: return Planet.saturnAA.position().celestialLongitude
        case .uranus: return Planet.uranusAA.position().celestialLongitude
        case .neptune: return Planet.neptuneAA.position().celestialLongitude
        case .pluto: return Planet.plutoAA.position().celestialLongitude
        default: return nil
        }
    }
    
    func toAstronomy() -> Astronomy.PlanetsAvailable? {
        switch self {
        case .sun: return .earth
        case .mercury: return .mercury
        case .venus: return .venus
        case .mars: return .mars
        case .jupiter: return .jupiter
        case .saturn: return .saturn
        case .uranus: return .uranus
        case .neptune: return .neptune
        case .pluto: return .pluto
        default: return nil
        }
    }
    
    func orbitPeriodInSeconds() -> TimeInterval {
        return Planet.planet(self.toAstronomy()!).orbitPeriodInSeconds
    }
    
    func heliocentricPosition() -> Degree {
        return Planet.planet(self.toAstronomy()!).heliocentricPosition!
    }
}
