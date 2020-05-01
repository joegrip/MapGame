//
//  Cavalry.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 5/1/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation

class Cavalry: Unit
{
    
    override init()
    {
        super.init()
    }

    convenience init(xPosition: Int, yPosition: Int, side: Int,id: Int,team: Int)
    {
        self.init()
        //let radius = CGFloat.init(side)
        let shapePath = CGMutablePath.init()
        shapePath.move(to: CGPoint.init(x:CGFloat(0),y:CGFloat(side)))
        shapePath.addLine(to: CGPoint.init(x:CGFloat(-side),y:CGFloat(-side)))
        shapePath.addLine(to: CGPoint.init(x:CGFloat(side),y:CGFloat(-side)))
        shapePath.addLine(to: CGPoint.init(x:CGFloat(0),y:CGFloat(side)))


        shapePath.closeSubpath()
        self.path = shapePath

        
        //self.path = CGPath(ellipseIn: rect, transform: nil)
        self.setUp(xP: xPosition,yP: yPosition, side: side,id: id,team: team)
        self.ranged = false
        self.fast = true
     }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
