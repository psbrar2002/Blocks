//
//  BGameScene.swift
//  Blocks
//
//  Created by Jevon Williams on 10/24/24.
//
import SpriteKit

class BGameScene: SKScene {
    let gridSize = 10
    let tileSize: CGFloat = 40
    var score = 0
    var grid: [[SKShapeNode?]] = [] // Changed from [[BBoxNode?]] to [[SKShapeNode?]]
    var boxNodes: [BBoxNode] = []
    var currentlyDraggedNode: BBoxNode?
    var gameContext: BGameContext
    var isGameOver: Bool = false


    // Add new properties for dependencies and game mode
    var dependencies: Dependencies // Replace with actual type
    var gameMode: GameModeType // Using the enum defined above

    init(context: BGameContext, dependencies: Dependencies, gameMode: GameModeType, size: CGSize) {
        self.gameContext = context // Initialize your context here
        self.dependencies = dependencies // Initialize dependencies
        self.gameMode = gameMode // Initialize game mode
        self.grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize) // Initialize with nil
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        // Initialize dependencies and game mode with default values or handle as necessary
        let defaultDependencies = Dependencies() // Ensure you have a way to create a default instance
        self.dependencies = defaultDependencies // Set default dependencies
        self.gameMode = .single // Default game mode; change if needed

        // Create a BGameContext using the dependencies and game mode
        self.gameContext = BGameContext(dependencies: dependencies, gameMode: gameMode)

