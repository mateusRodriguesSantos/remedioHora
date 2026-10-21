//
//  ContentView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import SwiftUI
import SwiftData

enum Tabs: Hashable, Equatable {
    case programacao
    case medicamentos
    case gravar
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medicamentos: [Medicamento]
    @State private var showModal: Bool = false
    @State private var selection: Tabs = .programacao
    
    var body: some View {
        TabView(selection: $selection) {
            Tab(value: .programacao) {
                ScheduleCoordinator()
            } label: {
                Image(systemName: "list.bullet.clipboard.fill")
                Text("Programação")
            }
            Tab(value: .medicamentos) {
                MedicamentosListCoordinator()
            } label: {
                Image(systemName: "pill.fill")
                Text("Medicamentos")
            }
            Tab(value: .gravar, role: .search) {
                RecordMedicamentoCoordinator(selectionFromTabBar: $selection)
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
        .task {
            let center = UNUserNotificationCenter.current()
            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                dump(error)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Medicamento.self, inMemory: true)
}
