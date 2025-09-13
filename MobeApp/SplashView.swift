//
//  SplashView.swift
//  MobeApp
//
//  Created by Mac on 13/09/25.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var moveUp = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .scaleEffect(scale)
                .offset(y: offsetY)
                .opacity(opacity)
                .onAppear {
                    // Step 1: Zoom in
                    withAnimation(.easeOut(duration: 1.0)) {
                        scale = 1.0
                    }
                    
                    // Step 2: Geser ke atas + fade out
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            offsetY = -150
                            opacity = 0.0
                        }
                    }
                }
        }
    }
}
