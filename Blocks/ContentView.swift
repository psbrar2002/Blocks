//
//  ContentView.swift
//  Blocks
//
//  Created by Prabhdeep Brar on 10/18/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let screenSize: CGSize = UIScreen.main.bounds.size
    var layoutInfo: BLayoutInfo {
        BLayoutInfo(screenSize: screenSize)
    }
    
    let gameContext: BGameContext

    init(dependencies: Dependencies, gameMode: GameModeType) {
        self.gameContext = BGameContext(dependencies: dependencies, gameMode: gameMode)
    }

    var body: some View {
        SpriteView(scene: BGameScene(context: gameContext, dependencies: gameContext.dependencies, gameMode: gameContext.gameMode, size: screenSize)) // Pass dependencies and gameMode
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView(dependencies: Dependencies(), gameMode: .single)
        .ignoresSafeArea()
}

