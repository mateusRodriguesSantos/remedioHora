//
//  Medicamento.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Medicamento {
    var id: String
    var nome: String
    var dosagem: String
    var quantidadeDias: Int
    var timestamp: Date
    var foto: Data
    var intervalo: String
    var nextDate: Date?
    
    init(id: String = UUID().uuidString, nome: String, dosagem: String, quantidadeDias: Int, timestamp: Date, foto: Data, intervalo: String) {
        self.id = id
        self.nome = nome
        self.dosagem = dosagem
        self.quantidadeDias = quantidadeDias
        self.timestamp = timestamp
        self.foto = foto
        self.intervalo = intervalo
    }
}
