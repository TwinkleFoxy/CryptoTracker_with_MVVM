//
//  DetailCoinView.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 05.07.2022.
//

import UIKit

class DetailCoinView: UIView {
    
    private lazy var faceCardView: FaceCardView = {
        let view = FaceCardView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backOfCardView: BackOfCardView = {
        let view = BackOfCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    private let flipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clouseButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    //MARK: - DetailCoinView
    var viewModel: DetailCoinViewViewModelProtocol!
    
    //MARK: - Previous tableView controller
    unowned var previousTableViewController: BackGroundBlurEffectProtocol?
    
    private let buttonSize = 44.0
    private let indent = 10.0
    private var isFliped = false
    
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
         backOfCardView.viewModel = viewModel
         setupUI()
         setupSubView()
         setupActionForButton()
         setupConstraints()
     }
    
    //MARK: - SetupUI
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        backOfCardView.viewModel = viewModel
        faceCardView.viewModel = viewModel
        faceCardView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.width)
        backOfCardView.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.width)
        favoriteButton.frame = CGRect(x: frame.width - buttonSize - indent, y: indent, width: buttonSize, height: buttonSize)
        clouseButton.frame = CGRect(x: (frame.width / 2) - 10, y: frame.height, width: buttonSize, height: buttonSize)
        setFavoritStatus(isFavorit: viewModel.isFavorit)
        viewModel.viewModelDidChange = { [unowned self] viewModel in
            self.setFavoritStatus(isFavorit: viewModel.isFavorit)
        }
    }
    
    //MARK: - Setup SubView
    private func setupSubView() {
        addSubview(backOfCardView)
        addSubview(faceCardView)
        addSubview(flipButton)
        addSubview(favoriteButton)
        addSubview(clouseButton)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            faceCardView.topAnchor.constraint(equalTo: topAnchor),
            faceCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            faceCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            faceCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonSize)
        ])
        
        NSLayoutConstraint.activate([
            backOfCardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backOfCardView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            backOfCardView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backOfCardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -buttonSize)
        ])
        
        NSLayoutConstraint.activate([
            flipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            flipButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            flipButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            flipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            clouseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            clouseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -indent)
        ])
        
    }
    
    //MARK: - Setup Action for button
    private func setupActionForButton() {
        favoriteButton.addTarget(self, action: #selector(favoritButtonPressed), for: .touchDown)
        flipButton.addTarget(self, action: #selector(flipView), for: .touchDown)
        clouseButton.addTarget(self, action: #selector(clouseView), for: .touchDown)
    }
    
    @objc private func favoritButtonPressed() {
        viewModel.favoritToggle()
    }
    
    @objc private func flipView() {
        isFliped = !isFliped
        
        let fromView = isFliped ? backOfCardView : faceCardView
        let toView = isFliped ? faceCardView : backOfCardView
                
        UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews])
    }
    
    @objc private func clouseView() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [unowned self] in
            transform = CGAffineTransform(translationX: -400, y: frame.minY)
            previousTableViewController?.removeBackGroundBlurEffectAndUpdateDataIfNeed()
        } completion: { _ in
            DispatchQueue.main.async { [unowned self] in
                viewModel = nil
                removeFromSuperview()
                transform = .identity
            }
        }
    }
    
    private func setFavoritStatus(isFavorit: Bool) {
        let imageButton = viewModel.isFavorit ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteButton.setImage(imageButton, for: .normal)
    }
}
