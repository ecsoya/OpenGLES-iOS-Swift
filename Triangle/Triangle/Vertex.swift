//
//  Vertex.swift
//  Triangle
//
//  Created by Ecsoya on 2018/8/3.
//  Copyright © 2018 Ecsoya. All rights reserved.
//

import Foundation
import GLKit

struct Vertex {
    var x: GLfloat = 0
    var y: GLfloat = 0
    var z: GLfloat = 0
    
    init(_ x: GLfloat, _ y: GLfloat, _ z: GLfloat) {
        self.x = x
        self.y = y
        self.z = z
    }
}

enum VertexAttributes: GLuint {
    case position = 0
}
