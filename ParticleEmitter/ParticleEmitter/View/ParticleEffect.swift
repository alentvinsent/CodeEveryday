//
//  ParticleEffect.swift
//  ParticleEmitter
//
//  Created by Apple  on 24/04/23.
//

import SwiftUI

//Custom View modifier
extension View{
    @ViewBuilder
    func particleEffect(systemImage:String,font:Font,status:Bool,activeTint:Color,inActiveTint:Color)->some View{
        self
            .modifier(
                ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
            )
    }
}

fileprivate struct ParticleModifier:ViewModifier{
    var systemImage:String
    var font:Font
    var status:Bool
    var activeTint:Color
    var inActiveTint:Color
    
    ///View Properties
    @State private var particles:[Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment:.top){
                ZStack{
                    ForEach(particles){particle in
                        Image(systemName: systemImage)
                            .foregroundColor(status ? activeTint : inActiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x:particle.randomX,y: particle.randomY)
                            .opacity(particle.opacity)
                            ///Only visible when status is active
                            .opacity(status ? 1 : 0)
                            ///Making Base visibility with zero animation
                            .animation(.none, value: status)
                    }
                }
                .onAppear{
                    ///Adding base particles for animatioin
                    if particles.isEmpty{
                        ///Change count as per our wish
                        for _  in 1...15{
                            let particle = Particle()
                            particles.append(particle)
                        }
                    }
                }//:onAppear
                .onChange(of: status) { newValue in
                    if !newValue{
                        //Reset Animation]
                        for index in particles.indices{
                            particles[index].reset()
                        }
                    }else{
                        //Activating particles
                        for index in particles.indices{
                            ///Random X and Y Calculation based on index
                            let total:CGFloat = CGFloat(particles.count)
                            let progress:CGFloat = CGFloat(index) / total
                            
                            let maxX:CGFloat = (progress > 0.5) ? 100 : -100
                            let maxY:CGFloat = 60
                            
                            let randomX:CGFloat = ((progress > 0.5  ? progress - 0.5 : progress)*maxX)
                            let randomY:CGFloat = ((progress > 0.5  ? progress - 0.5 : progress)*maxY) + 35
                            //Minscale = 0.35
                            //Maxscale = 1
                            let randomScale:CGFloat = .random(in: 0.35...1)
                            
                            withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7)){
                                //Extra random values for spreading particles accross view
                                let extraRandomX:CGFloat = (progress < 0.5 ? 0.5 : .random(in: 0...10) )
                                let extraRandomY:CGFloat = .random(in: 0...30)
                                 
                                particles[index].randomX = randomX + extraRandomX
                                particles[index].randomY = -randomY - extraRandomY
                               
                            }
                            
                            
                            //Scaling with Ease in Animation
                            withAnimation(.easeInOut(duration: 0.3)){
                                particles[index].scale = randomScale
                            }
                            
                            withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7).delay(0.25 + Double(index)*0.005)){
                                particles[index].scale = 0.001
                            }
                        }
                        
                    }
                }
            }
    }
}
