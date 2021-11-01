//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Elliott Harris on 4/13/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select cake type", selection: $order.type) {
                        ForEach(0..<Order.flavors.count) {
                            Text(Order.flavors[$0])
                        }
                    }
                    
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes \(order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.specialRequestEnabled.animation(), label: {
                        Text("Any special requests?")
                    })
                    
                    if order.specialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting, label: {
                            Text("Extra Frosting")
                        })
                        
                        Toggle(isOn: $order.addSprinkles, label: {
                            Text("Add sprinkles")
                        })
                    }
                }
                
                Section {
                    NavigationLink("Order details", destination: AddressView(order: order))
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
