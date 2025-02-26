//
//  Pluralize.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 24.02.2025.
//

func pluralize(count: Int, one: String, few: String, many: String) -> String {
    let mod10 = count % 10
    let mod100 = count % 100
    
    if mod10 == 1 && mod100 != 11 {
        return one
    }
    
    if mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20) {
        return few
    }
    
    return many
}
