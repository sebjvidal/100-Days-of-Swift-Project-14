//
//  WhackSlot.swift
//  100 Days of Swift Project 14
//
//  Created by Seb Vidal on 17/12/2021.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        
        addChild(sprite)
        
        setupCropNode()
    }
    
    func setupCropNode() {
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        
        cropNode.addChild(charNode)
        
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible {
            return
        }
        
        charNode.xScale = 1
        charNode.yScale = 1
        charNode.run(.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible {
            return
        }
        
        if let mudParticles = SKEmitterNode(fileNamed: "Mud") {
            mudParticles.position = CGPoint(x: 0.5, y: 0)
            mudParticles.numParticlesToEmit = 100
            
            addChild(mudParticles)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                mudParticles.removeFromParent()
            }
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        if let smokeParticles = SKEmitterNode(fileNamed: "Smoke") {
            smokeParticles.position = CGPoint(x: 0.5, y: 0.5)
            smokeParticles.numParticlesToEmit = 7
            smokeParticles.particleColor = .white
            
            addChild(smokeParticles)
            
            DispatchQueue.main.asyncAfter(deadline: .now() = 5) {
                smokeParticles.removeFromParent()
            }
        }
        
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in
            self.isVisible = false
        }
        
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}
