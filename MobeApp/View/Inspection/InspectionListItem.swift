//
//  InspectionList.swift
//  Mobee
//
//  Created by Mac on 09/09/25.
//

import SwiftUI

struct InspectionListItem: View {
    let viewModel: CarViewModel = CarViewModel()
    
    var body: some View {
            ScrollView {
                VStack {
                    ForEach(viewModel.items) { item in
                        CheckList(item: item)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
                .padding(.top, 48)
            }
            .background(.secondary)
    }
}

#Preview {
    InspectionListItem()
}


