//
//  ListCar.swift
//  MobeApp
//
//  Created by Mac on 11/09/25.
//


import SwiftUI

struct ListCar: View {
    @EnvironmentObject var viewModel: CarViewModel
    @State var showComponent = false
    @State var idCar = UUID()
    
    var body: some View {
        
        List {
            ForEach(viewModel.cars) {car in
                Text(car.name ?? "")
                    .onTapGesture {
                        showComponent = true
                        idCar = car.carId ?? UUID()
                    }
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .sheet(isPresented: $showComponent, onDismiss: didDismiss) {
            ShowInspection()
        }
        
    }
    func didDismiss() {
        let car = viewModel.cars
        if let selectedCar = car.first(where: { $0.carId == idCar }) {
            let items = viewModel.itemsInspection
            viewModel.addComponentsIfNotExist(to: selectedCar, items: items)
        }
    }
}
