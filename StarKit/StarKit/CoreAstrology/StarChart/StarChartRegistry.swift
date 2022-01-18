//
//  StarChartRegistry.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 11/29/20.
//

import Foundation

let SELECTABLE_ASPECT_BODIES:[CoreAstrology.AspectBody] = [.ascendant, .midheaven, .lunarAscendingNode, .lunarPerigee, .moon, .sun, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune] // YUGA CYCLE!

class StarChartRegistry {
    
    static let main:StarChartRegistry = StarChartRegistry()
    
    var current:StarChart = StarChart(date: Date())
    var charts:[StarChart] = []
    
    // persistant store
    var selectedAspectBodies:[CoreAstrology.AspectBody] = SELECTABLE_ASPECT_BODIES
}
