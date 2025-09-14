//
//  CarDetailView.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import SwiftUI
import UIKit

struct DetailCar: View {
    @State private var showEdit = false
    @State private var showInteriorModal = false


    @EnvironmentObject var viewModel: CarViewModel
    let car: Car
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Foto mobil
                if let data = car.imageData,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "car.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding()
                        .background(Circle().fill(Color.gray.opacity(0.2)))
                }
                // Info mobil
                VStack(spacing: 4) {
                    Text(car.name ?? "Tanpa Nama")
                        .font(.headline)
                    Text("\(car.year ?? "-") · \(car.kilometer ?? "-") Km · \(car.location ?? "-")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let note = car.note, !note.isEmpty {
                        Text("Catatan: \(note)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                
                // Grid menu
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
                    MenuItem(icon: "car.fill", title: "Eksterior", count: 0, total: 10)
                    MenuItem(icon: "steeringwheel", title: "Interior", count: 0, total: 8)
                        .onTapGesture {
                            viewModel.syncInspectionItems(for: car)
                            showInteriorModal = true}
                    
                    
                    MenuItem(icon: "gearshape.fill", title: "Mesin", count: 0, total: 8)
                    MenuItem(icon: "doc.fill", title: "Dokumen", count: 0, total: 5)
                }
                .padding(.top, 12)
                
                Button(action: {
                    // TODO: aksi lihat report
                }) {
                    Text("Lihat Report Kondisi Mobil")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
                // sheet
            }
            .padding()
        }
        //        .navigationTitle(car.name ?? "Detail Mobil")
        .navigationTitle("Kategori")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showEdit = true }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $showEdit) {
            EditCarView(car: car)
        }
        .sheet(isPresented: $showInteriorModal, onDismiss: didDismiss) {
            InspectionListView()
                .environmentObject(viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    func didDismiss() {
                let items = viewModel.itemsInspection
                viewModel.addComponentsIfNotExist(to: car, items: items)
                
                if let komponenSet = car.komponen as? Set<Component> {
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
                
                let total =  viewModel.totalStatus(for: car)
                print("total status: \(total)")
            }
        }



struct MenuItem: View {
    var icon: String
    var title: String
    var count: Int
    var total: Int
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(.blue)
            Text("\(count)/\(total)")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}


