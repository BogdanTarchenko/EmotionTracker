//
//  AddNoteViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

class AddNoteViewModel {
    var onEmotionPickerStateChanged: ((EmotionPickerState) -> Void)?
    
    let emotions: [(title: String, color: UIColor)] = [
        ("Ярость", .redPrimary),
        ("Напряжение", .redPrimary),
        ("Зависть", .redPrimary),
        ("Беспокойство", .redPrimary),
        ("Возбуждение", .yellowPrimary),
        ("Восторг", .yellowPrimary),
        ("Уверенность", .yellowPrimary),
        ("Счастье", .yellowPrimary),
        ("Выгорание", .bluePrimary),
        ("Усталость", .bluePrimary),
        ("Депрессия", .bluePrimary),
        ("Апатия", .bluePrimary),
        ("Спокойствие", .greenPrimary),
        ("Удовлетворённость", .greenPrimary),
        ("Благодарность", .greenPrimary),
        ("Защищённость", .greenPrimary)
    ]
    
    var selectedEmotion: (title: String, color: UIColor)?
    
    func selectEmotion(emotion: (title: String, color: UIColor)) {
        selectedEmotion = emotion
        let description = "Описание эмоции: \(emotion.title)"
        let newState = EmotionPickerState.active(
            emotionTitle: emotion.title,
            emotionDescription: description,
            emotionColor: emotion.color
        )
        onEmotionPickerStateChanged?(newState)
    }
}
