//
//  SubscribtionView.swift
//  PitchPals
//
//  Created by Abdulaziz Al Mannai on 31/08/2024.
//


import SwiftUI
import Firebase
import StripePaymentSheet
import Stripe


struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedPlan: SubscriptionPlan?
    @State private var showingPaymentSheet = false
    @State private var paymentSheet: PaymentSheet?
    @State private var isProcessingPayment = false
    @State private var paymentResult: PaymentSheetResult?
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 25) {
            // HStack for Back Button and Title
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                        .background(Circle().fill(Color(.systemGray6)))
                }

                Spacer()

                Text("Choose Your Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()

                // Placeholder to balance the HStack
                Image(systemName: "chevron.left")
                    .foregroundColor(.clear)
                    .padding()
                    .background(Circle().fill(Color.clear))
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(SubscriptionPlan.allPlans, id: \.self) { plan in
                        SubscriptionPlanCard(plan: plan, isSelected: selectedPlan == plan)
                            .onTapGesture {
                                withAnimation {
                                    selectedPlan = plan
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }


            if isProcessingPayment {
                ProgressView("Processing Payment...")
                    .padding()
            }

            // Remove Spacer() to bring the button closer to the content
            Button(action: {
                if let selectedPlan = selectedPlan {
                    initiatePayment(for: selectedPlan)
                } else {
                    // Show an alert prompting the user to select a plan
                    alertMessage = "Please select a plan to continue."
                    showAlert = true
                }
            }) {
                Text("Continue to Purchase")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(isProcessingPayment)
            .padding(.vertical, 10) // Adjusted padding
        }
        .padding()
        .background(Color.white)
        .navigationBarTitle("Subscription", displayMode: .inline)
        .onAppear {
            // Configure Stripe
            StripeAPI.defaultPublishableKey = "pk_test_YourPublishableKey" // Replace with your publishable key
        }
        .sheet(isPresented: $showingPaymentSheet) {
            PaymentSheetWrapper(paymentSheet: paymentSheet!) { result in
                paymentResult = result
                showingPaymentSheet = false
                handlePaymentResult(result)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Subscription Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func initiatePayment(for plan: SubscriptionPlan) {
        isProcessingPayment = true

        // Fetch Payment Intent client secret from your backend
        let url = URL(string: "https://your-backend.com/create-payment-intent")! // Replace with your backend URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = ["amount": plan.priceCents, "currency": "usd"] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            isProcessingPayment = false
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                    let clientSecret = json["clientSecret"] as! String

                    DispatchQueue.main.async {
                        // Prepare PaymentSheet
                        var configuration = PaymentSheet.Configuration()
                        configuration.merchantDisplayName = "Pitch Pals"
                        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
                        self.showingPaymentSheet = true
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            } else if let error = error {
                print("Error creating PaymentIntent: \(error)")
            }
        }.resume()
    }

    func handlePaymentResult(_ result: PaymentSheetResult) {
        switch result {
        case .completed:
            // Update user's subscription status in Firestore
            updateSubscriptionStatus(plan: selectedPlan!)
            alertMessage = "Payment completed! You are now subscribed to the Premium plan (\(selectedPlan!.duration))."
            showAlert = true
            print("Payment completed!")
        case .canceled:
            alertMessage = "Payment canceled."
            showAlert = true
            print("Payment canceled.")
        case .failed(let error):
            alertMessage = "Payment failed: \(error.localizedDescription)"
            showAlert = true
            print("Payment failed: \(error.localizedDescription)")
        }
    }

    func updateSubscriptionStatus(plan: SubscriptionPlan) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(userId).updateData([
            "subscriptionPlan": "Premium",
            "subscriptionDuration": plan.duration,
            "subscriptionDate": Timestamp(date: Date())
        ]) { error in
            if let error = error {
                print("Error updating subscription status: \(error)")
            } else {
                print("Subscription status updated successfully.")
            }
        }
    }
}

// Updated SubscriptionPlan model with features and discounts
struct SubscriptionPlan: Hashable {
    let duration: String
    let features: [String]
    let price: String          // Current discounted price
    let originalPrice: String  // Original higher price
    let priceCents: Int
    let tag: String?

    static let yearly = SubscriptionPlan(
        duration: "1 Year",
        features: ["Save 50%", "7 Days Free"],
        price: "$60",
        originalPrice: "$120",
        priceCents: 6000,
        tag: "BEST VALUE"
    )

    static let threeMonths = SubscriptionPlan(
        duration: "3 Months",
        features: ["Save 20%", "3 Days Free"],
        price: "$24",
        originalPrice: "$30",
        priceCents: 2400,
        tag: "MOST POPULAR"
    )

    static let monthly = SubscriptionPlan(
        duration: "1 Month",
        features: ["Save 16%"],
        price: "$8.40",
        originalPrice: "$10",
        priceCents: 840,
        tag: nil
    )

    static let allPlans = [yearly, threeMonths, monthly]
}



struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool

    // Define colors
    let tagColor = Color(red: 191/255, green: 87/255, blue: 0/255) // Dark Orange

    var body: some View {
        HStack {
            // Left Side: Plan Details
            VStack(alignment: .leading, spacing: 8) {
                // HStack for Title and Tag
                HStack {
                    Text(plan.duration)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Tag beside the title
                    if let tag = plan.tag {
                        Text(tag)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(tagColor)
                            .cornerRadius(5)
                    }
                }

                ForEach(plan.features, id: \.self) { feature in
                    HStack(spacing: 5) {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.black.opacity(0.9))
                            .font(.caption)

                        Text(feature)
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                }
            }

            Spacer()

            // Right Side: Prices
            VStack(alignment: .trailing, spacing: 4) {
                // Original Price with Strikethrough
                Text(plan.originalPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .strikethrough()

                // Current Discounted Price
                Text(plan.price)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black : Color.gray.opacity(0.2), lineWidth: 2)
        )
        .shadow(color: isSelected ? Color.black.opacity(0.3) : Color.gray.opacity(0.1), radius: isSelected ? 6 : 3, x: 0, y: 3)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}




struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}

