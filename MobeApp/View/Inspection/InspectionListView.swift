//
//  InspectionList.swift
//  Mobee
//
//  Created by Mac on 09/09/25.
//

import SwiftUI

struct InspectionListView: View {
    @EnvironmentObject var viewModel: CarViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 8) {
                    Text("Interior")
                        .font(.title3)
                        .bold()
                        .padding(.top, 16)

                    ForEach($viewModel.itemsInspection) { $item in
                        CheckList(item: $item){
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(item.id, anchor: .top)
                            }
                        }
                        .id(item.id)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
                .padding(.top, 8)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Interior")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
