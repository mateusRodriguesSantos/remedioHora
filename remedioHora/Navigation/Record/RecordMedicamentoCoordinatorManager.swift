//
//  RecordMedicamentoCoordinatorManager.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import Combine

class RecordMedicamentoCoordinatorManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: StepsRecord) {
        path.append(route)
    }
    
    func pop() {
        if path.isEmpty {
            path.removeLast()
        }
    }
    
    func reset() {
        path = NavigationPath()
    }
}
