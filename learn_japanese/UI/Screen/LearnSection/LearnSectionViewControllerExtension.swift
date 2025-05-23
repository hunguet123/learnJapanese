//
//  LearnSectionViewControllerExtension.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 8/8/24.
//

import Foundation
import UIKit

extension LearnSectionViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return learnSectionViewModel.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageTextQuestionCollectionViewCell", for: indexPath) as? ImageTextQuestionCollectionViewCell {
            let question = learnSectionViewModel.questions[indexPath.row]
            cell.delegate = self
            cell.configure(with: question)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            return
        }
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.learningProgressView.progress = Float(currentPage + 1) / Float(learnSectionViewModel.questions.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageTextQuestionCollectionViewCell = cell as? ImageTextQuestionCollectionViewCell {
            imageTextQuestionCollectionViewCell.playAudio()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension LearnSectionViewController: ImageTextQuestionCollectionViewCellDelegate {
    func didTapNextQuestion(isCorrect: Bool, questionId: Int, correctAnswer: String) {
        let hasWrongBefore = learnSectionViewModel.wrongQuestionIds.contains(questionId)
        let hasCorrectBefore = learnSectionViewModel.correctQuestionIds.contains(questionId)
        
        if !isCorrect {
            // Nếu lần đầu trả lời sai thì thêm vào danh sách sai
            if !hasWrongBefore {
                learnSectionViewModel.wrongQuestionIds.append(questionId)
            }
            // Nếu trước đó trả lời đúng rồi thì cần xóa khỏi danh sách đúng và trừ điểm
            if hasCorrectBefore {
                if let index = learnSectionViewModel.correctQuestionIds.firstIndex(of: questionId) {
                    learnSectionViewModel.correctQuestionIds.remove(at: index)
                    learnSectionViewModel.score -= 1
                }
            }
        } else {
            // Nếu trả lời đúng lần đầu (chưa từng sai và chưa từng đúng) thì cộng điểm và thêm vào danh sách đúng
            if !hasWrongBefore && !hasCorrectBefore {
                learnSectionViewModel.score += 1
                learnSectionViewModel.correctQuestionIds.append(questionId)
            }
        }
        
        showAnswerModal(isCorrect: isCorrect, correctAnswer: correctAnswer) { [weak self] in
            self?.nextQuestion()
        }
    }
    
    func onSwipeRight(questionId: Int) {
        // TODO: thêm đã thuộc
        learnSectionViewModel.score += 1
        nextQuestion()
    }
    
    func onSwipeLeft(questionId: Int) {
        // TODO: thêm chưa thuộc
        learnSectionViewModel.wrongQuestionIds.append(questionId)
        nextQuestion()
    }
}

extension LearnSectionViewController: ConfirmDialogDelegate {
    func confirmDialogDidTapAccept(_ confirmDialog: ConfirmDialog) {
        self.navigationController?.popViewController(animated: true)
    }
}
