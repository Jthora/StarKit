//
//  StarChart.swift
//  EarthquakeFinderCreateML
//
//  Created by Jordan Trana on 9/24/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import Foundation
import SwiftAA


open class StarChart {
    
    // Functional
    public var celestialOffset:CoreAstrology.Ayanamsa = .galacticCenter
    public var alignments:[CoreAstrology.AspectBody:StarChartAlignment] = [:]
    public var aspects:[StarChartAspect] = []
    public var date:Date
    public var coords:GeographicCoordinates
    
    public init(date:Date, coords:GeographicCoordinates? = nil, celestialOffset:CoreAstrology.Ayanamsa = .galacticCenter){
        self.date = date
        self.coords = coords ?? GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0)
        self.celestialOffset = celestialOffset
        setupAlignments()
        setupAspects()
    }
    
    private func setupAlignments() {
        for aspectBody in CoreAstrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
            guard aspectBody != .pluto && aspectBody != .partOfSpirit && aspectBody != .partOfFortune && aspectBody != .partOfEros else {continue}
            
            alignments[aspectBody] = StarChartAlignment(aspectBody: aspectBody, date: date, coords: coords, ayanamsa:celestialOffset)
        }
    }
    
    private func setupAspects() {
        for (primaryKey,primaryAlignment) in alignments {
            for (secondaryKey,secondaryAlignment) in alignments where primaryKey != secondaryKey {
                
                guard !shouldSkipRedundant(primaryAlignment.aspectBody, secondaryAlignment.aspectBody) else { continue }
//
//                guard !aspects.contains(where: { (aspect) -> Bool in
//                    return aspect.secondaryBody == primaryAlignment.aspectBody && aspect.primaryBody == secondaryAlignment.aspectBody
//                }) else {
//                    continue
//                }
                let offset = abs(primaryAlignment.longitude - secondaryAlignment.longitude)
                let relation = CoreAstrology.AspectRelation(degrees: offset)
                
                if relation != nil {
                    let aspect = StarChartAspect(primarybody: primaryAlignment.aspectBody, relation: relation!, secondaryBody: secondaryAlignment.aspectBody)
                    aspects.append(aspect)
                }
            }
        }
        
        aspects.sort { (first, second) -> Bool in
            guard let fc = first.concentration,
                let sc = second.concentration else { return false }
            return fc > sc
        }
    }
    
    public func shouldSkipRedundant(_ first: CoreAstrology.AspectBody, _ second: CoreAstrology.AspectBody) -> Bool {
        switch first {
        case .ascendant: if second == .decendant { return true }
        case .decendant: if second == .ascendant { return true }
        case .lunarAscendingNode: if second == .lunarDecendingNode { return true }
        case .lunarDecendingNode: if second == .lunarAscendingNode { return true }
        case .imumCoeli: if second == .midheaven { return true }
        case .midheaven: if second == .imumCoeli { return true }
        case .lunarApogee: if second == .lunarPerigee { return true }
        case .lunarPerigee: if second == .lunarApogee { return true }
        default: return false
        }
        return false
    }
    
    private var _sortedAspects:[StarChartAspect]?
    public func sortedAspects(filter:[CoreAstrology.AspectBody]? = nil) -> [StarChartAspect] {
        
        var filteredAspects:[StarChartAspect]
        if let filter = filter {
            filteredAspects = aspects.filter({ (aspect) -> Bool in
                let isWhitelisted = filter.contains(aspect.primaryBody) && filter.contains(aspect.secondaryBody)
                
                return isWhitelisted
            })
        } else {
            filteredAspects = aspects
        }
        
        _sortedAspects = filteredAspects.sorted(by: { (a, b) -> Bool in
            
            guard let ac = a.concentration,
                let bc = b.concentration else {return false}
            
            if ac == bc {
                let ap = a.relation.type.priority
                let bp = b.relation.type.priority
                
                if ap == bp {
                    let apv = a.primaryBody.rawValue
                    let bpv = b.primaryBody.rawValue
                    
                    if apv == bpv {
                        let asv = a.secondaryBody.rawValue
                        let bsv = b.secondaryBody.rawValue

                        return asv > bsv
                    }
                    
                    return apv > bpv
                }
                
                return ap > bp
            }
            return ac > bc
        })
        
        self._sortedAspects?.removeAll { (aspect) -> Bool in
            for otherAspect in filteredAspects {
                if aspect.shouldRemove(comparedTo: otherAspect) {
                    return true
                }
            }
            return false
        }
        
        return _sortedAspects!
        
    }
    
    public func highestAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody]? = nil) -> Double {
        var highestConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false,
               aspect.relation.concentration > highestConcentration {
                highestConcentration = aspect.relation.concentration
            }
        }
        return highestConcentration
    }
    
    public func averageAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody]? = nil) -> Double {
        
        
        let totalConcentration:Double = totalAspectConcentration(for: category, limitList: limitList)
        return totalConcentration / max(1,aspectCount(for: category, limitList: limitList))
    }
    
    public func totalAspectConcentration(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody]? = nil) -> Double {
        var totalConcentration:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false {
                totalConcentration += aspect.relation.concentration
            }
        }
        return totalConcentration
    }
    
    public func aspectCount(for category:CoreAstrology.AspectRelation.AspectRelationCategory, limitList:[CoreAstrology.AspectBody]? = nil) -> Double {
        var count:Double = 0
        for aspect in aspects {
            if aspect.relation.category == category,
            limitList?.contains(aspect.primaryBody) != false,
            limitList?.contains(aspect.secondaryBody) != false {
                count += 1
            }
        }
        return count
    }
    
    public func produceNaturaIndex(limitList:[CoreAstrology.AspectBody]? = nil, limitType:[AstrologicalNodeType]? = nil) -> Arcana.Natura.Index {
        return Arcana.Natura.Index(alignments: self.alignments, limitList: limitList, limitType: limitType)
    }
    
    
    public func produceZodiacIndex(limitList:[CoreAstrology.AspectBody]? = nil, limitType:[AstrologicalNodeType]? = nil) -> Arcana.Zodiac.Index {
        return Arcana.Zodiac.Index(alignments: self.alignments, limitList: limitList, limitType: limitType)
    }
    
    public func globalAbsoluteGravimetricMagnitude(includeSun:Bool = false) -> Double {
        var absoluteMagnitude:Double = 0
        for aspectBody in CoreAstrology.AspectBody.allCases where aspectBody.hasGravity == true && includeSun ? true : aspectBody != .sun {
            absoluteMagnitude += aspectBody.gravimetricForceOnEarth(date: date) ?? 0
        }
        return absoluteMagnitude
    }
    
    // use ecliptic
    public func globalNetGravimetricMagnitude(includeSun:Bool = false) -> Double {
        let tensor = globalNetGravimetricTensor(includeSun: includeSun)
        return tensor.magnitude
    }
    
    public func globalNetGravimetricTensor(includeSun:Bool = false) -> CoreAstrology.GravimetricTensor {
        var globalGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        for aspectBody in CoreAstrology.AspectBody.allCases where aspectBody.hasGravity == true && includeSun ? true : aspectBody != .sun {
            globalGravitationalTensor += aspectBody.gravimetricTensor(date: date)
        }
        return globalGravitationalTensor
    }
    
    public func localAbsoluteGravimetricTensor(bodyMass:Kilogram = 155, geographicCoordinates: GeographicCoordinates, date: Date) -> CoreAstrology.GravimetricTensor {
        let localGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        
        // Slighly Less Accurate, but effective enough... Instead just add Earth Tensor using IC (opposite of mid-heaven) with Earth Gravity for Magnitude
        
        
        // Highly Accurate Version
        // Use a Geo-Location Coordinate and Earth Date
        // Inquire SwiftAA about the Locations of Each Planet during Earth Date
        // Calculate Distance between Geo-Location Coordinate and Each Planet (including Earth and Sun)
        // Fetch Angle for Localized Harmonic Calculation is Mid-Heaven (Relative to IC which can be used as the Tensor Angle for Earth Gravity)
        // Add Individual Tensor Magnitudes
        
        return localGravitationalTensor
    }
    
    public func localNetGravimetricTensor(bodyMass:Kilogram = 155, geographicCoordinates: GeographicCoordinates, date: Date) -> CoreAstrology.GravimetricTensor {
        let localGravitationalTensor = CoreAstrology.GravimetricTensor.empty
        
        // Use a Geo-Location Coordinate and Earth Date
        // Inquire SwiftAA for Angular Sky Positions of Each Planet during Earth Date relative to Earth
        // Calculate Distance between Geo-Location Coordinate and Each Planet (including Earth and Sun)
        // Angle for Localized Harmonic Calculation is Mid-Heaven (Relative to IC which can be used as the Tensor Angle for Earth Gravity)
        // Add Tensors Together
        
        
        return localGravitationalTensor
    }
    
    // GLOBAL -- Earth Center Core
    // LOCAL -- Earth Surface Geolocation
    // PERSONAL -- Individual Instance Relative to Earth Surface Location
    // INTERPERSONAL
    
    public func produceGravimetricMap() -> [String:Double] {
        var gravimetricMap:[String:Double] = [:]
        for aspectBody in CoreAstrology.AspectBody.allCases {
            
            guard let gravity = alignments[aspectBody]?.gravity else {
                continue
            }
            gravimetricMap["\(aspectBody.rawValue)Gravity"] = gravity
        }
        return gravimetricMap
    }
    
    // For Machine Learning and Persistant Store of Alignment Relation Data
    public func produceAlignmentMap(planetsOnly:Bool = false) -> [String:Double] {
        var alignmentMap:[String:Double] = [:]
        for aspectBody in CoreAstrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
            guard aspectBody != .pluto && aspectBody != .partOfSpirit && aspectBody != .partOfFortune else {continue}
            
            guard !(planetsOnly && aspectBody.massOfPlanet() == nil) else {
                continue
            }
            guard let longitude = alignments[aspectBody]?.longitude else {
                print("Alignment Map Failed - Missing AspectBody: \(aspectBody)")
                return [:]
            }
            alignmentMap["\(aspectBody)Alignment"] = longitude.value
        }
        return alignmentMap
    }
    
    // For Machine Learning and Persistant Store of Inter-Aspect Computation Data
    public func produceAspectMap() -> [String:Double] {
        var aspectMap:[String:Double] = [:]
        for primaryBody in CoreAstrology.AspectBody.allCases {
            
            // Pluto and isNightTime don't calculate well, so skip them.
            guard primaryBody != .pluto && primaryBody != .partOfSpirit && primaryBody != .partOfFortune else {continue}
            
            for secondaryBody in CoreAstrology.AspectBody.allCases where primaryBody != secondaryBody {

                // Pluto and isNightTime don't calculate well, so skip them.
                guard secondaryBody != .pluto && secondaryBody != .partOfSpirit && secondaryBody != .partOfFortune else {continue}
                
                guard let primary = alignments[primaryBody],
                let secondary = alignments[secondaryBody] else {
                    print("Alignment Map Failed - Missing AspectBody")
                    return [:]
                }
                let offset = abs(primary.longitude - secondary.longitude)
                aspectMap["\(primaryBody)\(secondaryBody)Aspect"] = offset.value
            }
        }
        return aspectMap
    }
    
    public func duplicate(celestialOffset: CoreAstrology.Ayanamsa? = nil) -> StarChart {
        let newStarChart = StarChart(date: self.date, coords: self.coords, celestialOffset: celestialOffset ?? self.celestialOffset)
        return newStarChart
    }
    
    // 3rd Gen Arkana Natura
    public func cosmicAlignment() -> CosmicAlignment {
        return CosmicAlignment(self)
    }
}




