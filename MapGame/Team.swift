//
//  Team.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 5/2/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation

class Team
{
    var id = 0
    var movesLeft = 4
    var activate = false
    
    init(id: Int)
    {
        self.id = id
    }
    
    func endTurn()
    {
        self.activate = false
        self.movesLeft = 0
    }
    
    func startTurn()
    {
        self.activate = true
        self.movesLeft = 4
    }
    
    func useMove()
    {
        self.movesLeft = self.movesLeft - 1
    }
    
    func canMove() -> Bool
    {
        return self.movesLeft > 0
    }
    
    func movesToString() -> String
    {
        return "Moves Left: "+String(self.movesLeft)
    }
    
}
