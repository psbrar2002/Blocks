//
//  BRotatedLBlock2x2.swift
//  Blocks
//
//  Created by Jevon Williams on 11/11/24.
//

import Foundation
import SpriteKit

class BRotatedLBlock2x2: BBoxNode {
    
    private let availableAssets = [
        "Laughing-1", "Laughing-2", "Laughing", // Example assets
        "Group 16309-1", "Group 16309", "Group 16310", "Group 16312-1", "Group 16313", "Group 16314-1", "Group 16316" ,"Group 16363-1","Group 16315","Group 16362"
    ]
    
    private let assetColors: [String: UIColor] = [
        "Laughing-1": .red,   // Example color for Laughing-1
        "Laughing-2": .green, // Example color for Laughing-2
        "Laughing": .blue,    // Example color for Laughing
        "Group 16309-1": .yellow,
        "Group 16309": .orange,
        "Group 16310": .purple,
        "Group 16312-1": .cyan,
        "Group 16313": .magenta,
        "Group 16314-1": .brown,
        "Group 16316": .blue,
        "Group 16363-1": .yellow,
        "Group 16315": .green,
        "Group 16362": .orange
    ]
    
    private let selectedAsset = "Group 16362"  // Choose the asset you want
    
    required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .orange) {
        super.init(layoutInfo: layoutInfo, tileSize: tileSize, color: color)
        
        // Define the flipped shape cells to mirror the L-shape horizontally
        let shapeCells = [
            (row: 0, col: 0),
            (row: 0, col: -1),
            (row: 1, col: 0)
        ]
        
        // Use the selected asset directly
        let blockColor = assetColors[selectedAsset] ?? .orange
        
        self.color = blockColor
        
        // Define assets at specific positions for the flipped shape
        let assets = [
            (name: selectedAsset, position: (row: 0, col: 0)),
            (name: selectedAsset, position: (row: 0, col: -1)),
            (name: selectedAsset, position: (row: 1, col: 0))
        ]
        
        // Pass the modified shape and assets to setupShape
        setupShape(shapeCells, assets: assets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

