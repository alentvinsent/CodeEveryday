//
//  Particle.swift
//  ParticleEmitter
//
//  Created by Apple  on 24/04/23.
//

import Foundation

//Paricle Model
struct Particle:Identifiable{
    var id:UUID = .init()
    var randomX:CGFloat = 0
    var randomY:CGFloat = 0
    var scale:CGFloat = 1
    
    //Optional
    var opacity:CGFloat = 1
    
    ///Resets all properties
    mutating func reset(){
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
        
    }
}
