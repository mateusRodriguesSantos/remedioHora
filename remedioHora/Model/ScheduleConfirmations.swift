//
//  ScheduleConfirmations.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 28/10/26.
//

import Foundation
import SwiftData
import UIKit

@Model
final class ScheduleConfirmations {
    var idNotification: String
    var hourConfirmations: [Date]
    
    init(
        id: String,
        hourConfirmations: [Date] = []
    ) {
        self.idNotification = id
        self.hourConfirmations = hourConfirmations
    }
}
