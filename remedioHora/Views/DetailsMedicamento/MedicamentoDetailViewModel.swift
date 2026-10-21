//
//  MedicamentoDetailViewModel.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 21/10/26.
//

import SwiftUI
import Combine

class MedicamentoDetailViewModel: ObservableObject {
 
    let medicamento: Medicamento
    let dateFormatter: DateFormatter = DateFormatter()
    @Published var editionMode: Bool = false
    
    init(medicamento: Medicamento) {
        self.medicamento = medicamento
    }
    
    func formatDateInit() -> String {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: medicamento.timestamp)
    }
    
    
    func formatDateLast() -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: medicamento.nextDates?.last ?? Date())
    }
}
