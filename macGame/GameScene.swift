//
//  GameScene.swift
//  macGame
//
//  Created by  on 12/22/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {//change
    
    var startLabel = SKLabelNode()
    var iron = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    let cam = SKCameraNode()
    var repp = SKAction()
    var ironLives = 50
    var background = SKSpriteNode()
    var background2 = SKSpriteNode()
    var score = 0
    var healthLabel = SKLabelNode()
    
    //MARK: Time Update function
    override func update(_ currentTime: TimeInterval) {
       cam.position = iron.position
    }
    
   override func didMove(to view: SKView) {
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 0
        self.physicsBody =  border
        self.camera = cam
        createiron()
       setupContacts()
       createStartLabel()
    }
    

    //MARK: code for arrow keys
    override func keyDown(with event: NSEvent) {
        switch event.keyCode{
        case 125:
            print("down")
        case 126:
            print("up")
            ironJump()
        case 124:
            print("right")
           ironRight()
        case 123:
            print("left")
            ironleft()
        case 49:
            print("space")
            addChild(iron)
            iron.addChild(scoreLabel)
            iron.addChild(healthLabel)
            iron.addChild(background)
            iron.addChild(background2)
            makeiron2Spawn()
            startLabel .isHidden = true
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
   
    // MARK: Contact code
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        // When iron2 node lands on iron nodes head
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 4
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y >= iron.position.y - iron.frame.height / 4
            {
                ironLives -= 1
                healthLabel.text = "Lives: \(ironLives)"
                print("you have been hit")
                print(ironLives)
            }
        }
        // When iron2 node lands on iron nodes head
        if contact.bodyB.categoryBitMask == 2 && contact.bodyA.categoryBitMask == 4
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y >= iron.position.y - iron.frame.height / 4
            {
                ironLives -= 1
                healthLabel.text = "Lives: \(ironLives)"
                print("you have been hit")
                print(ironLives)


                if ironLives <= 0
                {

                    if let scene = SKScene(fileNamed: "GameScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        let reveal = SKTransition.doorsCloseHorizontal(withDuration: 1.5)

                        // Present the scene
                        self.view?.presentScene(scene, transition: reveal)

                    }

                }
            }

        }
        
        //When  iron node jumps on iron 2 node
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 4
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y - iron.frame.height / 2 + 1
            {
//                contact.bodyA.node?.physicsBody = nil
                contact.bodyA.node?.removeFromParent()
                print("enemy down")
                print("score Add 1")
                print(score)
                score += 1
                scoreLabel.text = "Score: \(score)"
            }
           
    //When  iron node jumps on iron 2 node
        }
        if contact.bodyB.categoryBitMask == 2 && contact.bodyA.categoryBitMask == 4
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y - iron.frame.height / 2 + 5
            {

                contact.bodyB.node?.removeFromParent()
                print("enemy down")
                print("score Add 1")
                print(score)
                score += 1
                scoreLabel.text = "Score: \(score)"
            }
            
        }
       
    }
    
    func setupContacts()
    {
        iron.physicsBody?.categoryBitMask = 4
        iron.physicsBody?.contactTestBitMask = 2
        physicsWorld.contactDelegate = self
    }
    
    //MARK: functions for sprite nodes
   
    func makeiron2Spawn()
    {
        //repeat iron2 spawning
        let sequence = SKAction.sequence([
            
            SKAction.run(createiron2),SKAction.wait(forDuration: 1.5)])
     repp = SKAction.repeatForever(sequence)
     run(repp, withKey: "iron2")
        
    }
    
 // creating sprites with code
    
    
    func createiron2()
    {
        let randomX = CGFloat.random(in: 160...900)
        let randomY = CGFloat.random(in: 80...700)
        let iron2 = SKSpriteNode(imageNamed: "iron2")
        
        iron2.size = CGSize(width: 50, height: 50)
        iron2.position = CGPoint(x: randomX, y: randomY)
        iron2.physicsBody = SKPhysicsBody(rectangleOf: iron2.frame.size)
        iron2.physicsBody?.restitution = 0;
        iron2.physicsBody?.allowsRotation = false;
        iron2.physicsBody?.affectedByGravity = true
        iron2.physicsBody?.categoryBitMask = 2
       addChild(iron2)
    }
    
    func createiron()
    {
    //create SKSprite node on screen
        iron = SKSpriteNode(color: .blue, size: CGSize(width: 75, height: 75))
    //set size position & other visual componints
        iron.position = CGPoint(x: self.frame.width * 0.5, y:  self.frame.height * 0.5)
    //add physics
        iron.physicsBody = SKPhysicsBody(rectangleOf: iron.frame.size)
        iron.physicsBody?.allowsRotation = false
        iron.physicsBody?.friction = 0
        iron.physicsBody?.isDynamic = true
        iron.physicsBody?.affectedByGravity = true
        iron.physicsBody?.restitution = 0
        iron.texture = (SKTexture(imageNamed: "iron"))
        
        // create score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 12
        scoreLabel.position = CGPoint(x: 0, y: 50)
        scoreLabel.zPosition = 10
        // scoreLabel background
        background = SKSpriteNode(color: .red, size: CGSize(width: scoreLabel.frame.width * 1.2, height: scoreLabel.frame.height * 1.2))
        background.zPosition = -3
        background.position = CGPoint(x: scoreLabel.frame.midX, y: scoreLabel.frame.midY);
        
        // create health label
        healthLabel = SKLabelNode(fontNamed: "Chalkduster")
        healthLabel.text = "Lives: \(ironLives)"
        healthLabel.fontSize = 12
        healthLabel.position = CGPoint(x: 0, y: 80)
        healthLabel.zPosition = 10
       
        
        // healthLabel background
        background2 = SKSpriteNode(color: .black, size: CGSize(width: healthLabel.frame.width * 1.2, height: healthLabel.frame.height * 1.2))
        background2.zPosition = -3
        background2.position = CGPoint(x: healthLabel.frame.midX, y: healthLabel.frame.midY);
    }
    
  
    
    // MARK: creating labels in code
    func createStartLabel()
    {
        startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "Press space to start"
        startLabel.fontSize = 50
        startLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        startLabel.zPosition = 10
        addChild(startLabel)
    }
    
    //MARK: Movement with arrow keys
     func ironRight() {
         
         let action = SKAction.applyImpulse(CGVector(dx: 25, dy:0), duration: 0.1)
         iron.run(action)
    }
    
    func ironleft() {
        let action = SKAction.applyImpulse(CGVector(dx: -25, dy:0), duration: 0.1)
        iron.run(action)
   }
    
    func ironJump() {
        let action2 = SKAction.applyImpulse(CGVector(dx: 0, dy:250), duration: 0.2)
        iron.run(action2)
   }
    
    func presentScene(SKView: NSView)
    {
        isPaused = true
    }
    
}


