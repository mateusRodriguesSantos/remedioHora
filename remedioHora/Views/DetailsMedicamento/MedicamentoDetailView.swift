//
//  MedicamentoDetailView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 21/10/26.
//

import SwiftUI
import SwiftData

struct MedicamentoDetailView: View {
    
    @EnvironmentObject var manager: MedicamentosListCoordinatorManager
    
    @StateObject var viewModel: MedicamentoDetailViewModel
    
    @Environment(\.modelContext) var modelContext: ModelContext
    
    
    init(viewModel: MedicamentoDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.medicamento.foto == nil {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.black)
                        .padding()
                } else {
                    viewModel.getPhoto()
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.black)
                        .clipShape(Circle())
                }
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
                        Text("\(viewModel.medicamento.qtdDoses)")
                            .foregroundStyle(Color.green)
                    }
                }
                Section {
                    Button(role: .destructive) {
                        Task {
                            let idNotification = await UNUserNotificationCenter.current().pendingNotificationRequests().first { request in
                                return request.content.title == viewModel.medicamento.nome
                            }?.identifier ?? ""
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [idNotification])
                            modelContext.delete(viewModel.medicamento)
                            viewModel.showDeleteAlert = true
                            manager.reset()
                        }
                    }
                }
            }
        }
        .alert("", isPresented: $viewModel.showDeleteAlert) {
        } message: {
            Text("Medicamento deletado!")
        }

//        .toolbar {
//            ToolbarItem {
//                Button {
//                    viewModel.editionMode = true
//                } label: {
//                    Text("Editar")
//                }
//            }
//        }
    }
}

#Preview {
    MedicamentoDetailView(viewModel: MedicamentoDetailViewModel(medicamento: Medicamento(id: "", nome: "ssd", dosagem: "sdsd", quantidadeDias: 2, timestamp: Date(), foto: Data(), intervalo: "2")))
}
