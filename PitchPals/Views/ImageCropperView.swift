//
//  VenueDetailView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 22/01/2024.
//

import SwiftUI

import SwiftUI

struct ImageCropperView: View {
    @Binding var image: UIImage? // Image to be cropped
    @Environment(\.presentationMode) var presentationMode
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var initialScaleSet = false // To ensure the initial scale is set once

    var onSave: (UIImage) -> Void // Callback to save the cropped image
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                if let image = image {
                    // Cropping image view
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .scaleEffect(scale)
                        .offset(offset)
                        .gesture(
                            DragGesture().onChanged { value in
                                self.offset = value.translation
                            }
                        )
                        .gesture(
                            MagnificationGesture().onChanged { value in
                                self.scale = value.magnitude
                            }
                        )
                        .onAppear {
                            if !initialScaleSet {
                                setInitialScaleAndOffset(imageSize: image.size, containerSize: geometry.size)
                            }
                        }
                    
                    // Circular overlay mask
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            }
            .overlay(
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss() // Cancel action
                        }) {
                            Text("Cancel")
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        Spacer()
                        Button(action: {
                            if let croppedImage = cropImage(geometry: geometry) {
                                onSave(croppedImage) // Call the onSave callback with cropped image
                                self.presentationMode.wrappedValue.dismiss() // Dismiss view
                            }
                        }) {
                            Text("Done")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    Spacer()
                }
            )
        }
    }

    private func setInitialScaleAndOffset(imageSize: CGSize, containerSize: CGSize) {
        let scaleWidth = containerSize.width / imageSize.width
        let scaleHeight = containerSize.height / imageSize.height
        let minScale = max(scaleWidth, scaleHeight)

        self.scale = minScale
        self.offset = .zero // Center the image
        self.initialScaleSet = true
    }

    private func cropImage(geometry: GeometryProxy) -> UIImage? {
        guard let image = image else { return nil }

        let circleSize = geometry.size.width
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: circleSize, height: circleSize))

        return renderer.image { _ in
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: -offset.width + circleSize / 2, y: -offset.height + circleSize / 2)
            context?.scaleBy(x: scale, y: scale)
            image.draw(at: CGPoint.zero)
        }
    }
}
