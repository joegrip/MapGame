//
//  Unit.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 4/28/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation
import SpriteKit

class Unit: SKShapeNode
{
    var xPosition = 0;
    var yPosition = 0;
    var health = 100;
    var dirty = false
    var selected = false
    var hasAttacked = false
    var ranged = false
    var damage = 50
    var fast = false
    var alive = true
    var id = 0
    var team = 0
    let teamColors = [ 0: SKColor(white: 200, alpha: 1),
                       1: SKColor.darkGray
                     ]
    
    override init()
    {
        super.init()
    }

    convenience init(xPosition: Int, yPosition: Int, side: Int,id: Int,team: Int)
    {
        self.init()
        self.setUp(xP: xPosition,yP: yPosition, side: side,id: id,team: team)
     }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(xP: Int, yP: Int, side: Int,id: Int,team: Int)
    {
        self.xPosition = xP
        self.yPosition = yP
        self.name = "unit"+String(id)
        self.id = id
        self.team = team
        self.lineWidth = 5
        self.zPosition = 1
        if let color = teamColors[team]
        {
            self.strokeColor = color
            self.fillColor = color
        }
 
    }

    
    func xMove(xMov: Int)
    {
        if(self.xPosition + xMov > -1 && self.xPosition+xMov < num_rows )
        {
            self.xPosition = self.xPosition + xMov
            self.dirty = true;

        }

    }
    
    func yMove(yMov: Int)
    {
        if(self.yPosition + yMov > -1 && self.yPosition+yMov < num_cols)
        {
            self.yPosition = self.yPosition + yMov
            self.dirty = true;
        }
    }
    
    func takeDamage(attacker: Unit)
    {
        self.health = self.health - attacker.health*(attacker.damage)/100
        if(self.health <= 0)
        {
            alive = false
            dirty = true
        }
        
    }
    
    func rangedAttack(defender: Unit)
    {
        defender.takeDamage(attacker: self)
    }
    
    func attack(defender: Unit)
    {
        defender.takeDamage(attacker: self)
        self.takeDamage(attacker: defender)
    }
    
    func clean()
    {
        self.dirty = false
    }
    
    func select(b: Bool)
    {
        self.selected = b
    }
    
}
