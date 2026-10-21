//
//  RecordMedicamentoView.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct RecordMedicamentoView: View {
    
    @EnvironmentObject var manager: RecordMedicamentoCoordinatorManager
    
    @State var imageSelection: PhotosPickerItem? = nil
    @State private var showImagePicker: Bool = false
    @State private var nome: String = String()
    @State private var dosagem: String = String()
    @State private var date: Date? = nil
    @State private var quantidadeDias: Int? = nil
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .ordinal
        return nf
    }()
    @State private var alertValidation: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Adicionar Medicamento")
                .font(.title)
                .padding(.vertical, 20)
            PhotosPicker(selection: $imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
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
                         .buttonStyle(.borderless)
            Form {
                Section {
                    TextField("Nome medicamento", text: $nome, prompt: Text("Nome medicamento"))
                    TextField("Dosagem", text: $dosagem, prompt: Text("Dosagem"))
                }
                Section {
//                    HStack {
//                        Text("Início")
//                        Spacer()
//                        DatePicker(
//                            "",
//                            selection: Binding(get: {
//                                date ?? Date()
//                            }, set: { newValue in
//                                date = newValue
//                            }),
//                            displayedComponents: [.date, .hourAndMinute]
//                        )
//                        .opacity(date == nil ? 0.2 : 1)
//                    }
                    HStack {
                        Text("Quantidade de dias")
                        TextField("Quantidade de dias", value: $quantidadeDias, format: .number, prompt: Text("Obrigatório"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
                Section {
                    Button {
                        if nome.isEmpty || dosagem.isEmpty || quantidadeDias == nil {
                            alertValidation = true
                        } else {
                            let medicamento = Medicamento(nome: nome, dosagem: dosagem, quantidadeDias: quantidadeDias ?? 0, timestamp: Date(), foto: Data(), intervalo: DoseInterval.every15Minutes.label)
                            manager.navigate(to: .frequency(medicamentoToSave: medicamento))
                        }
                    } label: {
                        Text("Seguinte")
                            .padding(20)
                            .foregroundStyle(Color.black)
                            .background {
                                RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .fill(Color.yellow)
                            }
                            .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .alert("", isPresented: $alertValidation) {
            Button(role: .confirm) {
                alertValidation = false
            }
        } message: {
            Text("Preencha todos os campos!")
        }
    }
}

#Preview {
    RecordMedicamentoView()
}
