//
//  SCNGeometryExtension.swift
//  StarSeer_Mk2
//
//  Created by Jordan Trana on 10/8/21.
//

import SceneKit

// Triangles
extension SCNGeometry {
    public static let triangleIndices: [Int32] = [0, 1, 2]
    
    public static func triangle(v1: SCNVector3, v2: SCNVector3, v3: SCNVector3) -> SCNGeometry {
        let source = SCNGeometrySource(vertices: [v1, v2, v3])
        let element = SCNGeometryElement(indices: triangleIndices, primitiveType: .triangles)

        return SCNGeometry(sources: [source], elements: [element])
    }
}

// Quads
extension SCNGeometry {
    
    public static let textureCord = [
        CGPoint(x: 1, y: 1),
        CGPoint(x: 0, y: 1),
        CGPoint(x: 0, y: 0),
        CGPoint(x: 1, y: 0),
    ]

    public static let indices: [CInt] = [
        0, 2, 3,
        0, 1, 2
    ]
    
    public static func square(position:SCNVector3, size:Float) -> SCNGeometry {
        return rectangle(position: position, width: size, height: size)
    }
    
    public static func rectangle(position:SCNVector3, width:Float, height:Float) -> SCNGeometry {
        
#if TARGET_OS_IOS || os(OSX)
        let w = CGFloat(width/2)
        let h = CGFloat(height/2)
#else
        let w = width/2
        let h = height/2
#endif
        return SCNGeometry.quad(v1: SCNVector3(x: position.x - w,
                                               y: position.y - h,
                                               z: position.z),
                                v2: SCNVector3(x: position.x + w,
                                               y: position.y - h,
                                               z: position.z),
                                v3: SCNVector3(x: position.x + w,
                                               y: position.y + h,
                                               z: position.z),
                                v4: SCNVector3(x: position.x - w,
                                               y: position.y + h,
                                               z: position.z))
    }
    
    public static func quad(v1:SCNVector3, v2:SCNVector3, v3:SCNVector3, v4:SCNVector3) -> SCNGeometry {

        let verticesPosition = [v1, v2, v3, v4]

        let vertexSource = SCNGeometrySource(vertices: verticesPosition)
        let srcTex = SCNGeometrySource(textureCoordinates: textureCord)
        let date = NSData(bytes: indices, length: MemoryLayout<CInt>.size * indices.count)

        let scngeometry = SCNGeometryElement(data: date as Data,
                                             primitiveType: SCNGeometryPrimitiveType.triangles, primitiveCount: 2,
                                             bytesPerIndex: MemoryLayout<CInt>.size)

        let geometry = SCNGeometry(sources: [vertexSource,srcTex],
                                   elements: [scngeometry])

        return geometry
    }
}
