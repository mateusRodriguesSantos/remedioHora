//
//  DoseInterval.swift
//  remedioHora
//
//  Created by Mateus Rodrigues on 17/09/26.
//

import Foundation

enum DoseInterval: CaseIterable, Identifiable {
    case every15Minutes
    case every30Minutes
    case every1Hour
    case every2Hours
    case every3Hours
    case every4Hours
    case every6Hours
    case every8Hours
    case every12Hours
    case every24Hours
    case every2Days
    case every1Week
    case every15Days
    case every1Month
    
    var id: String { String(describing: self) }
    
    var label: String {
        switch self {
        case .every15Minutes: return "A cada 15 minutos"
        case .every30Minutes: return "A cada 30 minutos"
        case .every1Hour:     return "A cada 1 hora"
        case .every2Hours:    return "A cada 2 horas"
        case .every3Hours:    return "A cada 3 horas"
        case .every4Hours:    return "A cada 4 horas"
        case .every6Hours:    return "A cada 6 horas"
        case .every8Hours:    return "A cada 8 horas"
        case .every12Hours:   return "A cada 12 horas"
        case .every24Hours:   return "A cada 24 horas"
        case .every2Days:     return "A cada 2 dias"
        case .every1Week:     return "A cada 1 semana"
        case .every15Days:    return "A cada 15 dias"
        case .every1Month:    return "A cada 1 mês"
        }
    }
    
    var components: DateComponents {
        switch self {
        case .every15Minutes: return DateComponents(minute: 15)
        case .every30Minutes: return DateComponents(minute: 30)
        case .every1Hour:     return DateComponents(hour: 1)
        case .every2Hours:    return DateComponents(hour: 2)
        case .every3Hours:    return DateComponents(hour: 3)
        case .every4Hours:    return DateComponents(hour: 4)
        case .every6Hours:    return DateComponents(hour: 6)
        case .every8Hours:    return DateComponents(hour: 8)
        case .every12Hours:   return DateComponents(hour: 12)
        case .every24Hours:   return DateComponents(day: 1)
        case .every2Days:     return DateComponents(day: 2)
        case .every1Week:     return DateComponents(weekOfYear: 1)
        case .every15Days:    return DateComponents(day: 15)
        case .every1Month:    return DateComponents(month: 1)
        }
    }
    
    var seconds: Int {
        switch self {
        case .every15Minutes:
            return 15 * 60
        case .every30Minutes:
            return 30 * 60
        case .every1Hour:
            return 1 * 60 * 60
        case .every2Hours:
            return 2 * 60 * 60
        case .every3Hours:
            return 3 * 60 * 60
        case .every4Hours:
            return 4 * 60 * 60
        case .every6Hours:
            return 6 * 60 * 60
        case .every8Hours:
            return 8 * 60 * 60
        case .every12Hours:
            return 12 * 60 * 60
        case .every24Hours:
            return 24 * 60 * 60
        case .every2Days:
            return 2 * 24 * 60 * 60
        case .every1Week:
            return 7 * 24 * 60 * 60
        case .every15Days:
            return 15 * 24 * 60 * 60
        case .every1Month:
            return 30 * 24 * 60 * 60
        }
    }
    
    static func verify(dose: String) -> DoseInterval? {
        for inteval in DoseInterval.allCases {
            if dose == inteval.label {
                return inteval
            }
        }
        return nil
    }
    
    static var allCases: [DoseInterval] {
        [
            .every15Minutes,
            .every30Minutes,
            .every1Hour,
            .every2Hours,
            .every3Hours,
            .every4Hours,
            .every6Hours,
            .every8Hours,
            .every12Hours,
            .every24Hours,
            .every2Days,
            .every1Week,
            .every15Days,
            .every1Month
        ]
    }
}
