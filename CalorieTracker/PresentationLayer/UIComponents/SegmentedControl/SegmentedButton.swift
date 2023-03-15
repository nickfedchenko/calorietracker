//
//  SegmentedButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.08.2022.
//

import UIKit

 final class SegmentedButton<ID>: UIButton {
     struct Model {
         let title: String
         let normalColor: UIColor?
         let selectedColor: UIColor?
         let id: ID
     }

     let model: Model
     
     var font: UIFont? = R.font.sfProRoundedBold(size: Constants.fontSize){
         didSet {
             titleLabel?.font = font
         }
     }

     init(_ model: Model) {
         self.model = model
         super.init(frame: .zero)
         setupButton()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupButton() {
         titleLabel?.font = font
         setTitle(model.title, for: .normal)
         setTitleColor(model.normalColor, for: .normal)
         setTitleColor(model.selectedColor, for: .selected)
         clipsToBounds = false
     }
 }

extension SegmentedButton {
    enum Constants {
        static var fontSize: CGFloat {
            switch Locale.current.languageCode {
            case "de":
                return 13.fitW
            case "en":
                return 14.fitW
            case "it":
                return 10.fitW
            default:
                return 16.fitW
            }
        }
    }
}
