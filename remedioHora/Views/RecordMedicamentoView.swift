//
//  RecordMedicamentoView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData

struct RecordMedicamentoView: View {
    
    @EnvironmentObject var manager: RecordMedicamentoCoordinatorManager
    
    @Query private var medicamentos: [Medicamento]
    @State var nome: String = String()
    @State var dosagem: String = String()
    @State private var date = Date()
    @State private var quantidadeDias: Int? = nil
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .ordinal
        return nf
    }()
    var body: some View {
        VStack {
            Button {
                
            } label: {
                VStack {
                    Image(systemName: "photo.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.black)
                    Text("Foto")
                        .font(.callout)
                        .foregroundStyle(Color.secondary)
                }
                .padding(.top, 60)
            }
            Form {
                Section {
                    TextField("Nome medicamento", text: $nome, prompt: Text("Nome medicamento"))
                    TextField("Dosagem", text: $dosagem, prompt: Text("Dosagem"))
                }
                Section {
                    DatePicker(
                        "Início",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    HStack {
                        Text("Quantidade de dias")
                        TextField("Quantidade de dias", value: $quantidadeDias, format: .number, prompt: Text("Opcional"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
            }
            Spacer()
            Button {
                //manager.navigate(to: .frequency)
            } label: {
                Text("Seguinte")
                    .padding(20)
                    .foregroundStyle(Color.black)
                    .background {
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .fill(Color.yellow)
                    }
                
            }
        }
        .navigationTitle("Adicionar Medicamento")
    }
}

#Preview {
    RecordMedicamentoView()
        .modelContainer(for: Medicamento.self, inMemory: true)
}
