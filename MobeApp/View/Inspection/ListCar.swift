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
    @State private var showActionSheetForCar: Car? = nil
    @State private var showDeleteConfirm: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            List {
                ForEach(viewModel.cars) { car in
                    ZStack {
                        NavigationLink(destination: DetailCar(car: car)) {
                            //                            CarRow(car: car)
                            EmptyView()
                        }
                        .opacity(0)
                        
                        CarRow(car: car)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.1))
                                    .opacity(selectedCar == car ? 1 : 0)
                            )
                            .overlay(
                                HStack {
                                    Spacer()
                                    VStack {
                                        Menu {
                                            Button {
                                                selectedCar = car
                                            } label: {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            Button(role: .destructive) {
                                                showActionSheetForCar = car
                                                showDeleteConfirm = true
                                            } label: {
                                                Label("Hapus", systemImage: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.gray)
                                                .padding(8)
                                        }
                                        Spacer()
                                    }
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        //                            .onTapGesture {
                        //                                selectedCar = car
                        //                            }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button {
                            selectedCar = car
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        Button(role: .destructive) {
                            showActionSheetForCar = car
                            showDeleteConfirm = true
                        } label: {
                            Label("Hapus", systemImage: "trash")
                        }
                    }
                    
                    
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .sheet(item: $selectedCar) { car in
            EditCarView(car: car)
        }
        .alert("Yakin ingin menghapus mobil ini?", isPresented: $showDeleteConfirm) {
            Button("Hapus", role: .destructive) {
                if let car = showActionSheetForCar,
                   let index = viewModel.cars.firstIndex(of: car) {
                    viewModel.deleteItems(offsets: IndexSet(integer: index))
                }
                showActionSheetForCar = nil
            }
            Button("Batal", role: .cancel) {
                showActionSheetForCar = nil
            }
        }
    }
}
