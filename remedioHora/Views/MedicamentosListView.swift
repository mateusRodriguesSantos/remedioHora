//
//  MedicamentosListView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData

struct MedicamentosListView: View {
    
    @EnvironmentObject var manager: MedicamentosListCoordinatorManager
    @Environment(\.modelContext) private var modelContext
    @Query var medicamentos: [Medicamento]
    
    var body: some View {
        VStack {
            Text("Medicamentos")
                .font(.title)
            if !medicamentos.isEmpty {
                List {
                    ForEach(Binding.constant(medicamentos), editActions: [.delete]) { medicamento in
                        VStack {
                            Button {
                                manager.navigate(to: .detailView(medicamento: medicamento.wrappedValue))
                            } label: {
                                HStack {
                                    Image(systemName: "pill.fill")
                                    Text(medicamento.wrappedValue.nome)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    EditButton()
                }
            } else {
                Text("Sem medicamentos cadastrados!")
                    .font(.caption2)
                    .padding(.top, 120)
                Spacer()
            }
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let itemToDelete = medicamentos[index]
            modelContext.delete(itemToDelete)
        }
    }
}

#Preview {
    MedicamentosListView()
}
