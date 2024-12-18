//
//  BRotated5LBlock3x3.swift
//  Blocks
//
//  Created by Jevon Williams on 11/11/24.
//

import Foundation
import SpriteKit

class BRotatedLShapeNode5Block: BBoxNode {
    
    // List of possible asset names for the block
    private let availableAssets = [
        "Laughing-1", "Laughing-2", "Laughing", // Example assets
        "Group 16309-1", "Group 16309", "Group 16310", "Group 16312-1", "Group 16313", "Group 16314-1", "Group 16316" ,"Group 16363-1","Group 16333","Bored"
    ]
    
    
    // Now directly selecting a specific asset (e.g., "Laughing-1")
    private let selectedAsset = "Bored"  // Choose the asset you want
    
    required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .purple) {
        super.init(layoutInfo: layoutInfo, tileSize: tileSize, color: color)
        
        // Define the shape of the 5-block L-shaped block after 90-degree rotation
        let shapeCells = [
            (row: 0, col: 0),
            (row: 0, col: 1),
            (row: 0, col: 2),
            (row: 1, col: 2),
            (row: 2, col: 2)
        ]
        
        
        // Define assets at specific positions (using the selected asset)
        let assets = [
            (name: selectedAsset, position: (row: 0, col: 0)),
            (name: selectedAsset, position: (row: 0, col: 1)),
            (name: selectedAsset, position: (row: 0, col: 2)),
            (name: selectedAsset, position: (row: 1, col: 2)),
            (name: selectedAsset, position: (row: 2, col: 2))
        ]
        
        // Pass the selected asset and the shape to setupShape
        setupShape(shapeCells, assets: assets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

