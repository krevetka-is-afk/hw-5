//
//  ShimmerView.swift
//  serastvorovPW5
//
//  Created by Сергей Растворов on 11/3/25.
//

import UIKit

class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer() // градиентный слой
    private let animation = CABasicAnimation(keyPath: "transform.translation.x") // анимация перемещения
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShimmerEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmerEffect()
    }
    
    private func setupShimmerEffect() {
        // Устанавливаем цвет фона для view
        backgroundColor = .systemGray6
        
        // Настраиваем градиент
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.withAlphaComponent(0.5).cgColor,
            UIColor.clear.cgColor
        ]
        
        // Настраиваем позиции градиента для более плавного эффекта
        gradientLayer.locations = [0, 0.2, 0.5, 0.8, 1]
        
        // Настраиваем направление градиента
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Добавляем градиентный слой
        layer.addSublayer(gradientLayer)
        
        // Настраиваем анимацию
        animation.duration = 1.5
        animation.fromValue = -frame.width
        animation.toValue = frame.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Обновляем размеры градиентного слоя при изменении размеров view
        gradientLayer.frame = bounds
    }
    
    func startShimmering() {
        // Убеждаемся, что view видима и полностью непрозрачна
        isHidden = false
        alpha = 1
        // Запускаем анимацию
        gradientLayer.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering() {
        gradientLayer.removeAnimation(forKey: "shimmer")
    }
} 
