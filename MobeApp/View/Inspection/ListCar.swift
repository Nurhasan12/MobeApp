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
                NavigationLink(destination: DetailCar(car: car)) {
                    CarRow(car: car)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    
                    // DELETE
                    Button(role: .destructive) {
                        if let index = viewModel.cars.firstIndex(of: car) {
                            viewModel.deleteItems(offsets: IndexSet(integer: index))
                        }
                    } label: {
                        Label("Hapus", systemImage: "trash")
                    }
                    
                    // EDIT
                    Button {
                        selectedCar = car
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .id(viewModel.cars.count)
        .sheet(item: $selectedCar, onDismiss: {
            selectedCar = nil
        }) { car in
            EditCarView(car: car)
        }
    }
}


