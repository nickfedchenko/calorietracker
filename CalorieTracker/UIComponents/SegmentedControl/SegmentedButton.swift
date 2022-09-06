//
//  SegmentedButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.08.2022.
//

import AsyncDisplayKit

 final class SegmentedButton<ID>: ASButtonNode {
     struct Model {
         let title: String
         let normalColor: UIColor?
         let selectedColor: UIColor?
         let id: ID
     }

     let model: Model
     
     var font: UIFont? = R.font.sfProDisplaySemibold(size: 16)

     init(_ model: Model) {
         self.model = model
         super.init()
         setupButton()
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     private func setupButton() {
         setTitle(model.title, with: font, with: model.normalColor, for: .normal)
         setTitle(model.title, with: font, with: model.selectedColor, for: .selected)
         clipsToBounds = false
     }
 }
