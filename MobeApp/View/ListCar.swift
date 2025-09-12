import SwiftUI

struct ListCar {
    @EnvironmentObject var viewModel: CarViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.cars) {car in
                Text(car.name ?? "Gda")
            }
        }
    }
}