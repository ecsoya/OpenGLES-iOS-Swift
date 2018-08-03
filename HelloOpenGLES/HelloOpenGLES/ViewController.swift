//
//  ViewController.swift
//  HelloOpenGLES
//
//  Created by Ecsoya on 2018/8/3.
//  Copyright © 2018 Ecsoya. All rights reserved.
//

import UIKit
import GLKit

class ViewController: GLKViewController {
    
    private func createContext() -> EAGLContext? {
        var context = EAGLContext(api: EAGLRenderingAPI.openGLES3)
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
                
                // Configure renderbuffers created by the view
                view.drawableColorFormat = .RGBA8888
                view.drawableDepthFormat = .format24
                view.drawableStencilFormat = .format8
                
                //Enable multisampling
                view.drawableMultisample = .multisample4X
            } else {
                print("Never come here.")
            }
        } else {
            print("Can't init EAGLContext()")
        }
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        //Clear the framebuffer
        glClearColor(1, 0, 0, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

