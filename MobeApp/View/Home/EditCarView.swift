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
    @State private var name: String
    @State private var year: String
    @State private var kilometer: String
    @State private var location: String
    @State private var note: String
    @State private var photoData: Data?
    
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
            Form {
                Section(header: Text("Info Mobil")) {
                    TextField("Nama Mobil", text: $name)
                    TextField("Tahun", text: $year)
                    TextField("Kilometer", text: $kilometer)
                    TextField("Lokasi", text: $location)
                }
                
                Section(header: Text("Foto Mobil")) {
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo")
                            Text(photoData == nil ? "Pilih Foto" : "Ganti Foto")
                        }
                    }
                    
                    if let data = photoData, let uiImg = UIImage(data: data) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Section(header: Text("Catatan")) {
                    TextField("Catatan", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Edit Mobil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        if isEdited { showDiscardAlert = true }
                        else { dismiss() }
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
