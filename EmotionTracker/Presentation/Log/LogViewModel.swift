//
//  LogViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 05.03.2025.
//

import UIKit

final class LogViewModel {
    var emotionCards: [EmotionCardViewModel] = []
    
    func getEmotionData(at index: Int) -> (index: Int, title: String, color: UIColor, time: String, selectedTags: Set<String>)? {
        guard index < emotionCards.count else { return nil }
        let card = emotionCards[index]
        return (
            index: index,
            title: card.emotion,
            color: card.emotionColor.toUIColor(),
            time: card.time,
            selectedTags: card.selectedTags
        )
    }
    
    func addNewEmotionCard(emotion: String, emotionColor: EmotionColor, selectedTags: Set<String>) {
        let newCard = EmotionCardViewModel(
            time: Date().formattedRelativeTime(),
            emotion: emotion,
            emotionColor: emotionColor,
            icon: UIImage(named: "TestEmotionImg"),
            selectedTags: selectedTags
        )
        emotionCards.append(newCard)
    }
    
    func updateEmotionCard(at index: Int, title: String, color: EmotionColor, selectedTags: Set<String>) {
        guard index < emotionCards.count else { return }
        let currentCard = emotionCards[index]
        let updatedCard = EmotionCardViewModel(
            time: currentCard.time,
            emotion: title,
            emotionColor: color,
            icon: currentCard.icon,
            selectedTags: selectedTags
        )
        emotionCards[index] = updatedCard
    }
    
    func findCardIndex(withTime time: String) -> Int? {
        return emotionCards.firstIndex { $0.time == time }
    }
    
    init() {
    }
}

