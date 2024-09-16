//
//  PaymentSheet.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 16/09/2024.
//

import Foundation

//  PaymentSheetWrapper.swift
//  PitchPals

import SwiftUI
import StripePaymentSheet
import Stripe

struct PaymentSheetWrapper: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var paymentSheet: PaymentSheet
    var onCompletion: (PaymentSheetResult) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear // Ensure background is transparent

        DispatchQueue.main.async {
            paymentSheet.present(from: controller) { paymentResult in
                onCompletion(paymentResult)
                presentationMode.wrappedValue.dismiss()
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No update needed
    }
}
