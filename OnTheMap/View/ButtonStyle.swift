//
//  ButtonStyle.swift
//  OnTheMap
//
//  Created by Guido Roos on 03/08/2023.
//

import UIKit

struct MyButtonStyle {
    let backgroundColor: UIColor
    let cornerRadius: CGFloat
    let titleColor: UIColor

    
    static func standardButtonStyle() -> MyButtonStyle {
            return MyButtonStyle(
                backgroundColor: .secondary,
                cornerRadius: 10,
                titleColor: .black
            )
        }
}

extension UIButton {
    func apply(style: MyButtonStyle) {
        self.backgroundColor = style.backgroundColor
        self.layer.cornerRadius = style.cornerRadius
        self.setTitleColor(style.titleColor, for: .normal)
    }
}
