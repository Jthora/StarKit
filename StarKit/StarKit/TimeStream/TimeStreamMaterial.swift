//
//  TimeStreamMaterial.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/9/21.
//

import SceneKit

extension TimeStream {
    open class Material {
        public static func create(_ type:TimeStreamMaterialType) -> SCNMaterial {
            switch type {
            case .test:
                let material = SCNMaterial()
                material.diffuse.contents = StarKitImage(named: "testTexture")
                return material
            case .psionicStrip(starcharts:):
                let material = SCNMaterial()
                material.diffuse.contents = StarKitImage(named: "testTexture")
                return material
            }
        }
    }
}
