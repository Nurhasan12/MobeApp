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
    @State var isClosing = false
    
    @State private var name = ""
    @State private var year = ""
    @State private var kilometerText = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var pickerItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var showCancelConfirm = false
    
    @State private var yearError: String? = nil
    @State private var kilometerError: String? = nil
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    LabeledField(systemImage: "car.fill", hint: "Nama Mobil", text: $name)
                    LabeledField(systemImage: "calendar", hint: "Tahun", text: $year, keyboardType: .numberPad, errorMessage: yearError)
                        .onChange(of: year) { oldValue, newValue in
                            yearError = Int(newValue) == nil ? "Tahun harus angka" : nil
                        }
                    
                    LabeledField(systemImage: "speedometer", hint: "Kilometer", text: $kilometerText, keyboardType: .decimalPad, errorMessage: kilometerError)
                        .onChange(of: kilometerText) { oldValue, newValue in
                            kilometerError = Double(newValue) == nil ? "Kilometer harus angka" : nil
                        }
                    LabeledField(systemImage: "location", hint: "Lokasi", text: $location)
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "photo.badge.plus").foregroundStyle(.secondary)
                            Text("Foto Mobil (opsional)").font(.subheadline).foregroundStyle(.secondary)
                        }
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).fill(Color(.systemBlue))
                                HStack {
                                    Image(systemName: "arrow.up.doc.fill")
                                    Text(photoData == nil ? "Upload Foto" : "Ganti Foto").fontWeight(.semibold)
                                    Spacer()
                                    if photoData != nil { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                                }
                                .foregroundStyle(.white)
                                .padding(12)
                            }
                            .frame(height: 48)
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
                        viewModel.addCar(name: name, year: year, kilometer: kilometerText, location: location, note: notes, img: photoData)
                        
                        withAnimation(.easeInOut(duration: 1.0)){
                            isClosing = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss()
                        }
                        
                        print(viewModel.cars)
                    }
                    .bold()
                    .disabled(name.isEmpty || yearError != nil || kilometerError != nil)
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
    
    var keyboardType: UIKeyboardType = .default
    
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                
                TextField(hint, text: $text)
                    .keyboardType(keyboardType)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.white)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(errorMessage == nil ? Color(.quaternaryLabel) : Color.red, lineWidth: 1)
            )
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 28) // biar rata dengan text field
            }
        }
    }
}

#Preview {
    Home()
        .environmentObject(CarViewModel(context: PersistenceController.shared.container.viewContext))
}
