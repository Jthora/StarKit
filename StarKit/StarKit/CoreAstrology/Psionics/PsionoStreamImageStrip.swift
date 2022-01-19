//
//  PsionoStreamImageStrip.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/8/20.
//


import SpriteKit


public struct PsionoStreamImageStrip {
    public var cgImage:CGImage
    public let planet:CoreAstrology.AspectBody
    public let retrograde:Bool
    public let retrogradeInverted:Bool
    public let solidColors:Bool
    public var width = 1
    public let height = 1
    
    public func makeSprite(size:CGSize) -> SKSpriteNode {
        let texture = SKTexture(cgImage: cgImage)
        let sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
        return sprite
    }
}
