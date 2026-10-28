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

    @State private var toggleState = false
    
    @State private var imageSelection: PhotosPickerItem?
    @State private var showImagePicker: Bool
    @State private var nome: String
    @State private var dosagem: String
    @State private var date: Date?
    @State private var quantidadeDias: Int?
    @State private var numberFormatter: NumberFormatter
    @State private var alertValidation: Bool

    private enum Campo: Hashable {
        case nome
        case dosagem
        case quantidadeDias
    }

    @FocusState private var focusedField: Campo?

    @State private var imageMedicine: Image?
    @State private var showErrorFormatImage: Bool

    init(
        imageSelection: PhotosPickerItem? = nil,
        showImagePicker: Bool = false,
        nome: String = "",
        dosagem: String = "",
        date: Date? = nil,
        quantidadeDias: Int? = nil,
        numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter
        }(),
        alertValidation: Bool = false,
        imageMedicine: Image? = nil,
        showErrorFormatImage: Bool = false
    ) {
        _imageSelection = State(initialValue: imageSelection)
        _showImagePicker = State(initialValue: showImagePicker)
        _nome = State(initialValue: nome)
        _dosagem = State(initialValue: dosagem)
        _date = State(initialValue: date)
        _quantidadeDias = State(initialValue: quantidadeDias)
        _numberFormatter = State(initialValue: numberFormatter)
        _alertValidation = State(initialValue: alertValidation)
        _imageMedicine = State(initialValue: imageMedicine)
        _showErrorFormatImage = State(initialValue: showErrorFormatImage)
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Adicionar Medicamento")
                    .font(.title)
                    .padding(.vertical, 20)
                
                PhotosPicker(
                    selection: $imageSelection,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    VStack {
                        if let imageMedicine {
                            imageMedicine
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.black)
                        }
                        
                        Text("Foto")
                            .font(.callout)
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 60)
                }
                .buttonStyle(.borderless)
                
                Form {
                    Section {
                        TextField(
                            "Nome medicamento",
                            text: $nome,
                            prompt: Text("Nome medicamento")
                        )
                        .focused($focusedField, equals: .nome)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .dosagem
                        }
                        
                        TextField(
                            "Dosagem",
                            text: $dosagem,
                            prompt: Text("Dosagem")
                        )
                        .focused($focusedField, equals: .dosagem)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .quantidadeDias
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Quantidade de dias")
                            
                            TextField(
                                "Quantidade de dias",
                                value: $quantidadeDias,
                                format: .number,
                                prompt: Text("Obrigatório")
                            )
                            .focused($focusedField, equals: .quantidadeDias)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                        }
                    }
                    
                    Section {
                        Button {
                            guard !nome.isEmpty,
                                  !dosagem.isEmpty,
                                  quantidadeDias != nil else {
                                alertValidation = true
                                return
                            }
                            
                            let fotoData: Data?
                            
                            if let imageMedicine {
                                let renderer = ImageRenderer(content: imageMedicine)
                                fotoData = renderer.uiImage?.pngData()
                            } else {
                                fotoData = nil
                            }
                            
                            let medicamento = Medicamento(
                                nome: nome,
                                dosagem: dosagem,
                                quantidadeDias: quantidadeDias ?? 0,
                                timestamp: Date(),
                                foto: fotoData,
                                intervalo: DoseInterval.every15Minutes.label
                            )
                            
                            focusedField = nil
                            manager.navigate(to: .frequency(medicamentoToSave: medicamento))
                        } label: {
                            Text("Seguinte")
                                .padding(20)
                                .foregroundStyle(.black)
                                .background {
                                    RoundedRectangle(
                                        cornerRadius: 50,
                                        style: .continuous
                                    )
                                    .fill(.yellow)
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
                            focusedField = nil
                        }
                    }
                }
            }
        }
        .onAppear {
            imageMedicine = nil
            nome = ""
            dosagem = ""
            quantidadeDias = nil
        }
        .alert("", isPresented: $alertValidation) {
            Button("OK", role: .confirm) {
                alertValidation = false
            }
        } message: {
            Text("Preencha todos os campos!")
        }
        .alert("", isPresented: $showErrorFormatImage) {
            Button("OK", role: .confirm) {
                showErrorFormatImage = false
            }
        } message: {
            Text("Formato de imagem inválido")
        }
        .onChange(of: imageSelection) { _, newValue in
            guard let newValue else { return }
            _ = loadTransferable(from: newValue)
        }
    }

    @discardableResult
    private func loadTransferable(from selection: PhotosPickerItem) -> Progress {
        selection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                guard selection == imageSelection else { return }

                switch result {
                case .success(let image?):
                    imageMedicine = image

                case .success(nil):
                    imageMedicine = nil
                    showErrorFormatImage = true

                case .failure(let error):
                    dump(error)
                }
            }
        }
    }
}
