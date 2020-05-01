//
//  Infantry.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 5/1/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation

class Infantry: Unit
{
    override init()
    {
        super.init()
    }

    convenience init(xPosition: Int, yPosition: Int, side: Int,id: Int,team: Int)
    {
        self.init()
        let radius = CGFloat.init(4*side/5)
        let rect = CGRect(x:-radius,y:-radius,width:radius * 2,height:radius * 2)
        self.path = CGPath(ellipseIn: rect, transform: nil)
        self.setUp(xP: xPosition,yP: yPosition, side: side,id: id,team: team)
        self.ranged = false
     }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}
    
    
