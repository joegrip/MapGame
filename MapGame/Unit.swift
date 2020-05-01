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
    var ranged = true
    var damage = 50
    var alive = true
    var id = 0
    
    override init()
    {
        super.init()
    }

    convenience init(xPosition: Int, yPosition: Int, side: Int)
    {
        self.init()
        self.setUp(xP: xPosition,yP: yPosition, side: side)
        // Do stuff
     }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(xP: Int, yP: Int, side: Int)
    {
        self.xPosition = xP
        self.yPosition = yP
        self.name = "unit"
        self.lineWidth = 5
        self.zPosition = 1
        let radius = CGFloat.init(side)
        let rect = CGRect(x:-radius,y:-radius,width:radius * 2,height:radius * 2)
        self.path = CGPath(rect: rect, transform: nil)
        self.strokeColor = SKColor.green
        self.fillColor = SKColor.green
    }
    



    
    func xMove(xMov: Int)
    {
        if(self.xPosition + xMov > -1 && self.xPosition+xMov < 10 )
        {
            self.xPosition = self.xPosition + xMov
            self.dirty = true;

        }

    }
    
    func yMove(yMov: Int)
    {
        if(self.yPosition + yMov > -1 && self.yPosition+yMov < 10)
        {
            self.yPosition = self.yPosition + yMov
            self.dirty = true;
        }
    }
    
    func takeDamage(damage: Int)
    {
        self.health = self.health - damage
        if(self.health <= 0)
        {
            alive = false
            dirty = true
        }
        
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
