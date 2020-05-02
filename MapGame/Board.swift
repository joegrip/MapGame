//
//  Board.swift
//  MapGame
//
//  Created by Joseph Gripenstraw on 4/28/20.
//  Copyright © 2020 GripenstrawLLC. All rights reserved.
//



import Foundation
import SpriteKit

struct Matrix<T> {
    let rows: Int, columns: Int
    var grid: [T]
    init(rows: Int, columns: Int,defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

//var t = Tile(r: 0,c: 0)
var t = SKShapeNode.init(rectOf: CGSize.init(width: 1, height: 1))
class Board
{
    var NUM_ROWS = 11
    var NUM_COLUMNS = 11
    var grid:Matrix<SKShapeNode?> = Matrix(rows: 1, columns: 1,defaultValue: t)
    
    
    init(r: Int, c: Int)
    {
        self.NUM_ROWS = r
        self.NUM_COLUMNS = c
        self.grid = Matrix(rows: r, columns: c,defaultValue: t)
        for r in 0...(NUM_ROWS-1)
        {
            for c in 0...(NUM_COLUMNS-1)
            {
                grid[r,c] = t
            }
        }
    }
 
    

}

