//
//  ForestScene.swift
//  Noble Sword
//
//  Created by Lee Davis on 5/9/21.
//

import SpriteKit

class ForestScene: SKScene {
    
    private var player: SKSpriteNode?
    private var leftControl: SKSpriteNode?
    private var attackButton: SKSpriteNode?
    private let controllerSystem = ControllerSystem.shared

    override func sceneDidLoad() {
        if let player = childNode(withName: "player") as? SKSpriteNode {
            controllerSystem.setControl(subject: player)
            self.player = player
        }

        leftControl = SKSpriteNode(color: .blue, size: CGSize(width: 250, height: 200))
        attackButton = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        
        if let leftC = leftControl,
           let rightCs = attackButton {
            camera?.addChild(leftC)
            leftC.zPosition = 150
            leftC.position.x = -115
            leftC.alpha = 0.2
            
            camera?.addChild(rightCs)
            rightCs.zPosition = 150
            rightCs.position.x = 115
            rightCs.position.y = -25
            rightCs.alpha = 0.5
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        controllerSystem.applyDirectionOnSubject()
        if let player = player {
            camera?.run(.move(to: player.position, duration: 1.0))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let leftControl = leftControl,
              let camera = camera else { return }
        
        for t in touches {
            let position = t.location(in: self)
            let convertedPos = camera.convert(position, from: self)
            
            if leftControl.contains(convertedPos) == false {
                print("Controller touched!\n\n\n")
                controllerSystem.joystick.input(position: convertedPos)
                print(position)
            }
            
            if attackButton?.contains(convertedPos) == true {
                
                DispatchQueue.main.async {
                    self.controllerSystem.attack()
                    print("Attack")
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let leftControl = leftControl,
              let camera = camera else { return }
        
        for t in touches {
            let position = t.location(in: self)
            let convertedPos = camera.convert(position, from: self)
            
            if leftControl.contains(convertedPos) == true {
                controllerSystem.joystick.input(position: convertedPos)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ControllerSystem.shared.joystick.playerTouchedDown = false
    }
}

class ControllerSystem {
    static var shared = ControllerSystem()
    
    public var joystick = Joystic()
    private var attacking = false
    private var subject = SKSpriteNode()
    private var lastDirection: Joystic.DirectionOutputType!
    
    init() {
        lastDirection = joystick.currentDirection
    }
    
    func setControl(subject: SKSpriteNode) {
        self.subject = subject
    }
    
    func attack() {
        subject.removeAllActions()
        attacking = true
        
        let action = SKAction().getAction(by: "UADown")
        subject.run(action) {
            self.attacking = false
        }
    }
    
    func applyDirectionOnSubject() {
        if joystick.playerTouchedDown == true {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                switch self.joystick.currentDirection {
                case .up:
                    self.subject.texture = SKTexture(imageNamed: "Unknown_up")
                    self.subject.run(.moveTo(y: self.subject.position.y + 75, duration: 1)) {
                        self.joystick.playerTouchedDown = false
                    }
                    break
                case .down:
                    self.subject.texture = SKTexture(imageNamed: "Unknown_down")
                    self.subject.run(.moveTo(y: self.subject.position.y - 75, duration: 1)) {
                        self.joystick.playerTouchedDown = false
                    }
                    break
                case .left:
                    self.subject.texture = SKTexture(imageNamed: "Unknown_left")
                    self.subject.run(.moveTo(x: self.subject.position.x - 75, duration: 1)) {
                        self.joystick.playerTouchedDown = false
                    }
                    break
                case .right:
                    self.subject.texture = SKTexture(imageNamed: "Unknown_right")
                    self.subject.run(.moveTo(x: self.subject.position.x + 75, duration: 1)) {
                        self.joystick.playerTouchedDown = false
                    }
                    break
                }
            }
        }
        else if attacking != true {
            subject.removeAllActions()
            joystick.shouldNotMove = false
        }
    }
}

struct Joystic {
    enum DirectionOutputType: String {
        case up, down, left, right
    }
    
    var leftControllerArea: SKSpriteNode?
    var playerTouchedDown: Bool = false
    var shouldNotMove: Bool = false
    var currentDirection: DirectionOutputType = .down
    
    private var originalPosition: CGPoint = .zero
    private var currentPosition: CGPoint = .zero
    
    private var maxXValue: CGFloat {
        return originalPosition.x + 20.0
    }
    
    private var minXValue: CGFloat {
        return originalPosition.x + -20.0
    }

    private var maxYValue: CGFloat {
        return originalPosition.y + 20.0
    }
    
    private var minYValue: CGFloat {
        return originalPosition.y + -20.0
    }
    
    mutating func input(position: CGPoint) {
            if playerTouchedDown == false {
                playerTouchedDown = true
                
                print("TouchDown \(position) \n\n")
                
                originalPosition = position
                currentPosition =  position
                
                return
            }
            else {
                currentPosition = position
                if currentPosition.x <= maxXValue,
                   currentPosition.x >= minXValue,
                   currentPosition.y <= maxYValue,
                   currentPosition.y >= minYValue { }
                else {
                    if (currentPosition.x >= maxXValue) {
                        currentDirection = .right
                        print("Moving: \(currentDirection) | \(currentPosition)")
                    } else if (currentPosition.x <= minXValue) {
                        currentDirection = .left
                        print("Moving: \(currentDirection) | \(currentPosition)")
                    } else if (currentPosition.y >= maxYValue) {
                        currentDirection = .up
                        print("Moving: \(currentDirection) | \(currentPosition)")
                    } else if (currentPosition.y <= minYValue) {
                        currentDirection = .down
                        print("Moving: \(currentDirection) | \(currentPosition)")
                    }
                    
                    //                print("Moving: \(currentPosition)")
                }
                //            switch position {
                //            case position.x > originalPosition :
                //
                //            default:
                //                return
                //            }
            }
    }
}
