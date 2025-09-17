//
//  EditCarView.swift
//  MobeApp
//
//  Created by Mac on 12/09/25.
//

import SwiftUI
import UIKit

struct EditCarView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: CarViewModel
    
    let car: Car
    
    @State private var showDiscardAlert = false
    @State private var showImagePicker = false
    
    // Form Fields
    @State private var name: String
    @State private var year: String
    @State private var kilometer: String
    @State private var location: String
    @State private var note: String
    @State private var photoData: Data?
    
    // Error States
    @State private var yearError: String? = nil
    @State private var kilometerError: String? = nil
    
    init(car: Car) {
        self.car = car
        _name = State(initialValue: car.name ?? "")
        _year = State(initialValue: car.year ?? "")
        _kilometer = State(initialValue: car.kilometer ?? "")
        _location = State(initialValue: car.location ?? "")
        _note = State(initialValue: car.note ?? "")
        _photoData = State(initialValue: car.imageData)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    LabeledField(systemImage: "car.fill", hint: "Nama Mobil", text: $name)
                    
                    LabeledField(systemImage: "calendar", hint: "Tahun", text: $year, keyboardType: .numberPad, errorMessage: yearError)
                        .onChange(of: year) { oldValue, newValue in
                            yearError = Int(newValue) == nil ? "Tahun harus angka" : nil
                        }
                    
                    LabeledField(systemImage: "speedometer", hint: "Kilometer", text: $kilometer, keyboardType: .decimalPad, errorMessage: kilometerError)
                        .onChange(of: kilometer) { oldValue, newValue in
                            kilometerError = Double(newValue) == nil ? "Kilometer harus angka" : nil
                        }
                    
                    LabeledField(systemImage: "location", hint: "Lokasi", text: $location)
                    
                    // Image picker
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "photo").foregroundStyle(.secondary)
                            Text("Foto Mobil").font(.subheadline).foregroundStyle(.secondary)
                        }
                        
                        Button(action: { showImagePicker = true }) {
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
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: "square.and.pencil").foregroundStyle(.secondary)
                            Text("Catatan").font(.subheadline).foregroundStyle(.secondary)
                        }
                        TextEditor(text: $note)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(16)
            }
            .navigationTitle("Edit Mobil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        if isEdited {
                            showDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        viewModel.updateCar(
                            car,
                            name: name,
                            year: year,
                            kilometer: kilometer,
                            location: location,
                            note: note,
                            imageData: photoData
                        )
                        dismiss()
                    }
                    .disabled(name.isEmpty || yearError != nil || kilometerError != nil)
                }
            }
            .confirmationDialog(
                "Apakah yakin ingin membatalkan edit?",
                isPresented: $showDiscardAlert,
                titleVisibility: .visible
            ) {
                Button("Buang Perubahan", role: .destructive) { dismiss() }
                Button("Tetap Mengedit", role: .cancel) {}
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(imageData: $photoData)
            }
        }
    }
    
    private var isEdited: Bool {
        name != (car.name ?? "") ||
        year != (car.year ?? "") ||
        kilometer != (car.kilometer ?? "") ||
        location != (car.location ?? "") ||
        note != (car.note ?? "") ||
        photoData != car.imageData
    }
}

// MARK: - ImagePicker UIKit Wrapper
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var imageData: Data?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let data = image.jpegData(compressionQuality: 0.8) {
                parent.imageData = data
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
