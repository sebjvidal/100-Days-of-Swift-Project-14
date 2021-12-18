//
//  GameScene.swift
//  100 Days of Swift Project 14
//
//  Created by Seb Vidal on 17/12/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots: [WhackSlot] = []
    
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var popupTime = 0.85
    var numRounds = 0
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupScoreLabel()
        setupSlots()
        startGame()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
    }
    
    func setupScoreLabel() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        
        addChild(gameScore)
    }
    
    func setupSlots() {
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }
    
    func startGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            gameOver()
            
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func gameOver() {
        for slot in slots {
            slot.hide()
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = "Final Score: \(score)"
        
        addChild(gameOver)
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        
        addChild(slot)
        
        slots.append(slot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else {
                return
            }
            
            if !whackSlot.isVisible || whackSlot.isHidden {
                continue
            }
            
            whackSlot.hit()
            
            if node.name == "charFriend" {
                tappedFriend(whackSlot: whackSlot)
            } else if node.name == "charEnemy" {
                tappedEnemy(whackSlot: whackSlot)
            }
        }
    }
    
    func tappedFriend(whackSlot: WhackSlot) {
        score -= 5
        
        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:false))
    }
    
    func tappedEnemy(whackSlot: WhackSlot) {
        whackSlot.charNode.xScale = 0.85
        whackSlot.charNode.yScale = 0.85
        
        score += 5
        
        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
    }
    
}
