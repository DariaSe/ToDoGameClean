//
//  e_UIView.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import UIKit

extension UIView {
    
    func pinToEdges(subview: UIView, leading: CGFloat? = 0, trailing: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        if let leading = leading {
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = trailing {
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailing).isActive = true
        }
        if let top = top {
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    func pinToLayoutMargins(subview: UIView, leading: CGFloat? = 0, trailing: CGFloat? = 0, top: CGFloat? = 0, bottom: CGFloat? = 0) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        if let leading = leading {
            subview.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = trailing {
            subview.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -trailing).isActive = true
        }
        if let top = top {
            subview.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    
    func center(subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func setDimensions(width: CGFloat? = nil, height: CGFloat? = nil) {
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setWidth(equalTo view: UIView, multiplier: CGFloat = 1) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }
    
    func setHeight(equalTo view: UIView, multiplier: CGFloat = 1) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
}

extension UIView {
    
    var snapshot: UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView {
    func maskRoundedCorners(cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: cornerRadius).cgPath
        self.layer.mask = maskLayer
    }
    
    func maskRoundedCorners(corners: UIRectCorner, cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        self.layer.mask = maskLayer
    }
    
    func dropShadow(color: UIColor = UIColor.black, height: CGFloat = 3, shadowRadius: CGFloat = 6, opacity: Float = 0.25, cornerRadius: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = shadowRadius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}

extension UIView {
    func animateScale(duration: Double, scale: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0.07, options: [.curveEaseInOut]) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { (_) in
            self.transform = CGAffineTransform.identity
        }
    }
}

