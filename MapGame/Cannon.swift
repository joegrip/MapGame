//
//  Cannon.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 5/1/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation

class Cannon: Unit
{
    override init()
    {
        super.init()
    }

    convenience init(xPosition: Int, yPosition: Int, side: Int,id: Int,team: Int)
    {
        self.init()
        self.setUp(xP: xPosition,yP: yPosition, side: side,id: id,team: team)
        self.ranged = true
     }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
