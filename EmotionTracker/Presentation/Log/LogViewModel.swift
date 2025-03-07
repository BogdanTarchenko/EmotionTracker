//
//  LogViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

final class LogViewModel {
    var emotionCards: [EmotionCardViewModel] = []
    
    func getEmotionData(at index: Int) -> (title: String, color: UIColor, time: String)? {
        guard index < emotionCards.count else { return nil }
        let card = emotionCards[index]
        return (
            title: card.emotion,
            color: card.emotionColor.toUIColor(),
            time: card.time
        )
    }
    
    func addNewEmotionCard(emotion: String, emotionColor: EmotionColor) {
        let newCard = EmotionCardViewModel(
            time: Date().formattedRelativeTime(),
            emotion: emotion,
            emotionColor: emotionColor,
            icon: UIImage(named: "TestEmotionImg")
        )
        emotionCards.append(newCard)
    }
    
    init() {
        emotionCards = [
            EmotionCardViewModel(time: "вчера, 23:40", emotion: "выгорание", emotionColor: .blue, icon: UIImage(named: "TestEmotionImg")),
            EmotionCardViewModel(time: "вчера, 23:40", emotion: "выгорание", emotionColor: .green, icon: UIImage(named: "TestEmotionImg"))
        ]
    }
}

