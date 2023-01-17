//
//  GameScene.swift
//  macGame
//
//  Created by  on 12/22/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
  

    var iron = SKSpriteNode()
    var scoreLabel: SKLabelNode!
    let cam = SKCameraNode()
    var repp = SKAction()
    var ironLives = 1000
    var background = SKSpriteNode()
    var score = 0
    
    
   override func didMove(to view: SKView) {
        
        makeiron2Spawn()
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.restitution = 0
        self.physicsBody =  border
        self.camera = cam
        createiron()
       setupContacts()
       createScoreLabel()
       followScore()
       
    }
    

    
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
//            iron.addChild(scoreLabel)
            addChild(scoreLabel)
            addChild(background)
            
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
//    override func keyDown(with event: NSEvent) {
//        switch event.keyCode {
//        case 0x31:
//            if let label = self.label {
//                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//            }
//        default:
//            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
//        }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
       cam.position = iron.position
    }
    
    func createScoreLabel()
    {
        let ix = iron.position.x
        let iy = iron.position.y

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 12
//        scoreLabel.position = CGPoint(x: 0, y: 50)
        scoreLabel.position = CGPoint(x: ix, y: iy)
        scoreLabel.zPosition = 10
      
        
        // scoreLabel background
        background = SKSpriteNode(color: .red, size: CGSize(width: scoreLabel.frame.width * 2, height: scoreLabel.frame.height * 2))
        background.zPosition = -3
        background.position = CGPoint(x: scoreLabel.frame.midX, y: scoreLabel.frame.midY);
      
        
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y + iron.frame.height / 2
            {
                print("you have been hit")
                print(ironLives)
                ironLives -= 1
            }
            
        }
        if contact.bodyB.categoryBitMask == 2 && contact.bodyA.categoryBitMask == 1
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y + iron.frame.height / 2
            {
                print("you have been hit")
                print(ironLives)
                ironLives -= 1
            }
            
        }
        
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y - iron.frame.height / 2
            {
//                contact.bodyA.node?.physicsBody = nil
                contact.bodyA.node?.removeFromParent()
                print("enemy down")
                score += 1
                print("score Add 1")
                scoreLabel.text = "Score: \(score)"
                print(score)
            }
            
        }
        if contact.bodyB.categoryBitMask == 2 && contact.bodyA.categoryBitMask == 1
        {
//            print("Contact happened at \(contact.contactPoint). iron position is \(iron.position.y - iron.frame.height / 2)")
            if contact.contactPoint.y <= iron.position.y - iron.frame.height / 2
            {
//                contact.bodyB.node?.physicsBody = nil
                contact.bodyB.node?.removeFromParent()
                print("enemy down")
                score += 1
                print("score Add 1")
                scoreLabel.text = "Score: \(score)"
                print(score)
            }
            
        }
       
    }
    
  func followIron()
    {
        repp = SKAction.repeatForever(SKAction.sequence([
                       SKAction.run(createiron2),
           SKAction.wait(forDuration: 1.4)
                   ]))

                run(repp)
    }
    
    func followScore()
      {
          repp = SKAction.repeatForever(SKAction.sequence([
                         SKAction.run(makeScoreFollow),
             SKAction.wait(forDuration: 0.0001)
                     ]))

                  run(repp)
      }
      
    
    func makeScoreFollow()
    {
        let ix = iron.position.x
        let iy = iron.position.y + 50
        
        scoreLabel.position = CGPoint(x: ix, y: iy)
        
        background.position = CGPoint(x: scoreLabel.frame.midX, y: scoreLabel.frame.midY);
    }
    
    func setupContacts()
    {
        iron.physicsBody?.categoryBitMask = 1
        
        iron.physicsBody?.contactTestBitMask = 2

        physicsWorld.contactDelegate = self
    }
   
    
    func createiron2()
    {
            let randomX = CGFloat.random(in: 160...900)
            let randomY = CGFloat.random(in: 80...700)
            let iron2 = SKSpriteNode(imageNamed: "iron2")
            iron2.size = CGSize(width: 50, height: 50)
            iron2.position = CGPoint(x: randomX, y: randomY)
            addChild(iron2)
        let texture = SKTexture(imageNamed: "iron2")
        
        iron2.physicsBody = SKPhysicsBody(texture: texture, size: CGSize(width: 50, height: 50))
            iron2.physicsBody?.restitution = 0;
            iron2.physicsBody?.allowsRotation = false;
            iron2.physicsBody?.affectedByGravity = true
        iron2.physicsBody?.categoryBitMask = 2
    }
    
    func makeiron2Spawn()
    {
        //repeat iron2 spawning
     repp = SKAction.repeatForever(SKAction.sequence([
                    SKAction.run(createiron2),
        SKAction.wait(forDuration: 5)
                ]))

             run(repp)
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
        
    }
    
     func ironRight() {
         let action = SKAction.moveBy(x:25, y:0, duration: 0.1 )
         iron.run(action)
    }
    
    func ironleft() {
        let action = SKAction.moveBy(x:-25, y:0, duration: 0.1 )
        iron.run(action)
   }
    
    func ironJump() {
        let action2 = SKAction.applyImpulse(CGVector(dx: 0, dy:250), duration: 0.2)
        iron.run(action2)
   }
    
}
