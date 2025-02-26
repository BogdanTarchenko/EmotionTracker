//
//  TimePickerManager.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 27.02.2025.
//

import UIKit
import SnapKit

class TimePickerManager {
    static func showTimePicker(on viewController: UIViewController, completion: @escaping (Date) -> Void) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        let alert = UIAlertController(title: LocalizedKey.AlertTimePicker.pickTimeText, message: nil, preferredStyle: .alert)
        
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }

        alert.addAction(UIAlertAction(title: LocalizedKey.AlertTimePicker.cancelButtonText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LocalizedKey.AlertTimePicker.pickButtonText, style: .default, handler: { _ in
            completion(datePicker.date)
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
