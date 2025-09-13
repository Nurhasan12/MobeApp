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
                HStack {
                    if let data = car.image, let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                    
                    Text(car.name ?? "")
                }
                .onTapGesture {
                    idCar = car.carId ?? UUID()
                    if let selectedCar = viewModel.cars.first(where: { $0.carId == car.carId }) {
                        viewModel.syncInspectionItems(for: selectedCar)
                    }
                    showComponent = true
                }
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .sheet(isPresented: $showComponent, onDismiss: didDismiss) {
            InspectionListItem()
        }
        
    }
    func didDismiss() {
        let car = viewModel.cars
        if let selectedCar = car.first(where: { $0.carId == idCar }) {
            let items = viewModel.itemsInspection
            viewModel.addComponentsIfNotExist(to: selectedCar, items: items)
            
            if let komponenSet = selectedCar.komponen as? Set<Component> {
                for component in komponenSet {
                    if let item = viewModel.itemsInspection.first(where: { $0.title == component.name }) {
                        viewModel.addOrUpdateChecklist(
                            to: component,
                            status: item.status,
                            notes: item.note
                        )
                    }
                }
            }
            
            let total =  viewModel.totalStatus(for: selectedCar)
            print("total status: \(total)")
        }
    }
}
