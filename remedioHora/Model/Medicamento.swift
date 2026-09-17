//
//  Medicamento.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 16/09/26.
//

import Foundation
import SwiftData

@Model
final class Medicamento {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
