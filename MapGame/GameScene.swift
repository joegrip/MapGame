//
//  GameScene.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 4/28/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var unitNode : Unit? //SKShapeNode?
    private var squareNode : SKShapeNode?
    private var spinnyNode : SKShapeNode?
    private var unitSelected: Bool = false
    private var id: Int = 0
    var units: Array<Unit> = Array()
    let board = Board(r: 10, c: 10)
    let gridArray: Array<SKShapeNode> = Array()
    let selectMoveColor = SKColor.blue
    let selectAttackColor = SKColor(red:80,green: 0,blue:
        0,alpha: 1)
    let tileColor = SKColor.lightGray



    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        createGrid()
        setPieces()
    }
    
    func addCannon(r: Int, c: Int, team: Int)
    {
          
        let unitNode = Cannon.init(xPosition: r, yPosition: c,side: Int(self.size.height)/(board.NUM_ROWS*4), id: self.id,team: team)
        self.id = self.id + 1

          unitNode.position = CGPoint(x: xUnitGridToCoord(c: unitNode.xPosition), y: yUnitGridToCoord(r: unitNode.yPosition))
          self.addChild(unitNode)
          units.append(unitNode)
    }
    
    func addInfantry(r: Int, c: Int, team: Int)
    {
        let unitNode = Infantry.init(xPosition: r, yPosition: c,side: Int(self.size.height)/(board.NUM_ROWS*4), id: self.id,team: team)
        self.id = self.id + 1
        unitNode.position = CGPoint(x: xUnitGridToCoord(c: unitNode.xPosition), y: yUnitGridToCoord(r: unitNode.yPosition))
        self.addChild(unitNode)
        units.append(unitNode)
    }
    
    func addCavalry(r: Int, c: Int, team: Int)
    {
        let unitNode = Cavalry.init(xPosition: r, yPosition: c,side: Int(self.size.height)/(board.NUM_ROWS*4), id: self.id,team: team)
        self.id = self.id + 1
        unitNode.position = CGPoint(x: xUnitGridToCoord(c: unitNode.xPosition), y: yUnitGridToCoord(r: unitNode.yPosition))
        self.addChild(unitNode)
        units.append(unitNode)
    }
    
    func createGrid()
    {

        for r in 0...board.NUM_ROWS-1
        {
            for c in 0...board.NUM_COLUMNS-1
            {
                self.squareNode = SKShapeNode.init(rectOf: CGSize.init(width: Int(self.size.height)/(2*board.NUM_ROWS), height: Int(self.size.height)/(2*board.NUM_COLUMNS)), cornerRadius: 0)
                              
 
                if let squareNode = self.squareNode
                {
                    squareNode.lineWidth = 3
                    squareNode.fillColor = tileColor
                    squareNode.name = String(r)+String(c)
                    squareNode.strokeColor = SKColor.black
                    squareNode.position = CGPoint(x: xUnitGridToCoord(c: c), y: yUnitGridToCoord(r: r))
                    squareNode.zPosition = 0.5
                    board.grid[r,c] = squareNode
                        self.addChild(squareNode)
                
                    }

            }
        }
    }
    
    func setPieces()
    {
        //Team 0
        addCannon(r:0,c:2,team:0)
        addCannon(r:0,c:4,team:0)
        addCannon(r:0,c:6,team:0)
        addCannon(r:0,c:8,team:0)
        for i in 2...board.NUM_COLUMNS-3
        {
            addInfantry(r: 1, c: i, team: 0)
        }

        addCavalry(r: 1, c: 0, team: 0)
        addCavalry(r: 1, c: 1, team: 0)
        addCavalry(r: 1, c: 9, team: 0)
        addCavalry(r: 1, c: 10, team: 0)

        
        //Team 1
        addCannon(r:board.NUM_ROWS-1,c:2,team:1)
        addCannon(r:board.NUM_ROWS-1,c:4,team:1)
        addCannon(r:board.NUM_ROWS-1,c:6,team:1)
        addCannon(r:board.NUM_ROWS-1,c:8,team:1)
        for i in 2...board.NUM_COLUMNS-3
        {
            addInfantry(r: board.NUM_ROWS-2, c: i, team: 1)
        }

        addCavalry(r: board.NUM_ROWS-2, c: 0, team: 1)
        addCavalry(r: board.NUM_ROWS-2, c: 1, team: 1)
        addCavalry(r: board.NUM_ROWS-2, c: 9, team: 1)
        addCavalry(r: board.NUM_ROWS-2, c: 10, team: 1)



    }



    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
 

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = selectMoveColor
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = selectAttackColor
            self.addChild(n)
        }
    }
    
    
    func highlightFastMove(r: Int, c: Int)
    {
        if(r-2 > -1)
          {

              if let squareNode = board.grid[r-2,c]
              {
                  squareNode.fillColor = selectMoveColor
              }
              if(c-2 > -1)
              {
                  if let squareNode = board.grid[r-2,c-2]
                  {
                      squareNode.fillColor = selectMoveColor
                  }
              }
              if(c+2 < board.NUM_COLUMNS)
              {
                  if let squareNode = board.grid[r-2,c+2]
                  {
                      squareNode.fillColor = selectMoveColor
                  }
              }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r-2,c-1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r-2,c+1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
          }
          if(c-2 > -1)
          {
              if let squareNode = board.grid[r,c-2]
              {
                  squareNode.fillColor = selectMoveColor
              }
            if(r-1 > -1)
            {
                if let squareNode = board.grid[r-1,c-2]
                 {
                     squareNode.fillColor = selectMoveColor
                 }
            }
            if(r+1 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+1,c-2]
                 {
                     squareNode.fillColor = selectMoveColor
                 }
            }
          }
          if(c+2 < board.NUM_COLUMNS)
          {
              if let squareNode = board.grid[r,c+2]
              {
                  squareNode.fillColor = selectMoveColor
              }
            if(r-1 > -1)
            {
                if let squareNode = board.grid[r-1,c+2]
                 {
                     squareNode.fillColor = selectMoveColor
                 }
            }
            if(r+1 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+1,c+2]
                 {
                     squareNode.fillColor = selectMoveColor
                 }
            }
          }
          if(r+2 < board.NUM_ROWS)
          {

              if let squareNode = board.grid[r+2,c]
              {
                  squareNode.fillColor = selectMoveColor
              }
              if(c-2 > -1)
              {
                  if let squareNode = board.grid[r+2,c-2]
                  {
                      squareNode.fillColor = selectMoveColor
                  }
              }
              if(c+2 < board.NUM_COLUMNS)
              {
                  if let squareNode = board.grid[r+2,c+2]
                  {
                      squareNode.fillColor = selectMoveColor
                  }
              }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r+2,c-1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r+2,c+1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
          }
    }
    func highlightRangedAttack(r: Int, c: Int)
    {
        if(r-2 > -1)
          {

              if let squareNode = board.grid[r-2,c]
              {
                  squareNode.fillColor = selectAttackColor
              }
              if(c-2 > -1)
              {
                  if let squareNode = board.grid[r-2,c-2]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
              if(c+2 < board.NUM_COLUMNS)
              {
                  if let squareNode = board.grid[r-2,c+2]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r-2,c-1]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r-2,c+1]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
          }
          if(c-2 > -1)
          {
              if let squareNode = board.grid[r,c-2]
              {
                  squareNode.fillColor = selectAttackColor
              }
            if(r-1 > -1)
            {
                if let squareNode = board.grid[r-1,c-2]
                 {
                     squareNode.fillColor = selectAttackColor
                 }
            }
            if(r+1 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+1,c-2]
                 {
                     squareNode.fillColor = selectAttackColor
                 }
            }
          }
          if(c+2 < board.NUM_COLUMNS)
          {
              if let squareNode = board.grid[r,c+2]
              {
                  squareNode.fillColor = selectAttackColor
              }
            if(r-1 > -1)
            {
                if let squareNode = board.grid[r-1,c+2]
                 {
                     squareNode.fillColor = selectAttackColor
                 }
            }
            if(r+1 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+1,c+2]
                 {
                     squareNode.fillColor = selectAttackColor
                 }
            }
          }
          if(r+2 < board.NUM_ROWS)
          {

              if let squareNode = board.grid[r+2,c]
              {
                  squareNode.fillColor = selectAttackColor
              }
              if(c-2 > -1)
              {
                  if let squareNode = board.grid[r+2,c-2]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
              if(c+2 < board.NUM_COLUMNS)
              {
                  if let squareNode = board.grid[r+2,c+2]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r+2,c-1]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r+2,c+1]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
          }
    }

    func highlightMoves(r: Int, c: Int)
    {
        if(r-1 > -1)
        {

            if let squareNode = board.grid[r-1,c]
            {
                squareNode.fillColor = selectMoveColor
            }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r-1,c-1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r-1,c+1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
        }
        if(c-1 > -1)
        {
            if let squareNode = board.grid[r,c-1]
            {
                squareNode.fillColor = selectMoveColor
            }
        }
        if(c+1 < board.NUM_COLUMNS)
        {
            if let squareNode = board.grid[r,c+1]
            {
                squareNode.fillColor = selectMoveColor
            }
        }
        if(r+1 < board.NUM_ROWS)
        {

            if let squareNode = board.grid[r+1,c]
            {
                squareNode.fillColor = selectMoveColor
            }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r+1,c-1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r+1,c+1]
                {
                    squareNode.fillColor = selectMoveColor
                }
            }
        }
        
    }
    func deselectAll()
    {
        for r in 0...board.NUM_ROWS-1
        {
            for c in 0...board.NUM_COLUMNS-1
            {
                if let squareNode = board.grid[r,c]
                {
                    if(squareNode.fillColor != tileColor)
                    {
                        squareNode.fillColor = tileColor
                    }
                }
            }
        }
    }
    override func mouseDown(with event: NSEvent) {

        //self.touchDown(atPoint: event.location(in: self))
        let location = event.location(in: self)
        let firstTouchedNode = atPoint(location).name
        var isUnit = false
        var id = 0
        if let name = firstTouchedNode
        {
            if name.count > 4
            {
                let substr = name.prefix(4)
                if substr == "unit"
                {
                    isUnit = true
                    id = Int(String(name.suffix(name.count - 4))) ?? 0
                }

            }
        }

        if(isUnit)
        {
            for u in units
            {
                if u.id == id
                {
                    if u.selected
                    {
                        u.selected = false
                        u.selected = false
                        self.unitSelected = false
                        deselectAll()
                        return
                     }
                    if(self.unitSelected)
                    {
                        for u1 in units
                        {
                     
                            if u1.selected && u1.id != u.id
                            {
                                //u is what was clicked on (defender)
                                //u1 is what was prev selected (attacker)
                                if u1.team != u.team
                                {
                                    if(u1.ranged)
                                    {
                                        if let squareNode = board.grid[u.xPosition,u.yPosition]
                                        {
                                            if(squareNode.fillColor == selectMoveColor || squareNode.fillColor == selectAttackColor)
                                            {
                                                u1.rangedAttack(defender: u)
                                                u1.selected = false
                                                u.selected = false
                                                self.unitSelected = false
                                                deselectAll()
                                                return
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if let squareNode = board.grid[u.xPosition,u.yPosition]
                                        {
                                            if(squareNode.fillColor == selectMoveColor)
                                            {
                                                u1.attack(defender: u)
                                                u1.selected = false
                                                u.selected = false
                                                self.unitSelected = false
                                                if(!u.alive)
                                                {
                                                    u1.xPosition = u.xPosition
                                                    u1.yPosition = u.yPosition
                                                    u1.dirty = true
                                                }
                                                else
                                                {
                                                    let xs = u1.xPosition-u.xPosition
                                                    let ys = u1.yPosition-u.yPosition
                                                    let dist = Double(xs*xs+ys*ys)
                                                    if(dist > 2 )
                                                    {
                                                        u1.xPosition = (u1.xPosition+u.xPosition)/2
                                                        u1.yPosition = (u1.yPosition+u.yPosition)/2
                                                        u1.dirty = true
                                                        
                                                    }
                                                }
                                                 deselectAll()
                                                 return
                                            }
                                        }
                                    }
 
                                    u1.selected = false
                                    u.selected = false
                                    self.unitSelected = false
                                    
                                }
                                else
                                {
                                    u1.selected = false
                                    self.unitSelected = false
                                }

                            }
                       }
                        deselectAll()
                    }
                    else
                    {
                        for u1 in units
                        {
                            if u1.selected && u1.id != u.id
                            {
                                u1.selected = false
                                self.unitSelected = false
                            }
                        }
                    }
                    
                    highlightMoves(r: u.yPosition,c: u.xPosition)
                    if(u.fast)
                    {
                        highlightFastMove(r: u.yPosition,c: u.xPosition)

                    }
                    u.selected = true
                    self.unitSelected = true
                    if(u.ranged == true)
                    {
                        highlightRangedAttack(r: u.yPosition,c: u.xPosition)
                    }
                }
            }

        }
        else
        {
            if let num = Int(firstTouchedNode ?? "11")
            {
                let col = Int(num)/10
                let row = Int(num)%10
                if let squareNode = board.grid[col,row]
                {
                    var occupied = false
                    if(squareNode.fillColor == selectMoveColor)
                    {
                        for u in units
                        {
                            if u.xPosition == row && u.yPosition == col
                            {
                                occupied = true
                                break
                            }
                        }
                        
                        if(!occupied)
                        {
                            for u in units
                            {
                                if u.selected
                                {
                                    u.xMove(xMov: row-u.xPosition)
                                    u.yMove(yMov: col-u.yPosition)
                                    u.selected = false
                                    self.unitSelected = false
                                    deselectAll()
                                }
                            }
                        }


                    }
                }

            }
        }

    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {

        switch event.keyCode {

        case 125:
            if let unitNode = self.unitNode
            {
                unitNode.yMove(yMov: -1)
            }
            
        case 126:
            if let unitNode = self.unitNode
            {
                unitNode.yMove(yMov: 1)
            }
            
        case 124:
            if let unitNode = self.unitNode
            {
                unitNode.xMove(xMov: 1)
            }
            
        case 123:
            if let unitNode = self.unitNode
            {
                unitNode.xMove(xMov: -1)
            }
        default:
            break
            //print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")

   
        }

    }
    
    
    func xUnitGridToCoord(c: Int) -> Int
    {
        let width = Int(self.size.height)/2
        let xSize = width/board.NUM_COLUMNS
        return xSize*(c-5)+xSize/2// + 0*xSize - width/2
    }
    
    
    
    func yUnitGridToCoord(r: Int) -> Int
    {
        let height = Int(self.size.height)/2
        let ySize = height/(board.NUM_ROWS)
        return ySize*(r-5)+ySize/2// + 0*ySize - height/2
        
    }
    
    func xTileGridToCoord(c: Int) -> Int
    {
        let width = Int(self.size.width/2)
        let xSize = width/board.NUM_COLUMNS
        return xSize*(c-5)// + 0*xSize - width/2
    }
    
    func yTileGridToCoord(r: Int) -> Int
    {
        let height = Int(self.size.height)/2
        let ySize = height/(board.NUM_ROWS)
        return ySize*(r-5)// + 0*ySize - height/2
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for unitNode in units
        {
            if(unitNode.dirty)
            {
                if unitNode.alive
                {
                    unitNode.position = CGPoint(x: xUnitGridToCoord(c: unitNode.xPosition), y: yUnitGridToCoord(r: unitNode.yPosition))
                    unitNode.clean()
                }
                else
                {
                    if let index = units.firstIndex(of: unitNode)
                    {
                        units.remove(at: index)
                    }
                    unitNode.run(SKAction.removeFromParent())
                    
                }

            }
            
        }

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
}
