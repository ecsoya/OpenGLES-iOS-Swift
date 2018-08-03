//
//  ViewController.swift
//  Triangle
//
//  Created by Ecsoya on 2018/8/3.
//  Copyright © 2018 Ecsoya. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    
    let vertices = [Vertex(0, 0.25, 0), // TOP
                    Vertex(-0.5, -0.25, 0), // LEFT
                    Vertex(0.5, -0.25, 0)] //RIGHT

    private var shadingSupport: ShaderSupport?
    
    private var vertexBuffer: GLuint = 0
    
    private func createContext() -> EAGLContext? {
        var context: EAGLContext? = nil// EAGLContext(api: EAGLRenderingAPI.openGLES3)
        if context == nil {
            context = EAGLContext(api: EAGLRenderingAPI.openGLES2)
        }
        if context == nil {
            context = EAGLContext(api: EAGLRenderingAPI.openGLES1)
        }
        return context
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = createContext() {
            if let view = self.view as? GLKView {
                view.context = context
                // This is important, the shaders will not be compiled if not set.
                EAGLContext.setCurrent(view.context)
                /*
                // Configure renderbuffers created by the view
                view.drawableColorFormat = .RGBA8888
                view.drawableDepthFormat = .format24
                view.drawableStencilFormat = .format8
                
                //Enable multisampling
                view.drawableMultisample = .multisample4X
                */
                // Load Shaders
                shadingSupport = ShaderSupport(vertex: "VertexShader", fragment: "FragmentShader")
                
                // Create vertex buffer
                createVertexBuffer()
            } else {
                print("Should never come here.")
            }
        } else {
            print("Can't init EAGLContext()")
        }
    }
    
    private func createVertexBuffer() {
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let count = vertices.count
        let size = MemoryLayout<Vertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, vertices, GLenum(GL_STATIC_DRAW))
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        //Clear the framebuffer
        glClearColor(0, 0, 0.1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        
        // Apply shaders
        shadingSupport?.apply()
        
        glEnableVertexAttribArray(VertexAttributes.position.rawValue)
        glVertexAttribPointer(VertexAttributes.position.rawValue, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<Vertex>.size), nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        glDisableVertexAttribArray(VertexAttributes.position.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

