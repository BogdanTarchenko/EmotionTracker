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
    let tagsBySection: [[(tag: String, index: Int)]]
    let selectedSectionTags: Set<EditNoteViewModel.SectionTag>
    
    init(time: String, emotion: String, emotionColor: EmotionColor, icon: UIImage?, selectedTags: Set<String> = [], tagsBySection: [[(tag: String, index: Int)]] = [[], [], []], selectedSectionTags: Set<EditNoteViewModel.SectionTag> = []) {
        self.time = time
        self.emotion = emotion
        self.emotionColor = emotionColor
        self.icon = icon
        self.selectedTags = selectedTags
        self.tagsBySection = tagsBySection
        self.selectedSectionTags = selectedSectionTags
    }
}
