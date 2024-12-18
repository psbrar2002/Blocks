//
//  BVerticalBlockNode1x4.swift
//  Blocks
//
//  Created by Jevon Williams on 11/3/24.
//

import SpriteKit

class BVerticalBlockNode1x4: BBoxNode {
    
    // List of possible asset names for the block
   private let availableAssets = [
        "Laughing-1", "Laughing-2", "Laughing", // Example assets
        "Group 16309-1", "Group 16309", "Group 16310", "Group 16312-1", "No laughing", "Group 16314-1", "Group 16316" ,"Group 16363-1"
    ]
    
    // Now directly selecting a specific asset (e.g., "Laughing-1")
    private let selectedAsset = "No laughing"  // Choose the asset you want
    
    required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .blue) {
        super.init(layoutInfo: layoutInfo, tileSize: tileSize, color: color)
        
        // Define the shape of the 1x4 vertical block
        let shapeCells = [
            (row: 0, col: 0),
            (row: 1, col: 0),
            (row: 2, col: 0),
            (row: 3, col: 0)
        ]
        
        
        // Define assets at specific positions (using the selected asset)
        let assets = [
            (name: selectedAsset, position: (row: 0, col: 0)),
            (name: selectedAsset, position: (row: 1, col: 0)),
            (name: selectedAsset, position: (row: 2, col: 0)),
            (name: selectedAsset, position: (row: 3, col: 0))
        ]
        
        setupShape(shapeCells, assets: assets) // Pass the selected asset and its color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


