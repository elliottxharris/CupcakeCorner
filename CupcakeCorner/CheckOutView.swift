//
//  CheckOutView.swift
//  CupcakeCorner
//
//  Created by Elliott Harris on 4/13/21.
//

import SwiftUI

struct CheckOutView: View {
    @ObservedObject var order: Order
    @State private var conMessage = ""
    @State private var showingMessage = false
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingMessage) {
            Alert(title: Text("Thank you!"), message: Text(conMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {data, res, error in
            guard let data = data else {
                print("Data empty: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decoded = try? JSONDecoder().decode(Order.self, from: data) {
                conMessage = "Your order for \(decoded.quantity) \(Order.flavors[decoded.type]) cupcakes is on it's way!"
                showingMessage = true;
            } else {
                print("Invalid Response")
            }
        }.resume()
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(order: Order())
    }
}
