//
//  EditNoteViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

final class EditNoteViewModel {
    let index: Int?
    let emotionTitle: String
    let emotionColor: UIColor
    let time: String
    var selectedTags: Set<String> = []

    init(index: Int? = nil, emotionTitle: String, emotionColor: UIColor, time: String? = nil, selectedTags: Set<String> = []) {
        self.index = index
        self.emotionTitle = emotionTitle
        self.emotionColor = emotionColor
        self.time = time ?? Date().formattedRelativeTime()
        self.selectedTags = selectedTags
    }
    
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}
