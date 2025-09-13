//
//  AddInspect.swift
//  MobeApp
//
//  Created by Mac on 11/09/25.
//

import SwiftUI
import PhotosUI
import UIKit
import CoreData

struct AddCar: View {
    @EnvironmentObject var viewModel: CarViewModel
    
    
    @Environment(\.dismiss) private var dismiss
    
    // State ringan (UI only)
    @State private var name = ""
    @State private var year = ""
    @State private var kilometerText = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var pickerItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showCancelConfirm = false
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    LabeledField(systemImage: "car.fill", hint: "Nama Mobil", text: $name)
                    LabeledField(systemImage: "calendar", hint: "Tahun", text: $year)
                    LabeledField(systemImage: "speedometer", hint: "Kilometer", text: $kilometerText)
                    LabeledField(systemImage: "location", hint: "Lokasi", text: $location)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "photo.badge.plus").foregroundStyle(.secondary)
                            Text("Foto Mobil (opsional)").font(.subheadline).foregroundStyle(.secondary)
                        }
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            PhotoUploadButton(hasPhoto: photoData != nil)
                        }
                        .onChange(of: pickerItem, initial: false) { oldItem, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    photoData = data
                                }
                            }
                        }
                        
                        
                        if let data = photoData, let uiImg = UIImage(data: data) {
                            Image(uiImage: uiImg)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 160)
                                .clipped()
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "square.and.pencil").foregroundStyle(.secondary)
                            Text("Tambahkan Catatan").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(16)
            }
            .navigationTitle("Isikan Info Mobil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Batalkan") { showCancelConfirm = true }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Simpan") {
                        let defaultData = UIImage(
                            systemName: "car.fill"
                        )?.pngData()
                        viewModel.addCar(name: name, year: year, kilometer: kilometerText, location: location, note: notes, img: photoData ?? defaultData)
                        
                        dismiss()
                        print(viewModel.cars)
                    }
                    .bold()
                    .disabled(name.isEmpty)
                }
            }
            .confirmationDialog("Batalkan pengisian?", isPresented: $showCancelConfirm, titleVisibility: .visible) {
                Button("Ya, batalkan", role: .destructive) { dismiss() }
                Button("Lanjutkan mengisi", role: .cancel) {}
            } message: {
                Text("Perubahan yang belum disimpan akan hilang.")
            }
        }
    }
    
    
    //    private func save() {
    //            let km = Int(kilometerText) // RAW: kalau bukan angka murni → nil
    //            let newCar = Car(
    //                name: name,
    //                year: year,
    //                kilometer: km,
    //                location: location,
    //                notes: notes,
    //                imageData: photoData
    //            )
    //            cars.append(newCar) // Home akan auto-save via onChange
    //            dismiss()
    //        }
    
}

struct LabeledField: View {
    let systemImage: String
    let hint: String
    @Binding var text: String
    
    var body: some View {
        let bg = RoundedRectangle(cornerRadius: 12).fill(Color(.white))
        let border = RoundedRectangle(cornerRadius: 12).stroke(Color(.quaternaryLabel), lineWidth: 1)
        
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            TextField(hint, text: $text)
        }
        .padding(12)
        .background(bg)
        .overlay(border)
    }
}


