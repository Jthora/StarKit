//
//  PlanetState.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 9/26/21.
//

import Foundation


public struct PlanetState {
    public let date:Date?
    public let degrees:Double
    public let retrogradeState:RetrogradeState
    public let speed:Double
    
    public static func from(_ starCharts:[StarChart]) -> [CoreAstrology.AspectBody:[PlanetState]] {
        
        // Ensure StarCharts are Ordered
        let orderedStarCharts = starCharts.sorted { starChartA, starChartB in
            return starChartA.date < starChartB.date
        }
        
        // Prepare PlanetState List
        var planetStates:[CoreAstrology.AspectBody:[PlanetState]] = [:]
        
        // Iterate through StarCharts
        for starChart in orderedStarCharts {
            for aspectBody in CoreAstrology.AspectBody.allCases {
                
                // Prepare
                guard let degrees = starChart.alignments[aspectBody]?.longitude.value else {continue}
                if planetStates[aspectBody] == nil { planetStates[aspectBody] = [] }
                let retrogradeState:RetrogradeState
                let speed:Double
                
                // Determine Retrograde and Speed
                if let lastDegrees = planetStates[aspectBody]?.last?.degrees,
                    let lastRetrogradeState = planetStates[aspectBody]?.last?.retrogradeState {
                    if lastDegrees < degrees {
                        retrogradeState = .direct
                    } else if lastDegrees > degrees {
                        retrogradeState = .retrograde
                    } else {
                        retrogradeState = lastRetrogradeState
                    }
                    speed = degrees - lastDegrees
                } else {
                    retrogradeState = .direct
                    speed = 0
                }
                
                // Build PlanetState and Append
                planetStates[aspectBody]?.append(PlanetState(date: starChart.date,
                                                             degrees: degrees,
                                                             retrogradeState: retrogradeState,
                                                             speed: speed))
            }
        }
        return planetStates
    }
}
