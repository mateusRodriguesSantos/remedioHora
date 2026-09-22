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
    case frequency(medicamentoToSave: Medicamento)
    case notification
    case confimation
}

struct RecordMedicamentoCoordinator: View {

    @StateObject var manager: RecordMedicamentoCoordinatorManager
    @Binding var selectionFromTabBar: Tabs
    
    init(selectionFromTabBar: Binding<Tabs>) {
        self._selectionFromTabBar = selectionFromTabBar
        self._manager = StateObject(wrappedValue: RecordMedicamentoCoordinatorManager())
        
    }
    
    var body: some View {
        NavigationStack(path: $manager.path) {
            RecordMedicamentoView()
                .navigationDestination(for: StepsRecord.self) { destination in
                    switch destination {
                    case .data:
                        RecordMedicamentoView()
                    case .frequency(let medicamento):
                        RecordMedicamentoDosagemView(medicamentoToSave: medicamento)
                    case .notification:
                        EmptyView()
                    case .confimation:
                        RecordMedicamentoConfirmView()
                    }
                }
        }
        .environmentObject(manager)
        .onChange(of: manager.returnToInit) {
            self.$selectionFromTabBar.wrappedValue = .programacao
        }
        .onDisappear {
            manager.returnToInit = false
        }
    }
}

#Preview {
    RecordMedicamentoCoordinator(selectionFromTabBar: .constant(.gravar))
}
