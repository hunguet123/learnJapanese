//
//  TabBarView.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 17/7/24.
//

import UIKit

protocol DefaultTabBarViewDelegate: AnyObject {
    func tabBar(_ tabBar: DefaultTabBarView, didSelectItemAt index: Int)
}

class DefaultTabBarView: UIView {
    weak var delegate: DefaultTabBarViewDelegate?
    
    private var buttons: [DefaultButton] = []
    private var stackView: UIStackView!
    
    var items: [String] = [] {
        didSet {
            setupTabs()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        self.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupTabs() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        for (index, title) in items.enumerated() {
            let button = DefaultButton()
            button.setTitle(title, for: .normal)
            button.setBackgroundColor(AppColors.lightSliver ?? .red, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        selectTab(at: 0)
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        selectTab(at: sender.tag)
        delegate?.tabBar(self, didSelectItemAt: sender.tag)
    }
    
    func selectTab(at index: Int) {
        guard index < buttons.count else { return }
        buttons.forEach { button in
            button.setBackgroundColor(AppColors.lightSliver ?? .clear, for: .normal)
            button.setTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                      .foregroundColor: AppColors.lavenderIndigo?.withAlphaComponent(0.6) ?? .clear,
            ], for: .normal)
        }// Unselected color
        buttons[index].setBackgroundColor(AppColors.lavenderIndigo ?? .clear, for: .selected)
        buttons[index].setTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                          .foregroundColor: AppColors.white,
        ], for: .normal)
    }
}
