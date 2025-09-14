//
//  CarViewModel.swift
//  Mobee
//
//  Created by Mac on 11/09/25.
//

import Foundation
import CoreData

class CarViewModel : ObservableObject {
    @Published var itemsInspection: [InspectionItem] = [
        InspectionItem(title: "Jok & Kursi", imageName: "jok", instruction: "Scan seluruh permukaan jok untuk noda, sobekan, atau kerusakan. Perhatikan jahitan yang longgar atau bahan yang mulai mengelupas. Cek konsistensi warna - apakah ada fading atau diskolorasi Style matters: Interior yang terawat mencerminkan perawatan keseluruhan mobil"),
        InspectionItem(title: "Dashboard", imageName: "dashboard", instruction: "Saat kunci diputar, semua lampu kecil di speedometer harus menyala sebagai tanda indikator masih berfungsi normal. Perhatikan juga angka jalan atau odometer, pastikan sesuai dengan usia mobil dan tidak terlihat janggal. Jangan lupa cek laci, pastikan bisa dibuka dan ditutup dengan lancar tanpa macet. Selain itu, semua tombol seperti lampu, wiper, dan hazard juga harus dicoba untuk memastikan semuanya bekerja dengan baik."),
        InspectionItem(title: "Setir Mobil", imageName: "setir", instruction: "Pastikan permukaannya tidak licin, lengket, atau rusak. Periksa apakah ada bagian yang aus atau robek pada material setir. Putar setir ke kanan dan ke kiri untuk memastikan putarannya mulus dan tidak ada bunyi aneh seperti gemuruh atau decitan. Pastikan setir tidak terlalu longgar saat diputar, karena ini bisa menandakan masalah pada sistem kemudi. Periksatombol yang ada di setir, seperti klakson, tombol audio, dan cruise control, untuk memastikan semuanya berfungsi dengan baik."),
        InspectionItem(title: "Karpet & Lantai", imageName: "karpet", instruction: "Perhatikan apakah ada robekan, noda membandel, atau bau tidak sedap yang mungkin menandakan adanya kebocoran atau masalah lain. Pastikan karpet terpasang dengan rapi dan tidak ada bagian yang terlipat yang bisa mengganggu saat mengemudi. Pastikan tidak ada genangan air atau karat pada lantai mobil. Pastikan juga kancing atau pengait karpet berfungsi dengan baik agar tidak bergeser saat diinjak."),
        InspectionItem(title: "AC", imageName: "ac", instruction: "Nyalakan mesin dan putar kenop AC ke suhu paling dingin. Pastikan udara yang keluar terasa dingin dengan cepat dan stabil, tidak hanya angin biasa. Perhatikan juga apakah ada bau tidak sedap, seperti bau apek atau asam, yang bisa menandakan adanya masalah pada evaporator. Dengarkan juga suara yang keluar saat AC dinyalakan; tidak boleh ada suara berisik atau dengungan yang tidak wajar. "),
        InspectionItem(title: "Odometer", imageName: "odometer", instruction: "Bagian odometer pada speedometer perlu dicek. Perhatikan angka yang tertera dan pastikan sesuai dengan usia mobil dan tidak terlihat janggal. Angka jarak tempuh yang terlalu rendah untuk mobil berusia tua bisa menjadi tanda adanya manipulasi. Sebaliknya, angka yang terlalu tinggi untuk mobil yang relatif baru juga patut dicurigai. Pastikan angkanya mudah dibaca dan tidak ada kerusakan pada layarnya, baik digital maupun analog."),
        InspectionItem(title: "Plafon", imageName: "plafon", instruction: "Pastikan permukaannya bersih dari noda dan tidak ada yang kendur atau melorot. Perhatikan apakah ada bercak-bercak air atau jamur, yang bisa menjadi tanda adanya kebocoran. Sentuh permukaannya untuk memastikan tidak ada bagian yang lepas dari rekatannya. Cek juga lampu kabin dan lampu baca di plafon, pastikan semuanya menyala dengan normal. Selain itu, periksa juga penutup sunroof (jika ada) dan pastikan bisa dibuka dan ditutup dengan lancar."),
        InspectionItem(title: "Headunit & Audio", imageName: "audio", instruction: "Pertama, nyalakan headunit dan pastikan bisa beroperasi dengan normal, tidak ada layar yang mati atau tombol yang tidak berfungsi. Coba semua sumber audio, seperti radio, USB, dan Bluetooth, untuk memastikan semuanya bisa tersambung dan memutar suara dengan baik. Dengarkan kualitas suara dari setiap speaker, pastikan tidak ada suara pecah, dengung, atau speaker yang mati. Cek juga navigasi atau kamera mundur (jika ada) dan pastikan semuanya berfungsi tanpa masalah."),
    ]
    
    
    @Published var cars: [Car] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchCars()
    }
    
    func fetchCars() {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Car.createdAt, ascending: true)]
        do {
            cars = try context.fetch(request)
        } catch {
            print("Fetch gagal: \(error.localizedDescription)")
        }
    }
    
    func totalStatus(for car: Car) -> Int {
        let komponenSet = car.komponen as? Set<Component> ?? []
        return komponenSet.compactMap { $0.checklist?.stats }
                         .map { Int($0) }
                         .reduce(0, +)
    }

    
    func syncInspectionItems(for car: Car) {
        // Reset dulu status & note semua item
        for i in 0..<itemsInspection.count {
            itemsInspection[i].status = 0
            itemsInspection[i].note = ""
        }

        // Ambil semua komponen dari mobil
        if let komponenSet = car.komponen as? Set<Component> {
            for component in komponenSet {
                // Cari itemInspection yang cocok dengan nama component
                if let index = itemsInspection.firstIndex(where: { $0.title == component.name }) {
                    if let checklist = component.checklist {
                        // Update nilai status & note dari Core Data
                        itemsInspection[index].status = Int(checklist.stats)
                        itemsInspection[index].note = checklist.note ?? ""
                    }
                }
            }
        }
    }
    
    func statusSummary(for car: Car) -> (good: Int, attention: Int, critical: Int) {
        let komponenSet = car.komponen as? Set<Component> ?? []
        
        var good = 0, attention = 0, critical = 0
        
        for comp in komponenSet {
            if let stats = comp.checklist?.stats {
                switch stats {
                case 5: good += 1
                case 3: attention += 1
                case 1: critical += 1
                default: break
                }
            }
        }
        return (good, attention, critical)
    }
    
    func percentageScore(for car: Car) -> Int {
        let komponenSet = car.komponen as? Set<Component> ?? []

        var totalScore = 0
        var counted = 0

        for comp in komponenSet {
            let s = Int(comp.checklist?.stats ?? 0)   // null → 0
            if s > 0 {
                totalScore += min(s, 5)              // jaga-jaga kalau ada nilai >5
                counted += 1                          // hanya hitung komponen yang >0
            }
        }

        guard counted > 0 else { return 0 }          // hindari pembagian nol
        let maxScore = counted * 5                    // hanya komponen yang >0
        return (totalScore * 100) / maxScore
    }
    
    func countComponent(for car: Car) -> Int {
        let komponenSet = car.komponen as? Set<Component> ?? []
        
        var counted = 0
        
        for comp in komponenSet {
            let s = Int(comp.checklist?.stats ?? 0)   // null → 0
            if s > 0 {
                counted += 1                          // hanya hitung komponen yang >0
            }
        }
        return counted
    }
    

    
    func addCar(
        name: String, year: String, kilometer: String, location: String, note: String, img: Data? ) {
            let car = Car(context: context)
            car.createdAt = Date()
            car.carId = UUID()
            car.name = name
            car.year = year
            car.kilometer = kilometer
            car.location = location
            car.note = note
            car.imageData = img
            save()
        }
    
    func updateCar(_ car: Car,
                   name: String,
                   year: String,
                   kilometer: String,
                   location: String,
                   note: String,
                   imageData: Data?) {
        car.name = name
        car.year = year
        car.kilometer = kilometer
        car.location = location
        car.note = note
        car.imageData = imageData
        save()
    }

    
    func addComponentsIfNotExist(to car: Car, items: [InspectionItem]) {
        // take all component in spesific car
        let existingComponents = (car.komponen as? Set<Component>) ?? []

        for item in items {
            let name = item.title

            // check if car have same component
            if existingComponents.contains(where: { $0.name == name }) {
                print("❌ Komponen \(name) sudah ada di mobil \(car.name ?? "")")
                continue
            }

            // if component not exist
            let component = Component(context: context)
            component.componentId = UUID()
            component.name = name
            component.car = car
            car.addToKomponen(component)

            print("✅ Komponen \(name) ditambahkan ke mobil \(car.name ?? "")")
        }

        save()
    }
    
    func addOrUpdateChecklist(to component: Component, status: Int, notes: String) {
        // Ambil checklist yang sudah ada

        if let checklist = component.checklist {
            // Kalau sudah ada, update
            checklist.stats = Int16(status)
            checklist.note = notes

            if let carName = component.car?.name, let compName = component.name {
                print("🔄 Checklist di \(compName) mobil \(carName) berhasil diupdate")
            }
        } else {
            // Kalau belum ada, buat baru
            let checklist = Checklist(context: context)
            checklist.checklistId = UUID()
            checklist.stats = Int16(status)
            checklist.note = notes
            checklist.komponen = component

            if let carName = component.car?.name, let compName = component.name {
                print("✅ Checklist baru ditambahkan ke \(compName) di mobil \(carName)")
            }
        }

        save()
    }


    
    func deleteItems(offsets: IndexSet) {
        offsets.map { cars[$0] }.forEach(context.delete)
        
        do {
            save()
        }
    }
    
    private func save() {
        do {
            try context.save()
            fetchCars()
        } catch {
            print("Save gagal: \(error.localizedDescription)")
        }
    }
}
