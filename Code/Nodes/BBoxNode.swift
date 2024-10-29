//
//  TTBoxNode.swift
//  Blocks
//
//  Created by Jevon Williams on 10/24/24.
//

import SpriteKit

struct GridCoordinate: Hashable {
    var row: Int
    var col: Int
}

class BBoxNode: SKNode {
    var box: SKShapeNode
    var isBeingDragged: Bool = false
    var tileSize: CGFloat
    var color: UIColor
    var gridHeight: Int { 1 } // Default value, can be overridden
    var gridWidth: Int { 1 } // Default value, can be overridden
    var layoutInfo: BLayoutInfo

       required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .red) {
        self.layoutInfo = layoutInfo // Initialize layoutInfo before super.init
        self.tileSize = tileSize
        self.color = color
        box = SKShapeNode(rect: .init(origin: .zero, size: layoutInfo.boxSize), cornerRadius: 8.0)
        box.fillColor = color
        super.init()
        addChild(box)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        // Properly initialize layoutInfo using default values or the coder
        self.layoutInfo = BLayoutInfo(screenSize: CGSize(width: 640, height: 480)) // Set default layoutInfo
        self.tileSize = 40.0
        self.color = .red
        box = SKShapeNode(rect: .init(origin: .zero, size: layoutInfo.boxSize), cornerRadius: 8.0)
        box.fillColor = self.color
        super.init(coder: aDecoder)
        addChild(box)
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        if box.contains(touchLocation) {
            isBeingDragged = true
            print("Dragging started")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isBeingDragged, let touch = touches.first else { return }
        let touchLocation = touch.location(in: self.parent!)
        updatePosition(to: touchLocation)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingDragged = false
      print("Dragging ended")

    // Check the occupied cells after dragging
    let occupied = occupiedCells()
    for coordinate in occupied {
        print("Occupied cell at Row: \(coordinate.row), Col: \(coordinate.col)")
    }
        
        // Handle placement logic (e.g., validate and update game state)
    }

    func updatePosition(to position: CGPoint) {
        self.position = CGPoint(x: position.x - box.frame.width / 2, y: position.y - box.frame.height / 2)
    }

    func occupiedCells() -> [GridCoordinate] {
        let boxWidthInCells = Int(box.frame.size.width / tileSize)
        let boxHeightInCells = Int(box.frame.size.height / tileSize)

        var occupied: [GridCoordinate] = []
        let topLeftRow = Int((position.y + box.frame.size.height / 2) / tileSize)
        let topLeftCol = Int((position.x - box.frame.size.width / 2) / tileSize)

        for row in 0..<boxHeightInCells {
            for col in 0..<boxWidthInCells {
                occupied.append(GridCoordinate(row: topLeftRow + row, col: topLeftCol + col))
            }
        }
        return occupied
    }

    // Generate a random color
    private func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
