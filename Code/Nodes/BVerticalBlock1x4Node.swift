//
//  BVerticalBlock1x4Node.swift
//  Blocks
//
//  Created by Jevon Williams on 10/29/24.
//

import Foundation
import SpriteKit


class BVerticalBlock1x4Node: BBoxNode {

    // Required initializer with layoutInfo, tileSize, and default color
    required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .purple) {
        super.init(layoutInfo: layoutInfo, tileSize: tileSize)
        box.removeFromParent() // Remove any existing background shape (box)
        configureVerticalBlock(fillColor: color) // Use provided color
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        box.removeFromParent() // Remove any existing background shape (box)
    }

    private func configureVerticalBlock(fillColor: UIColor) {
        // Ensure the layout box size is valid
        guard layoutInfo.boxSize != .zero else {
            print("Error: Layout box size is zero. Ensure layoutInfo is set up correctly.")
            return
        }

        // Create four individual square blocks to form the vertical block
        for i in 0..<4 {
            let block = BSingleBlockT(layoutInfo: layoutInfo, tileSize: tileSize, color: fillColor)
            block.position = CGPoint(x: 0, y: CGFloat(i) * tileSize) // Position them vertically from (0, 0)
            block.isUserInteractionEnabled = false // Prevent user interaction with individual blocks
            addChild(block) // Add each block to the parent node
        }
    }

    // Override grid dimensions for the 1x4 vertical block
    override var gridHeight: Int { 4 } // Four cells tall
    override var gridWidth: Int { 1 } // One cell wide
}
