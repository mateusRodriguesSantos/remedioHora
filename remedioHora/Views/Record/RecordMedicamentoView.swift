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
    
    @State var imageSelection: PhotosPickerItem?
    @State private var showImagePicker: Bool
    @State private var nome: String
    @State private var dosagem: String
    @State private var date: Date? = nil
    @State private var quantidadeDias: Int?
    @State private var numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .ordinal
        return nf
    }()
    @State private var alertValidation: Bool

    @FocusState private var focusedField: Bool
    
    @State private var imageMedicine: Image?
    
    init(
        imageSelection: PhotosPickerItem? = nil,
        showImagePicker: Bool = false,
        nome: String = String(),
        dosagem: String = String(),
        date: Date? = nil,
        quantidadeDias: Int? = nil,
        numberFormatter: NumberFormatter = NumberFormatter(),
        alertValidation: Bool = false,
        focusedField: Bool = false,
        imageMedicine: Image? = nil
        
    ) {
        self.imageSelection = imageSelection
        self.showImagePicker = showImagePicker
        self.nome = nome
        self.dosagem = dosagem
        self.date = date
        self.quantidadeDias = quantidadeDias
        self.numberFormatter = numberFormatter
        self.alertValidation = alertValidation
        self.focusedField = focusedField
        self.imageMedicine = imageMedicine
    }
   
    var body: some View {
        VStack {
            Text("Adicionar Medicamento")
                .font(.title)
                .padding(.vertical, 20)
            
            PhotosPicker(selection: $imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
                VStack {
                    if imageMedicine == nil {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.black)
                    } else {
                        imageMedicine.unsafelyUnwrapped
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.black)
                            .clipShape(Circle())
                    }
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
                        .focused($focusedField)
                        .submitLabel(.next)
                    
                    TextField("Dosagem", text: $dosagem, prompt: Text("Dosagem"))
                        .focused($focusedField)
                        .submitLabel(.next)
                }
                
                Section {
                    HStack {
                        Text("Quantidade de dias")
                        TextField("Quantidade de dias", value: $quantidadeDias, format: .number, prompt: Text("Obrigatório"))
                            .focused($focusedField)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
             
                Section {
                    Button {
                        if nome.isEmpty || dosagem.isEmpty || quantidadeDias == nil {
                            alertValidation = true
                        } else {
                            let renderer = ImageRenderer(content: imageMedicine)
                            
                            if let uiImage = renderer.uiImage,
                               let imageData = uiImage.pngData() {
                                
                                let medicamento = Medicamento(nome: nome, dosagem: dosagem, quantidadeDias: quantidadeDias ?? 0, timestamp: Date(), foto: imageData, intervalo: DoseInterval.every15Minutes.label)
                                manager.navigate(to: .frequency(medicamentoToSave: medicamento))
                            } else {
                                let medicamento = Medicamento(nome: nome, dosagem: dosagem, quantidadeDias: quantidadeDias ?? 0, timestamp: Date(), foto: nil, intervalo: DoseInterval.every15Minutes.label)
                                manager.navigate(to: .frequency(medicamentoToSave: medicamento))
                            }
                      
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Concluído") {
                        focusedField = false
                    }
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
        .onChange(of: imageSelection ?? PhotosPickerItem(itemIdentifier: ""), { oldValue, newValue in
            let _ = loadTransferable(from: newValue)
        })
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case .success(let image?):
                    self.imageMedicine = image
                case .success(nil):
                    self.imageMedicine = nil
                case .failure(let error):
                    dump(error)
                }
            }
        }
    }
}
