//
//  Scene.swift
//  WhereIsDora
//
//  Created by Mars on 19/06/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import SpriteKit
import GameplayKit
import ARKit

class Scene: SKScene {
    
    let remainingDoraNode = SKLabelNode()
    var doraGeneTimer: Timer?
    
    var doraCreated = 0
    var doraRemains = 0 {
        didSet {
            remainingDoraNode.text = "\(doraRemains) Dora left in your room"
        }
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        
        // 1. Set the node
        remainingDoraNode.fontSize = 25
        remainingDoraNode.fontName = "BradleyHandITCTT-Bold"
        remainingDoraNode.color = .white
        remainingDoraNode.position = CGPoint(x: 0, y: view.frame.midY - 50)
        
        // 2. Add the node into the scene
        addChild(remainingDoraNode)
        
        // 3. Set the initial value
        doraRemains = 0
        
        // 4. Create a timer to generate Dora
        doraGeneTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {
            timer in
            self.generateDora()
        }
    }
    
    func generateDora() {
        if doraCreated == 2 {
            doraGeneTimer?.invalidate()
            doraGeneTimer = nil
            
            return
        }
        
        doraCreated += 1
        doraRemains += 1
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let randNumber = GKRandomSource.sharedRandom()
        
        let xRotation = simd_float4x4(
            SCNMatrix4MakeRotation(Float.pi * 2 * randNumber.nextUniform(), 1, 0, 0))
        
        let yRotation = simd_float4x4(
            SCNMatrix4MakeRotation(Float.pi * 2 * randNumber.nextUniform(), 0, 1, 0))
        
        let rotation = simd_mul(xRotation, yRotation)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        let transform = simd_mul(rotation, translation)
        
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func gameOver() {
        remainingDoraNode.removeFromParent()
        
        let gameOver = SKSpriteNode(imageNamed: "game_over")
        addChild(gameOver)
    }
}
