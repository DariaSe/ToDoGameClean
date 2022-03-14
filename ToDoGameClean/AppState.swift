//
//  AppState.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 12.03.2022.
//

import Foundation

final class AppState {
    
    static let shared = AppState()
    private init() {}

    var gameResources: GameResources = GameResources.start
}
