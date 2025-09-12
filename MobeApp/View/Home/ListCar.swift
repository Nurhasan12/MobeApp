//
//  ListCar.swift
//  MobeApp
//
//  Created by Mac on 12/09/25.
//


import SwiftUI

struct ListCar: View {
    @EnvironmentObject var viewModel: CarViewModel
    @State private var selectedCar: Car? = nil
    
    var body: some View {
        List {
            ForEach(viewModel.cars) { car in
                CarRow(car: car)
                    .onTapGesture { selectedCar = car }
                    
            }
        }
        .sheet(item: $selectedCar, onDismiss: didDismiss) { car in
            // Kalau ShowInspection butuh car, lebih enak begini:
            //            ShowInspection(car: car)
        }
    }
    
    private func didDismiss() {
        guard let car = selectedCar else { return }
        viewModel.addComponentsIfNotExist(to: car, items: viewModel.itemsInspection)
        // Reset pilihan jika mau:
        selectedCar = nil
    }
}
