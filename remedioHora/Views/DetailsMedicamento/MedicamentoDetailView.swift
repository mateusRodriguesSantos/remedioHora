//
//  MedicamentoDetailView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 21/10/26.
//

import SwiftUI

struct MedicamentoDetailView: View {
    
    @EnvironmentObject var manager: MedicamentosListCoordinatorManager
    
    @StateObject var viewModel: MedicamentoDetailViewModel
    
    init(viewModel: MedicamentoDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.black)
                    .padding()
                Text("\(viewModel.medicamento.nome)")
                    .padding()
            }
            List {
                Section {
                    HStack {
                        Text("Dosagem")
                        Spacer()
                        Text("\(viewModel.medicamento.dosagem)")
                    }
                    HStack {
                        Text("Data de início")
                        Spacer()
                        Text("\(viewModel.formatDateInit())")
                    }
                    HStack {
                        Text("Próxima dose")
                        Spacer()
                        Text("\(viewModel.formatDateLast())")
                    }
                    HStack {
                        Text("Intervalo")
                        Spacer()
                        Text("\(viewModel.medicamento.intervalo)")
                    }
                    HStack {
                        Text("Doses restantes")
                        Spacer()
                        Text("\(viewModel.medicamento.qtdDoses ?? 0)")
                            .foregroundStyle(Color.green)
                    }
                }
                Section {
                    Button(role: .destructive) {
                        
                    }
                }
            }
        }

        .toolbar {
            ToolbarItem {
                Button {
                    
                } label: {
                    Text("Editar")
                }

            }
        }
    }
}

#Preview {
    MedicamentoDetailView(viewModel: MedicamentoDetailViewModel(medicamento: Medicamento(id: "", nome: "ssd", dosagem: "sdsd", quantidadeDias: 2, timestamp: Date(), foto: Data(), intervalo: "2")))
}
