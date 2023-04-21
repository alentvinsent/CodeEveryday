//
//  ContentView.swift
//  RotatingCircles
//
//  Created by Apple  on 22/04/23.
//

import SwiftUI

struct ContentView: View {
    @State var animated:Bool = false
    var body: some View {
        ZStack{
            ForEach(0..<20){i in
                let circles:Int = (i+1) * 3
                ForEach(0..<circles,id: \.self){j in
                    Circle()
                        .frame(width: 3,height: 3)
                        .offset(x:-(CGFloat(i)*5))
                        .rotationEffect(.degrees(Double(j)*2))
                        .rotationEffect(.degrees(animated ? 0 : 360))
                        .animation(.linear(duration:0.6).repeatForever(autoreverses:false))
                }
            }
        }
        .onAppear{
            animated.toggle()
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
