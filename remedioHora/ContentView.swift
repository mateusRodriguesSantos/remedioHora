//
//  ContentView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medicamentos: [Medicamento]
    @State private var showModal: Bool = false
    
    var body: some View {
        TabView {
            Tab {
                ScheduleCoordinator()
            } label: {
                Image(systemName: "list.bullet.clipboard.fill")
                Text("Programação")
            }
            Tab {
                MedicamentosListCoordinator()
            } label: {
                Image(systemName: "pill.fill")
                Text("Medicamentos")
            }
            Tab(role: .search) {
                RecordMedicamentoCoordinator()
            } label: {
                Image(systemName: "plus.circle.fill")
            }
            
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Medicamento.self, inMemory: true)
}
