//
//  MedicamentosListCoordinator.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI

enum MedicamentosListSteps: Hashable {
    case initialView
}

struct MedicamentosListCoordinator: View {
    
    @StateObject var manager: MedicamentosListCoordinatorManager = MedicamentosListCoordinatorManager()
    
    var body: some View {
        NavigationStack(path: $manager.path) {
            MedicamentosListView()
                .navigationDestination(for: MedicamentosListSteps.self) { destination in
                    switch destination {
                    case .initialView:
                        MedicamentosListView()
                    }
                }
        }
        .environmentObject(manager)
    }
}

#Preview {
    MedicamentosListCoordinator()
}
