import SpriteKit

class BLShapeNode2x2: BBoxNode {
    
    // List of possible asset names for the block
   private let availableAssets = [
        "Laughing-1", "Laughing-2", "Laughing", // Example assets
        "Group 16309-1", "Group 16309", "Group 16310", "Group 16312-1", "Group 16313", "Group 16314-1", "Group 16316" ,"Group 16363-1"
    ]
    
    // Dictionary mapping asset names to colors
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
        "Group 16363-1": .yellow
    ]
    
    // Now directly selecting a specific asset (e.g., "Laughing-1")
    private let selectedAsset = "Group 16316"  // Choose the asset you want
    
    required init(layoutInfo: BLayoutInfo, tileSize: CGFloat, color: UIColor = .orange) {
        super.init(layoutInfo: layoutInfo, tileSize: tileSize, color: color)
        
        // Define the shape of the L-shaped block after a vertical flip
        let shapeCells = [
            (row: 1, col: 0),
            (row: 0, col: 0),
            (row: 0, col: 1)
        ]
        
        // Use the selected asset directly
        let blockColor = assetColors[selectedAsset] ?? .orange  // Default color if not found
        
        // Set the block's color to match the selected asset
        self.color = blockColor
        
        // Define assets at specific positions (using the selected asset)
        let assets = [
            (name: selectedAsset, position: (row: 0, col: 0)),
            (name: selectedAsset, position: (row: 0, col: 1)),
            (name: selectedAsset, position: (row: 1, col: 0))
        ]
        
        // Pass the selected asset and the shape to setupShape
        setupShape(shapeCells, assets: assets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



