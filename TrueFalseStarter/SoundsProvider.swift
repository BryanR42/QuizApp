//
//  SoundsProvider.swift
//  TrueFalseStarter
//
//  Created by Bryan Richardson on 8/7/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import AudioToolbox

struct SoundProvider {
    
    let soundsArray = [("GameSound", "wav"), ("chime_bell_ding", "wav"), ("Wrong", "mp3"), ("Cheer", "wav"), ("Aww", "wav")]
    
    // fill an array with created sounds
    func loadSounds() -> [SystemSoundID] {
        var gameSounds: [SystemSoundID] = []
        var soundHolder: SystemSoundID = 0
        for i in 0..<soundsArray.count {
            let pathToSoundFile = Bundle.main.path(forResource: soundsArray[i].0, ofType: soundsArray[i].1)
            let soundURL = URL(fileURLWithPath: pathToSoundFile!)
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundHolder)
            gameSounds.append(soundHolder)
        }
    return gameSounds
    
    }

    
    
}
