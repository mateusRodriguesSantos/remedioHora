//
//  RecordMedicamentoCoordinator.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData

enum StepsRecord: Hashable {
    case data
    case frequency
    case notification
    case confimation
}

struct RecordMedicamentoCoordinator: View {

    @StateObject var manager: RecordMedicamentoCoordinatorManager = RecordMedicamentoCoordinatorManager()
    
    var body: some View {
        NavigationStack(path: $manager.path) {
            RecordMedicamentoView()
                .navigationDestination(for: StepsRecord.self) { destination in
                    switch destination {
                    case .data:
                        RecordMedicamentoView()
                    case .frequency:
                        FrequencyMedicamentoView()
                    case .notification:
                        EmptyView()
                    case .confimation:
                        EmptyView()
                    }
                }
        }
        .environmentObject(manager)
    }
}

#Preview {
    RecordMedicamentoCoordinator()
}
