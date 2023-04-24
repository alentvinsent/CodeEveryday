//
//  ContentView.swift
//  ParticleEmitter
//
//  Created by Apple  on 24/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .navigationTitle("Particle effect")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
