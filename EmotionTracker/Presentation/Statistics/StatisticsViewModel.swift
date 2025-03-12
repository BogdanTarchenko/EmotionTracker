//
//  StatisticsViewModel.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

import UIKit

final class StatisticsViewModel {
    private(set) var emotionCards: [EmotionCardViewModel] = []
    private var emotionSections: [EmotionSection] = []
    
    init() {}
    
    func updateWithTestData(_ cards: [EmotionCardViewModel]) {
        emotionCards = cards
    }
    
    func getEmotionsCount() -> Int {
        return emotionCards.count
    }
    
    func getEmotionsCountByColor() -> [EmotionColor: Int] {
        var result: [EmotionColor: Int] = [.blue: 0, .green: 0, .yellow: 0, .red: 0]
        
        for card in emotionCards {
            result[card.emotionColor, default: 0] += 1
        }
        
        return result
    }
    
    func getEmotionColorPercentages() -> [(color: UIColor, percentage: CGFloat)] {
        let colorCounts = getEmotionsCountByColor()
        let total = emotionCards.count
        
        guard total > 0 else { return [] }
        
        return colorCounts.map { color, count in
            (color: color.toUIColor(), percentage: CGFloat(count) / CGFloat(total))
        }
    }
} 
