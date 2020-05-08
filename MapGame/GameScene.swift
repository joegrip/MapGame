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
    private var infoNode : SKShapeNode?
    private var turnLabel  : SKLabelNode?
    
    private var teamLabel  : SKLabelNode?
    private var unitSelected: Bool = false
    private var id: Int = 0
    private var currentTeam : Int = 0
    private var teamSelected: Int = 0
    var units: Array<Unit> = Array()
    var teams: Array<Team> = Array()
    
    let board = Board(r: 11, c: 11)
    let gridArray: Array<SKShapeNode> = Array()
    let selectMoveColor = SKColor.blue
    let selectAttackColor = SKColor.red//(red:80,green: 0,blue:
        //0,alpha: 1)
    let tileColor = SKColor.lightGray



    override func sceneDidLoad()
    {
        self.lastUpdateTime = 0
        setTeams()
        createGrid()
        createGraphics()
        createInfoWindow()
        setPieces()
    }
    
    func createInfoWindow()
    {
        self.infoNode = SKShapeNode.init(rectOf: CGSize.init(width: Int(self.size.height)/4, height: Int(self.size.height/2.02)), cornerRadius: 2)
        if let wind = self.infoNode
        {
            wind.position = CGPoint(x: Int(
                -36.5*self.size.width/100),y:yUnitGridToCoord(r: 5))
            wind.strokeColor = SKColor.white
            self.addChild(wind)
        }
        
        var lab = SKLabelNode()
        lab.text = ""
        lab.name = "unit type"
        lab.fontSize =  30
        lab.position = CGPoint(x: 0,y:-65)
        lab.fontName = "Roboto"
        self.infoNode?.addChild(lab)
        
        lab = SKLabelNode()
        lab.text = ""
        lab.name = "health"
        lab.fontSize = 20
        lab.position = CGPoint(x: -10,y:-100)
        self.infoNode?.addChild(lab)
        
        lab = SKLabelNode()
        lab.text = ""
        lab.name = "moves left"
        lab.fontSize = 20
        lab.position = CGPoint(x: -10,y:-125)
        self.infoNode?.addChild(lab)
        
        lab = SKLabelNode()
        lab.text = ""
        lab.name = "attacks left"
        lab.fontSize = 20
        lab.position = CGPoint(x: -10,y:-150)
        self.infoNode?.addChild(lab)
        
        
        let picture = SKSpriteNode(imageNamed: "Napoleon")
        picture.position = CGPoint(x:0,y:100)
        picture.name="picture"
        self.infoNode?.addChild(picture)

    }
    
    func updateInfoWindow(u: Unit)
    {
        if let hp = self.infoNode?.childNode(withName: "health") as! SKLabelNode?
        {
            hp.text = u.healthToString()
        }
        
        if let ut = self.infoNode?.childNode(withName: "unit type") as! SKLabelNode?
        {
            ut.text = u.className()
        }
        
        if let ut = self.infoNode?.childNode(withName: "moves left") as! SKLabelNode?
        {
            if u.hasMoved == true
            {
                ut.text = "Moves Left: 0"
            }
            else
            {
                ut.text = "Moves Left: 1"
            }
        }
        
        if let ut = self.infoNode?.childNode(withName: "attacks left") as! SKLabelNode?
        {
            if u.hasAttacked == true
            {
                ut.text = "Attacks Left: 0"
            }
            else
            {
                ut.text = "Attacks Left: 1"
            }
        }
        
        if let ssn = self.infoNode?.childNode(withName: "picture") as! SKSpriteNode?
        {
            if u.className == "MapGame.Infantry"
            {
                ssn.texture = SKTexture(imageNamed: "Infantry")//u.className)
            }
            else if u.className == "MapGame.Cavalry"
            {
                ssn.texture = SKTexture(imageNamed: "Cavalry")//u.className)
            }
            else if u.className == "MapGame.Cannon"
            {
                ssn.texture = SKTexture(imageNamed: "Cannon")//u.className)
            }


        }
        
    }
    
    func createGraphics()
    {
        
        self.teamLabel = SKLabelNode()
        if let lab = self.teamLabel
        {
            lab.text = "Team 0"
            lab.fontName = "Roboto"
            lab.fontSize = 30
            lab.position = CGPoint(x: 3.8*self.size.width/10, y: self.size.height/4)
            self.addChild(lab)
        }
 
        
        self.turnLabel = SKLabelNode()
        if let lab = self.turnLabel
        {
            lab.text = "Moves Left: 4"
            lab.fontName = "Roboto"
            lab.fontSize = 20
            lab.position = CGPoint(x: 3.8*self.size.width/10, y: self.size.height/5)
            self.addChild(lab)
        }
        
    }
    func setTeams()
    {
        let team = Team.init(id: 0)
        team.startTurn()
        let team1 = Team.init(id: 1)
        team1.endTurn()
        teams.append(team)
        teams.append(team1)
    }
    
    func endTurn()
    {
        for u in units
        {
            if(u.hasAttacked)
            {
                u.hasAttacked = false
            }
            if(u.hasMoved)
            {
                u.hasMoved = false
            }
        }
        if(currentTeam == 0)
        {
            currentTeam = 1
            teams[0].endTurn()
            teams[1].startTurn()
            if let lab = self.teamLabel
            {
                lab.text = "Team 1"
            }
            if let lab = self.turnLabel
            {
                lab.text = teams[1].movesToString()
            }
        }
        else
        {
            currentTeam = 0
            teams[1].endTurn()
            teams[0].startTurn()
            if let lab = self.teamLabel
            {
                lab.text = "Team 0"
            }
            if let lab = self.turnLabel
            {
                lab.text = teams[0].movesToString()
            }
        }
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
                    squareNode.name = String(r)+","+String(c)
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

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

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
        
        if(c+3 < board.NUM_COLUMNS)
        {

            if let squareNode = board.grid[r,c+3]
            {
                squareNode.fillColor = selectAttackColor
            }
            
            if(r-2 > -1)
            {
              if let squareNode = board.grid[r-2,c+3]
              {
                  squareNode.fillColor = selectAttackColor
              }
            }
            if(r-1 > -1)
            {
              if let squareNode = board.grid[r-1,c+3]
              {
                squareNode.fillColor = selectAttackColor
              }
            }
            if(r+1 < board.NUM_ROWS)
            {
              if let squareNode = board.grid[r+1,c+3]
              {
                squareNode.fillColor = selectAttackColor
              }
            }
            if(r+2 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+2,c+3]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }


        }
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
        if(r+3 < board.NUM_ROWS)
        {

            if let squareNode = board.grid[r+3,c]
            {
                squareNode.fillColor = selectAttackColor
            }
            
            if(c-3 > -1)
            {
                if let squareNode = board.grid[r+3,c-3]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(c-2 > -1)
            {
              if let squareNode = board.grid[r+3,c-2]
              {
                  squareNode.fillColor = selectAttackColor
              }
            }
            if(c-1 > -1)
            {
              if let squareNode = board.grid[r+3,c-1]
              {
                squareNode.fillColor = selectAttackColor
              }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
              if let squareNode = board.grid[r+3,c+1]
              {
                squareNode.fillColor = selectAttackColor
              }
            }
            if(c+2 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r+3,c+2]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(c+3 < board.NUM_COLUMNS)
            {
              if let squareNode = board.grid[r+3,c+3]
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
        if(r-3 > -1)
          {

              if let squareNode = board.grid[r-3,c]
              {
                  squareNode.fillColor = selectAttackColor
              }
              
              if(c-3 > -1)
              {
                  if let squareNode = board.grid[r-3,c-3]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
              if(c-2 > -1)
              {
                if let squareNode = board.grid[r-3,c-2]
                {
                    squareNode.fillColor = selectAttackColor
                }
              }
              if(c-1 > -1)
              {
                if let squareNode = board.grid[r-3,c-1]
                {
                  squareNode.fillColor = selectAttackColor
                }
              }
              if(c+1 < board.NUM_COLUMNS)
              {
                if let squareNode = board.grid[r-3,c+1]
                {
                  squareNode.fillColor = selectAttackColor
                }
              }
              if(c+2 < board.NUM_COLUMNS)
              {
                  if let squareNode = board.grid[r-3,c+2]
                  {
                      squareNode.fillColor = selectAttackColor
                  }
              }
              if(c+3 < board.NUM_COLUMNS)
              {
                if let squareNode = board.grid[r-3,c+3]
                {
                    squareNode.fillColor = selectAttackColor
                }
              }
            if(c-1 > -1)
            {
                if let squareNode = board.grid[r-3,c-1]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(c+1 < board.NUM_COLUMNS)
            {
                if let squareNode = board.grid[r-3,c+1]
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
        
        if(c-3 > -1)
        {
            if let squareNode = board.grid[r,c-3]
            {
                squareNode.fillColor = selectAttackColor
            }
            if(r-1 > -1)
            {
                if let squareNode = board.grid[r-1,c-3]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(r-2 > -1)
            {
                if let squareNode = board.grid[r-2,c-3]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(r+1 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+1,c-3]
                {
                    squareNode.fillColor = selectAttackColor
                }
            }
            if(r+2 < board.NUM_ROWS)
            {
                if let squareNode = board.grid[r+2,c-3]
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
    
    func tileOccupied(row: Int, col: Int) -> Bool
    {
        for u in units
        {
            if u.xPosition == row && u.yPosition == col
            {
                return true
            }
        }
        return false
    }
    override func mouseDown(with event: NSEvent)
    {

        //self.touchDown(atPoint: event.location(in: self))
        let location = event.location(in: self)
        let firstTouchedNode = atPoint(location).name
        var isUnit = false
        var id = 0
        if let name = firstTouchedNode
        {
            if name == "picture"
            {
                return
            }
            if name == "unit type"
            {
                return
            }
            if name == "health"
            {
                return
            }
    

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
                                        if let squareNode = board.grid[u.yPosition,u.xPosition]
                                        {
                                            if(squareNode.fillColor == selectMoveColor || squareNode.fillColor == selectAttackColor)
                                            {
                                                if(u1.hasAttacked == true)
                                                {
                                                    return
                                                }
                                                if(!teams[u1.team].canMove())
                                                {
                                                    return
                                                }
                                                teams[u1.team].useMove()
                                                if let lab = self.turnLabel
                                                {
                                                    lab.text = teams[u1.team].movesToString()
                                                }
                                                u1.rangedAttack(defender: u)
                                                u1.hasAttacked = true
                                                u1.selected = false
                                                u.selected = false
                                                self.unitSelected = false
                                                deselectAll()
                                                updateInfoWindow(u: u1)
                                                return
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if let squareNode = board.grid[u.yPosition,u.xPosition]
                                        {
                                            if(squareNode.fillColor == selectMoveColor)
                                            {
                                                if(u1.hasAttacked == true)
                                                {
                                                    return
                                                }
                                                if(!teams[u1.team].canMove())
                                                {
                                                    return
                                                }
                                                teams[u1.team].useMove()
                                                if let lab = self.turnLabel
                                                {
                                                    lab.text = teams[u1.team].movesToString()
                                                }
                                                let xs = u1.xPosition-u.xPosition
                                                let ys = u1.yPosition-u.yPosition
                                                let dist = Double(xs*xs+ys*ys)
                                                var xp = u1.xPosition
                                                var yp = u1
                                                    .yPosition
                                                if(dist > 2 )
                                                {
                                                    xp = (u1.xPosition+u.xPosition)/2
                                                    yp = (u1.yPosition+u.yPosition)/2
                                                    if(tileOccupied(row: xp, col: yp))
                                                    {
                                                        u1.selected = false
                                                        u.selected = false
                                                        self.unitSelected = false
                                                        deselectAll()
                                                        return
                                                    }
                                                    u1.dirty = true
                                                }
                                                u1.attack(defender: u)
                                                u1.hasAttacked = true
                                                updateInfoWindow(u: u1)

                                                
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
                                                    u1.xPosition = xp
                                                    u1.yPosition = yp
                                                    u1.dirty = true
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
                    
                    if(u.team != currentTeam)
                    {
                        return
                    }
                    highlightMoves(r: u.yPosition,c: u.xPosition)
                    if(u.fast)
                    {
                        highlightFastMove(r: u.yPosition,c: u.xPosition)

                    }
                    u.selected = true
                    updateInfoWindow(u: u)
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

            var col = 0
            var row = 0
            if let st = firstTouchedNode
            {
                let arr = st.components(separatedBy: ",")
                if let num = Int(arr[0])
                {
                    col = num
                }
                if let num = Int(arr[1])
                {
                    row = num
                }
            }
            
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
                                if(u.hasMoved)
                                {
                                    return
                                }
                                if(!teams[u.team].canMove())
                                {
                                    return
                                }
                                teams[u.team].useMove()
                                if let lab = self.turnLabel
                                {
                                    lab.text = teams[u.team].movesToString()
                                }
                                u.xMove(xMov: row-u.xPosition)
                                u.yMove(yMov: col-u.yPosition)
                                u.selected = false
                                self.unitSelected = false
                                u.hasMoved = true
                                updateInfoWindow(u: u)
                                deselectAll()
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

        case 49:
            endTurn()
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
    
    override func update(_ currentTime: TimeInterval)
    {
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
