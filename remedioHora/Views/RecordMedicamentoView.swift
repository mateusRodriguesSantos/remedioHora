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
    //@State var path: NavigationPath = NavigationPath()
    //@State var showModal: Bool = true
    
    var body: some View {
        VStack {
            Button {
                manager.navigate(to: .frequency)
            } label: {
                Text("Ir para frequency")
            }

        }
    }
}

#Preview {
    //RecordMedicamentoView()
        //.modelContainer(for: Medicamento.self, inMemory: true)
}
