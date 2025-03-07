//
//  EditNoteViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

final class EditNoteViewModel {
    let emotionTitle: String
    let emotionColor: UIColor
    let time: String

    init(emotionTitle: String, emotionColor: UIColor, time: String? = nil) {
        self.emotionTitle = emotionTitle
        self.emotionColor = emotionColor
        self.time = time ?? Date().formattedRelativeTime()
    }
}