open class StarChartAlignment:AstrologicalNode { }
open class StarChartAspect:CoreAstrology.Aspect { }


extension CoreAstrology {
    
    public enum Ayanamsa {
        case galacticCenter
        case tropical
        
        public func degrees(for date:Date) -> Degree {
            switch self {
            case .galacticCenter:
                return galacticCenterOffset(for: date)
            default:
                return 0
            }
        }
        
        public func galacticCenterOffset(for date:Date) -> Degree {
            let thisTimeInterval = date.timeIntervalSince1970
            let ratio = thisTimeInterval / Ayanamsa.timeIntervalBetween
            let degreesOffset = Degree((Double(ratio) * Ayanamsa.galacticDegreesBetween) + Ayanamsa.degreesAt1970)
            return degreesOffset
        }
        
        public static let timeIntervalBetween:TimeInterval = {
            let startDate = Date(year: 1970, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1)!
            let endDate = Date(year: 2070, month: 1, day: 1, timeZone: TimeZone(secondsFromGMT: 0)!, hour: 1, minute: 1)!
            
            return endDate.timeIntervalSince(startDate)
        }()
        
        public static let galacticDegreesBetween:Double = {
            return degreesAt2070 - degreesAt1970
        }()
        
        public static let degreesAt1970:Double = 26.433333333333
        public static let degreesAt2070:Double = 27.833333333333
    }
}

