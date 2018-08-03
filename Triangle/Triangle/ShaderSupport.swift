//
//  ShaderSupport.swift
//  Triangle
//
//  Created by Ecsoya on 2018/8/3.
//  Copyright © 2018 Ecsoya. All rights reserved.
//

import Foundation
import GLKit

class ShaderSupport {
    
    private var program: GLuint?
    private var vertexShader: GLuint?
    private var fragmentShader: GLuint?
    
    init(vertex vertexShaderFile: String, fragment fragmentShaderFile: String) {
        self.vertexShader = compileShader(vertexShaderFile, type: GLenum(GL_VERTEX_SHADER))
        self.fragmentShader = compileShader(fragmentShaderFile, type: GLenum(GL_FRAGMENT_SHADER))
        self.program = createProgram()
        
        //Location
        addBindings()
        
        // Link program
        if let error = linkProgram() {
            print("Error happened when link the program: \(error)")
        }
    }
    
    func apply() {
        if let p = program {
            glUseProgram(p)
        }
    }
    
    private func addBindings() {
        if let p = program {
            glBindAttribLocation(p, VertexAttributes.position.rawValue, "aPosition")
        }
    }
    
    private func linkProgram() -> String? {
        if let p = program {
            glLinkProgram(p)
            var linkStatus: GLint = 0
            glGetProgramiv(p, GLenum(GL_LINK_STATUS), &linkStatus)
            if linkStatus == GL_FALSE {
                var infoLength : GLsizei = 0
                let bufferLength : GLsizei = 1024
                glGetProgramiv(p, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
                
                let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                var actualLength : GLsizei = 0
                
                glGetProgramInfoLog(p, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
                return String(validatingUTF8: info)!
            }
            return nil
        }
        return "Program is not created"
    }
    
    private func createProgram() -> GLuint?  {
        if let vertex = vertexShader, let fragment = fragmentShader {
            let program = glCreateProgram()
            glAttachShader(program, vertex)
            glAttachShader(program, fragment)
            return program
        }
        return nil
    }
    
    private func compileShader(_ name: String, type: GLenum) -> GLuint? {
        if let path = Bundle.main.path(forResource: name, ofType: "glsl") {
            do {
                let content = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
                //Create an empty vertex/fragment shader handle
                let shader = glCreateShader(type)
                
                var string = content.utf8String
                var length = GLint(Int32(content.length))
                
                //Send the vertex/fragment source code to GL
                glShaderSource(shader, GLsizei(1), &string, &length)
                
                //Compile the shader
                glCompileShader(shader)
                
                var isComplied: GLint = 0
                glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &isComplied)
                if isComplied == GL_FALSE {
                    var infoLength : GLsizei = 0
                    let bufferLength : GLsizei = 1024
                    glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
                    
                    let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
                    var actualLength : GLsizei = 0
                    
                    glGetShaderInfoLog(shader, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
                    print("Error compile shader: \(String(validatingUTF8: info)!)")
                    
                    glDeleteShader(shader)
                    return nil
                }
                return shader
            } catch {
                print("Error reading contents of shader file: \(error)")
            }
        }
        return nil
    }
}
