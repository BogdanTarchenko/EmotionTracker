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
    
    var tagsBySection: [[(tag: String, index: Int)]] = [[], [], []]
    
    var selectedSectionTags: Set<SectionTag> = []
    var selectedTags: Set<String> {
        get {
            return Set(selectedSectionTags.map { $0.tag })
        }
        set {
            selectedSectionTags.removeAll()
            for tag in newValue {
                for section in 0..<tagsBySection.count {
                    if tagsBySection[section].contains(where: { $0.tag == tag }) {
                        selectedSectionTags.insert(SectionTag(section: section, tag: tag))
                    }
                }
            }
        }
    }
    
    private let defaultTags = [
        ["Приём пищи", "Встреча с друзьями", "Тренировка", "Хобби", "Отдых", "Поездка"],
        ["Один", "Друзья", "Семья", "Коллеги", "Партнёр", "Питомцы"],
        ["Дом", "Работа", "Школа", "Транспорт", "Улица"]
    ]
    
    init(index: Int? = nil, 
         emotionTitle: String, 
         emotionColor: UIColor, 
         time: String? = nil, 
         selectedTags: Set<String> = [],
         tagsBySection: [[(tag: String, index: Int)]] = [],
         selectedSectionTags: Set<SectionTag> = []) {
        
        self.index = index
        self.emotionTitle = emotionTitle
        self.emotionColor = emotionColor
        self.time = time ?? Date().formattedRelativeTime()
        self.selectedTags = selectedTags
        self.selectedSectionTags = selectedSectionTags
        
        self.tagsBySection = [[], [], []]
        
        if !tagsBySection.isEmpty {
            for sectionIndex in 0..<min(tagsBySection.count, self.tagsBySection.count) {
                self.tagsBySection[sectionIndex] = tagsBySection[sectionIndex]
            }
            
            if tagsBySection.count < self.tagsBySection.count {
                initializeDefaultTags(startFrom: tagsBySection.count)
            }
        } else {
            initializeDefaultTags()
        }
    }
    
    private func initializeDefaultTags(startFrom: Int = 0) {
        for sectionIndex in startFrom..<defaultTags.count {
            for (tagIndex, tag) in defaultTags[sectionIndex].enumerated() {
                tagsBySection[sectionIndex].append((tag: tag, index: tagIndex))
            }
        }
    }
    
    func toggleTag(_ tag: String, section: Int) {
        let sectionTag = SectionTag(section: section, tag: tag)
        
        if selectedSectionTags.contains(sectionTag) {
            selectedSectionTags.remove(sectionTag)
        } else {
            selectedSectionTags.insert(sectionTag)
        }
    }
    
    func isTagSelected(_ tag: String, section: Int) -> Bool {
        return selectedSectionTags.contains(SectionTag(section: section, tag: tag))
    }
    
    func addTag(_ tag: String, section: Int) -> Bool {
        if tagExists(tag, inSection: section) {
            return false
        }
        
        let newIndex = tagsBySection[section].map { $0.index }.max() ?? 0 + 1
        
        tagsBySection[section].append((tag: tag, index: newIndex))
        
        return true
    }
    
    private func tagExists(_ tag: String, inSection section: Int) -> Bool {
        return tagsBySection[section].contains { $0.tag == tag }
    }
    
    func getTagsForSection(_ section: Int) -> [String] {
        return tagsBySection[section].sorted { $0.index < $1.index }.map { $0.tag }
    }
}
