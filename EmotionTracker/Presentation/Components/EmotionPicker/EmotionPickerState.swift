//
//  EmotionPickerState.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 28.02.2025.
//

import UIKit

enum EmotionPickerState {
    case inactive
    case active(emotionTitle: String, emotionDescription: String, emotionColor: UIColor)
}
