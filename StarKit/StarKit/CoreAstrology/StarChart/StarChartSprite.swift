//
//  StarChartSprite.swift
//  EarthquakeFinder
//
//  Created by Jordan Trana on 8/19/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import SpriteKit
import SwiftAA


open class StarChartSprite {
    
    static var starChart = StarChart(date: Date(), coords: GeographicCoordinates(positivelyWestwardLongitude: 0, latitude: 0))
    
}



open class StarChartSpriteNode:SKSpriteNode {
    
    public enum StarChartDiskImageType {
        case linkRing
        case informal
        case formal_unlock
        case formal_power
        case differencial
        
        public var imageName:String {
            switch self {
                case .linkRing: return "cypherDisk_chevron36_linkRing"
                case .informal: return "cypherDisk_chevron36_informal"
                case .formal_power: return "cypherDisk_chevron36_differencial_power"
                case .formal_unlock: return "cypherDisk_chevron36_differencial_unlockable"
                case .differencial: return "cypherDisk_chevron36_formal"
            }
        }
        
        public var cgImage:CGImage {
            return UIImage(named: imageName)!.cgImage!
        }
        
        public var texture:SKTexture {
            return SKTexture(cgImage: cgImage)
        }
    }
    
    public enum StarChartDiskMaskType {
        case orb7_5
        case orb3_75
        case orb1_875
        case orb0_9375
        
        public var imageName:String {
            switch self {
                case .orb7_5: return "CosmicAlignment_Mask-7.5DegOrb"
                case .orb3_75: return "CosmicAlignment_Mask-3.75DegOrb"
                case .orb1_875: return "CosmicAlignment_Mask-1.875DegOrb"
                case .orb0_9375: return "CosmicAlignment_Mask-0.9375DegOrb"
            }
        }
        
        public var cgImage:CGImage {
            return UIImage(named: imageName)!.cgImage!
        }
        
        public var texture:SKTexture {
            return SKTexture(cgImage: cgImage)
        }
    }
    
    public static func create(imageType:StarChartDiskImageType, maskType:StarChartDiskMaskType, maskRotation:CGFloat = 0, size:CGSize = CGSize(width: 512, height: 512)) -> StarChartSpriteNode {
        
        let image:CGImage = imageType.cgImage
        let mask:CGImage = maskType.cgImage.imageRotatedByDegrees(degrees: maskRotation).convertToGrayScale()
        
        let masked = image.masking(mask)!
        let maskedTexture = SKTexture(cgImage: masked)
        let sprite = StarChartSpriteNode(texture: maskedTexture, color: .clear, size: size)
        sprite.position = CGPoint(x: size.width/2, y: size.height/2)
        return sprite
    }
    
    public static func create(alignments:[StarChartAlignment], size:CGSize = CGSize(width:512, height:512)) -> StarChartSpriteNode {
        
        let width = Int(size.width)
        let height = Int(size.height)
        
        let linkRing:CGImage = StarChartDiskImageType.linkRing.cgImage
        let informalChevrons:CGImage = StarChartDiskImageType.informal.cgImage
        let powerChevrons:CGImage = StarChartDiskImageType.formal_power.cgImage
        let unlockChevrons:CGImage = StarChartDiskImageType.formal_unlock.cgImage
        let differencialChevrons:CGImage = StarChartDiskImageType.differencial.cgImage
        
        var linkRingMask:CGImage = CGImage.blankMask(width: width, height: height)
        var informalChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var powerChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var unlockChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        var differencialChevronsMask:CGImage = CGImage.blankMask(width: width, height: height)
        
        for alignment in alignments {
            
            let additionalLinkRingMask = StarChartDiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            linkRingMask = linkRingMask.mergeMask(with: additionalLinkRingMask)
                
            let additionalInformalChevronsMask = StarChartDiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            informalChevronsMask = informalChevronsMask.mergeMask(with: additionalInformalChevronsMask)
                
            let additionalPowerChevronsMask = StarChartDiskMaskType.orb1_875.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            powerChevronsMask = powerChevronsMask.mergeMask(with: additionalPowerChevronsMask)
                
            let additionalUnlockChevronsMask = StarChartDiskMaskType.orb7_5.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            unlockChevronsMask = unlockChevronsMask.mergeMask(with: additionalUnlockChevronsMask)
            
            let additionalDifferencialRingMask = StarChartDiskMaskType.orb3_75.cgImage.imageRotatedByDegrees(degrees: CGFloat(alignment.longitude.value))
            differencialChevronsMask = differencialChevronsMask.mergeMask(with: additionalDifferencialRingMask)
        }
        
        let maskedLinkRing = linkRing.masking(linkRingMask)!
        let maskedInformalChevrons = informalChevrons.masking(informalChevronsMask)!
        let maskedPowerChevrons = powerChevrons.masking(powerChevronsMask)!
        let maskedUnlockChevrons = unlockChevrons.masking(unlockChevronsMask)!
        let maskedDifferencialChevrons = differencialChevrons.masking(differencialChevronsMask)!
        
        let combinedImage = CGImage.blank(width: width, height: height).merge(with: [maskedLinkRing,
                                                                                maskedInformalChevrons,
                                                                                maskedPowerChevrons,
                                                                                maskedUnlockChevrons,
                                                                                maskedDifferencialChevrons],
                                                                         blendMode: .normal)
        
        //let testImage = combinedImage.masking(buildAnglularCircleMask(in: combinedImage.rect, radius: CGFloat(combinedImage.width)/2.0, degrees: 7.5))!
        
        let powereredRingZonesTexture = SKTexture(cgImage: combinedImage)
        
        let sprite = StarChartSpriteNode(texture: powereredRingZonesTexture, color: .clear, size: size)
        
        sprite.position = CGPoint(x: size.width/2, y: size.height/2)
        
        return sprite
    }
}
