//
//  Tile.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 4/28/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//

import Foundation

class Tile
{

    var r = 0;
    var c = 0
    var food = 0
    var production = 0
    var terrain = "plains"
    var hasUnit = false
    
    init(r: Int, c: Int)
    {
        self.r = r
        self.c = c
    }
}

