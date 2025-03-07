//
//  EmotionCardViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

struct EmotionCardViewModel {
    let time: String
    let emotion: String
    let emotionColor: EmotionColor
    let icon: UIImage?
    let selectedTags: Set<String>
    
    init(time: String, emotion: String, emotionColor: EmotionColor, icon: UIImage?, selectedTags: Set<String> = []) {
        self.time = time
        self.emotion = emotion
        self.emotionColor = emotionColor
        self.icon = icon
        self.selectedTags = selectedTags
    }
}
