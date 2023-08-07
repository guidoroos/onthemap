//
//  TextStyle.swift
//  OnTheMap
//
//  Created by Guido Roos on 03/08/2023.
//

import UIKit

struct TextStyle {
    let font: UIFont
    let color: UIColor

    var attributes: [NSAttributedString.Key: Any] {
        return [
            .font: font,
            .foregroundColor: color
        ]
    }
}

struct TextStyles {
    static func normal(color: UIColor) -> TextStyle {
        return TextStyle(font: .systemFont(ofSize: 16, weight: .regular), color: color)
    }

    static func header(color: UIColor) -> TextStyle {
        return TextStyle(font: .systemFont(ofSize: 24, weight: .semibold), color: color)
    }
    
    static func headerBold(color: UIColor) -> TextStyle {
        return TextStyle(font: .systemFont(ofSize: 24, weight: .bold), color: color)
    }

    static func subheader(color: UIColor) -> TextStyle {
        return TextStyle(font: .systemFont(ofSize: 20, weight: .semibold), color: color)
    }

    static func caption(color: UIColor) -> TextStyle {
        return TextStyle(font: .systemFont(ofSize: 12, weight: .regular), color: color)
    }
}
