//
//  DrawingViewController.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 23/10/24.
//

import UIKit

class DrawingViewController: UIViewController {
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var drawableView: DrawableView!
    
    private lazy var viewModel: HandwritingViewModel = {
        let vm = HandwritingViewModel(canvas: drawableView)
        return vm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.layer.borderWidth = 1
        resultCollectionView.layer.borderColor = UIColor.blue.cgColor
        
        drawableView.delegate = self
        drawableView.backgroundColor = AppColors.white
        
        viewModel.resultUpdated = { [weak self]() in
            self?.resultCollectionView.reloadData()
        }
    }
    @IBAction func handleUndoAction(_ sender: Any) {
        drawableView.undo()
        viewModel.clear()
        
        let strokes = drawableView.strokes.map { $0 as! [NSValue] }
        if strokes.count > 0 {
            viewModel.add(strokes)
        }
    }
    @IBAction func handleClearAction(_ sender: Any) {
        drawableView.clear()
        viewModel.clear()
    }
}

//--------------------------------------------------------------------------------
//  MARK: - UICollectionView delegate
//--------------------------------------------------------------------------------

extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.resultCount()
    }
    
    func collectionView(_ view: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = view.dequeueReusableCell(withReuseIdentifier: "viewCell", for: indexPath) as! HandwritingCollectionViewCell
        cell.resultLabel.text = viewModel.result(atIndex: indexPath.item)
        return cell
    }
}

//--------------------------------------------------------------------------------
//  MARK: - DrawableView delegate
//--------------------------------------------------------------------------------

extension DrawingViewController: DrawableViewDelegate {
    
    func didDraw(stroke: [NSValue]) {
        viewModel.add(stroke)
    }
}
