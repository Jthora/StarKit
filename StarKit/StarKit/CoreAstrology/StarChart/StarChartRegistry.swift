//
//  StarChartRegistry.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 11/29/20.
//

import Foundation

let SELECTABLE_ASPECT_BODIES:[CoreAstrology.AspectBody] = [.ascendant, .midheaven, .lunarAscendingNode, .lunarPerigee, .moon, .sun, .mercury, .venus, .mars, .jupiter, .saturn, .uranus, .neptune] // YUGA CYCLE!
open class StarChartRegistry {
    
    public static let main:StarChartRegistry = StarChartRegistry()
    
    public var current:StarChart = StarChart(date: Date())
    public var charts:[StarChart] = []
    
    // persistant store
    public var selectedAspectBodies:[CoreAstrology.AspectBody] = SELECTABLE_ASPECT_BODIES
}