        // Initialize the grid
        self.grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize) // Initialize with nil
        super.init(coder: aDecoder)
    }

    // MARK: - Node Management

    func addBlockNode(_ blockNode: SKShapeNode, to parentNode: SKNode) {
        // Check if blockNode already has a parent before adding
        if blockNode.parent == nil {
            parentNode.addChild(blockNode)
        } else {
            print("Block node already has a parent and will not be added again.")
        }
    }

    func safeAddBlock(_ block: BBoxNode) {
        // Remove the block from its parent if it already has one
        if block.parent != nil {
            block.removeFromParent()
        }
        addChild(block) // Now safely add it to the scene
    }

    // MARK: - Grid Management

    func isCellOccupied(row: Int, col: Int) -> Bool {
        guard row >= 0, row < gridSize, col >= 0, col < gridSize else {
            return true // Out of bounds are considered occupied
        }
        return grid[row][col] != nil // Check if the grid cell is occupied
    }

    func setCellOccupied(row: Int, col: Int, with cellNode: SKShapeNode) {
        guard row >= 0, row < gridSize, col >= 0, col < gridSize else {
            return // Ignore out of bounds
        }
        grid[row][col] = cellNode // Mark the cell as occupied with the cell node
    }

    private var availableBlockTypes: [BBoxNode.Type] = [
        BSingleBlock.self,
        BSquareBlock2x2.self,
        BThreeByThreeBlockNode.self,
    ]

    override func didMove(to view: SKView) {
        backgroundColor = .black
        createGrid()
        addScoreLabel()
        spawnNewBlocks()
    }

    func createGrid() {
        grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        let gridOrigin = CGPoint(x: (size.width - CGFloat(gridSize) * tileSize) / 2,
                                 y: (size.height - CGFloat(gridSize) * tileSize) / 2)

        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let cellNode = SKShapeNode(rectOf: CGSize(width: tileSize, height: tileSize), cornerRadius: 4)
                cellNode.fillColor = .lightGray
                cellNode.strokeColor = .darkGray
                cellNode.lineWidth = 2.0

                cellNode.position = CGPoint(x: gridOrigin.x + CGFloat(col) * tileSize + tileSize / 2,
                                            y: gridOrigin.y + CGFloat(row) * tileSize + tileSize / 2)
                addChild(cellNode)
            }
        }
    }

    func addScoreLabel() {
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        scoreLabel.name = "scoreLabel"
        addChild(scoreLabel)
    }
    
    func checkForPossibleMoves() -> Bool {
    for row in 0..<gridSize {
        for col in 0..<gridSize {
            for blockType in availableBlockTypes {
                let testBlock = blockType.init(
                    layoutInfo: BLayoutInfo(screenSize: size, boxSize: CGSize(width: tileSize, height: tileSize)),
                    tileSize: tileSize
                )
                if isPlacementValid(for: testBlock, at: row, col: col) {
                    return true // A valid move exists
                }
            }
        }
    }
    print("No valid moves found.")
    return false // No valid moves
}


    func spawnNewBlocks() {
        guard !isGameOver, canSpawnBlocks() else {
        print("Game Over!")
        showGameOverScreen() // Call to show game over screen
        return
    }

        // Remove old blocks from the scene
        boxNodes.forEach { $0.removeFromParent() }
        boxNodes.removeAll()

        let spacing: CGFloat = 10
        let newBlocks = generateRandomShapes(count: 3)

        // Calculate total width of blocks including spacing
        var totalBlocksWidth: CGFloat = 0
        for block in newBlocks {
            let blockWidth = CGFloat(block.gridWidth) * tileSize
            totalBlocksWidth += blockWidth
        }
        let totalSpacing = spacing * CGFloat(newBlocks.count - 1)
        let totalWidth = totalBlocksWidth + totalSpacing

        // Calculate starting X position to center blocks
        let startXPosition = (size.width - totalWidth) / 2.0
        let blockYPosition = size.height * 0.1 // Adjusted to move blocks higher and ensure proper placement

        var currentXPosition = startXPosition

        for newBlock in newBlocks {
            let blockWidth = CGFloat(newBlock.gridWidth) * tileSize

            newBlock.position = CGPoint(x: currentXPosition, y: blockYPosition)
            newBlock.initialPosition = newBlock.position
            newBlock.gameScene = self  // Set the reference to the game scene
            safeAddBlock(newBlock)
            boxNodes.append(newBlock)
            print("Added new block at position: \(newBlock.position)")

            currentXPosition += blockWidth + spacing
        }
        
          if !checkForPossibleMoves() {
            print("Game Over! No possible moves.")
            showGameOverScreen() // Show game over screen if no moves available
        }
    }

    func generateRandomShapes(count: Int) -> [BBoxNode] {
        var shapes: [BBoxNode] = []
        for _ in 0..<count {
            let blockType = availableBlockTypes.randomElement()!
            let newBlock = blockType.init(
                layoutInfo: BLayoutInfo(screenSize: size, boxSize: CGSize(width: tileSize, height: tileSize)),
                tileSize: tileSize
            )
            shapes.append(newBlock)
        }
        return shapes
    }

    func isPlacementValid(for block: BBoxNode, at row: Int, col: Int) -> Bool {
        for r in 0..<block.gridHeight {
            for c in 0..<block.gridWidth {
                let gridRow = row + r
                let gridCol = col + c

                // Check bounds
                if gridRow < 0 || gridRow >= gridSize || gridCol < 0 || gridCol >= gridSize {
                    return false
                }

                // Check if the cell is occupied
                if grid[gridRow][gridCol] != nil {
                    return false
                }
            }
        }
        return true
    }

   func placeBlock(_ block: BBoxNode, at gridPosition: (row: Int, col: Int)) {
    let row = gridPosition.row
    let col = gridPosition.col

    // Check if the placement is valid
    if isPlacementValid(for: block, at: row, col: col) {
        // Place the block as before
        for r in 0..<block.gridHeight {
            for c in 0..<block.gridWidth {
                let gridRow = row + r
                let gridCol = col + c

                // Create a cell node
                let cellNode = SKShapeNode(rectOf: CGSize(width: tileSize, height: tileSize))
                cellNode.fillColor = block.color // Use the block's color
                cellNode.strokeColor = .darkGray
                cellNode.lineWidth = 2.0

                // Position the cell node at the correct grid cell
                let gridOrigin = CGPoint(
                    x: (size.width - CGFloat(gridSize) * tileSize) / 2,
                    y: (size.height - CGFloat(gridSize) * tileSize) / 2
                )
                let cellPosition = CGPoint(
                    x: gridOrigin.x + CGFloat(gridCol) * tileSize + tileSize / 2,
                    y: gridOrigin.y + CGFloat(gridRow) * tileSize + tileSize / 2
                )
                cellNode.position = cellPosition

                // Add the cell node to the scene
                addChild(cellNode)

                // Update the grid
                setCellOccupied(row: gridRow, col: gridCol, with: cellNode)
            }
        }

        // Increase score based on the number of cells occupied by the block
        let occupiedCells = block.gridHeight * block.gridWidth
        score += occupiedCells
        updateScoreLabel()

        // Remove the block from draggable blocks
        if let index = boxNodes.firstIndex(of: block) {
            boxNodes.remove(at: index)
        }

        // Remove the block node from the scene
        block.removeFromParent()

        // Optionally, check for completed lines and update the score
        checkForCompletedLines()

        // Check for game over condition after placing the block
        if !canSpawnBlocks() {
            showGameOverScreen()
        } else if boxNodes.isEmpty {
            spawnNewBlocks()
        }
    } else {
        // If invalid placement, move the block back to its initial position
        block.position = block.initialPosition
    }
}


    func checkForCompletedLines() {
        // Check for completed rows
        for row in 0..<gridSize {
            if grid[row].allSatisfy({ $0 != nil }) { // If all cells in the row are occupied
                clearRow(row)
            }
        }

        // Check for completed columns
        for col in 0..<gridSize {
            var isCompleted = true
            for row in 0..<gridSize {
                if grid[row][col] == nil {
                    isCompleted = false
                    break
                }
            }
            if isCompleted {
                clearColumn(col)
            }
        }
    }

    func clearRow(_ row: Int) {
        // Remove blocks from the scene and clear references in the grid
        for col in 0..<gridSize {
            if let cellNode = grid[row][col] {
                cellNode.removeFromParent() // Remove cell node from the scene
                grid[row][col] = nil // Clear the cell
                score += 1 // Update score per cell cleared
            }
        }
        updateScoreLabel()
    }

    func clearColumn(_ col: Int) {
        // Remove blocks from the scene and clear references in the grid
        for row in 0..<gridSize {
            if let cellNode = grid[row][col] {
                cellNode.removeFromParent() // Remove cell node from the scene
                grid[row][col] = nil // Clear the cell
                score += 1 // Update score per cell cleared
            }
        }
        updateScoreLabel()
    }

    func updateScoreLabel() {
        if let scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    func showGameOverScreen() {
    isGameOver = true // Set the game over state

    // Create a game over label
    let gameOverLabel = SKLabelNode(text: "Game Over")
    gameOverLabel.fontSize = 48
    gameOverLabel.fontColor = .white
    gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 40)
    addChild(gameOverLabel)

    // Create a score label to show final score
    let finalScoreLabel = SKLabelNode(text: "Final Score: \(score)")
    finalScoreLabel.fontSize = 36
    finalScoreLabel.fontColor = .white
    finalScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
    addChild(finalScoreLabel)

    // Create a restart button
    let restartLabel = SKLabelNode(text: "Tap to Restart")
    restartLabel.fontSize = 24
    restartLabel.fontColor = .yellow
    restartLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 40)
    addChild(restartLabel)
}
    
   func restartGame() {
    // Reset score
    score = 0
    updateScoreLabel()

    // Reset grid
    grid = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)

    // Remove existing nodes
    removeAllChildren()

    // Reinitialize the game state
    isGameOver = false
    createGrid()
    addScoreLabel()
    spawnNewBlocks()
}




    // Touch handling methods

   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    
    if isGameOver {
        restartGame() // Call to restart the game
        return
    }
    
    let location = touch.location(in: self)
    currentlyDraggedNode = self.nodes(at: location).first(where: { node in
        guard let boxNode = node as? BBoxNode else { return false }
        return boxNodes.contains(boxNode)
    }) as? BBoxNode

    currentlyDraggedNode?.touchesBegan(touches, with: event)
}


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentlyDraggedNode?.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentlyDraggedNode?.touchesEnded(touches, with: event)
        currentlyDraggedNode = nil
    }

    func canSpawnBlocks() -> Bool {
    for row in 0..<gridSize {
        for col in 0..<gridSize {
            if !isCellOccupied(row: row, col: col) {
                // Check if any block can be placed at the empty cell
                for blockType in availableBlockTypes {
                    let testBlock = blockType.init(
                        layoutInfo: BLayoutInfo(screenSize: size, boxSize: CGSize(width: tileSize, height: tileSize)),
                        tileSize: tileSize
                    )
                    if isPlacementValid(for: testBlock, at: row, col: col) {
                        return true // Found at least one valid position
                    }
                }
            }
        }
    }
    return false // No valid moves available
}

}
