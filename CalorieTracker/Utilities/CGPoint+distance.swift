//
//  CGPoint+distance.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.08.2022.
//

import UIKit

 extension CGPoint {
     func distance(to point: CGPoint) -> CGFloat {
         return hypot(self.x - point.x, self.y - point.y)
     }

     func closestPoint(to points: [CGPoint]) -> (element: CGPoint, index: Int) {
         var minDistance: CGFloat = CGFloat(Int.max)
         var closestPoint: CGPoint = .zero
         var index: Int = 0

         for point in points.enumerated() {
             let distance = self.distance(to: point.element)
             if distance < minDistance {
                 minDistance = distance
                 closestPoint = point.element
                 index = point.offset
             }
         }
         return (element: closestPoint, index: index)
     }
 }
