import UIKit

struct MatchingModel: Codable {
    let questionType: String
    let questionText: String
    let audio: String
    let image: String
    let latin: [String]
    let furigana: [String]
    let correctAnswer: String
    let translation: String
    
    static func fromJson(_ jsonString: String) -> MatchingModel? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(MatchingModel.self, from: data)
            return model
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    func toJson() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error encoding to JSON: \(error)")
            return nil
        }
    }
}

class WordSortView: UIView {
    var matchingModel: MatchingModel? {
        didSet {
            if let matchingModel = matchingModel {
                furiganaItems = matchingModel.furigana
                maxSelectableItems = matchingModel.furigana.count
                questionText = matchingModel.questionText
                translation = matchingModel.translation
                audioUrl = matchingModel.audio
            }
            updateUI()
        }
    }
    
    private var furiganaItems: [String] = []
    private var selectedItems: [String] = []
    private var maxSelectableItems: Int = 0
    private var questionText: String = ""
    private var translation: String = ""
    private var audioUrl: String = ""
    
    var selectableCollectionView: UICollectionView!
    var selectedCollectionView: UICollectionView!
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let latinCharactersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        let selectableLayout = UICollectionViewFlowLayout()
        selectableLayout.scrollDirection = .vertical
        selectableLayout.minimumLineSpacing = 30
        selectableLayout.minimumInteritemSpacing = 30
        selectableLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Setup selectableCollectionView
        selectableCollectionView = UICollectionView(frame: .zero, collectionViewLayout: selectableLayout)
        selectableCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectableCollectionView.delegate = self
        selectableCollectionView.dataSource = self
        selectableCollectionView.backgroundColor = .clear
        selectableCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(selectableCollectionView)
        addSubview(imageView)
        addSubview(questionLabel)
        addSubview(translationLabel)
        addSubview(latinCharactersLabel)
        addSubview(audioButton)
        addSubview(confirmButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        translationLabel.translatesAutoresizingMaskIntoConstraints = false
        latinCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup layout cho selectedCollectionView
        let selectedLayout = UICollectionViewFlowLayout()
        selectedLayout.scrollDirection = .vertical
        selectedLayout.minimumLineSpacing = 30
        selectedLayout.minimumInteritemSpacing = 30
        selectedLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        // Setup selectedCollectionView
        selectedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: selectedLayout)
        selectedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.backgroundColor = .clear
        selectedCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(selectedCollectionView)
        
        NSLayoutConstraint.activate([
            selectableCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            selectableCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectableCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectableCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            selectedCollectionView.topAnchor.constraint(equalTo: selectableCollectionView.bottomAnchor, constant: 16),
            selectedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            selectedCollectionView.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.topAnchor.constraint(equalTo: selectedCollectionView.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            questionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            translationLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            translationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            translationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            audioButton.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 16),
            audioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            audioButton.widthAnchor.constraint(equalToConstant: 40),
            audioButton.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: 16),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func updateUI() {
        imageView.image = UIImage(named: matchingModel?.image ?? "")
        questionLabel.text = questionText
        translationLabel.text = translation
        selectableCollectionView.reloadData()
        selectedCollectionView.reloadData()
        AudioUtils.shared.playSound(filename: audioUrl)
    }
    
    @objc private func audioButtonTapped() {
        AudioUtils.shared.playSound(filename: audioUrl)
    }
}

extension WordSortView: UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == selectableCollectionView ? furiganaItems.count : selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = collectionView == selectableCollectionView ? furiganaItems[indexPath.row] : selectedItems[indexPath.row]
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        cell.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: -10),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: 10)
        ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectableCollectionView, selectedItems.count < maxSelectableItems {
            let selectedItem = furiganaItems.remove(at: indexPath.row)
            selectedItems.append(selectedItem)
            
            let indexPathToInsert = IndexPath(item: selectedItems.count - 1, section: 0)
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                let startFrame = collectionView.convert(cell.frame, to: self)
                let endFrame = CGRect(x: selectedCollectionView.frame.minX + 20,
                                      y: selectedCollectionView.frame.minY + 20,
                                      width: cell.frame.width,
                                      height: cell.frame.height)
                
                let snapshot = cell.snapshotView(afterScreenUpdates: false)!
                snapshot.frame = startFrame
                addSubview(snapshot)
                
                UIView.animate(withDuration: 0.3, animations: {
                    snapshot.frame = endFrame
                }, completion: { _ in
                    snapshot.removeFromSuperview()
                    self.selectableCollectionView.performBatchUpdates({
                        self.selectableCollectionView.deleteItems(at: [indexPath])
                        self.selectedCollectionView.insertItems(at: [indexPathToInsert])
                    }, completion: { _ in
                        self.selectableCollectionView.collectionViewLayout.invalidateLayout()
                        self.selectedCollectionView.collectionViewLayout.invalidateLayout()
                    })
                })
            }
            
        } else if collectionView == selectedCollectionView {
            let deselectedItem = selectedItems.remove(at: indexPath.row)
            furiganaItems.append(deselectedItem)
            
            let indexPathToInsert = IndexPath(item: furiganaItems.count - 1, section: 0)
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                let startFrame = collectionView.convert(cell.frame, to: self)
                let endFrame = CGRect(x: selectableCollectionView.frame.minX + 20, y: selectableCollectionView.frame.minY + 20, width: cell.frame.width, height: cell.frame.height)
                
                let snapshot = cell.snapshotView(afterScreenUpdates: false)!
                snapshot.frame = startFrame
                addSubview(snapshot)
                
                UIView.animate(withDuration: 0.3, animations: {
                    snapshot.frame = endFrame
                }, completion: { _ in
                    snapshot.removeFromSuperview()
                    self.selectableCollectionView.performBatchUpdates({
                        self.selectableCollectionView.insertItems(at: [indexPathToInsert])
                        self.selectedCollectionView.deleteItems(at: [indexPath])
                    }, completion: { _ in
                        self.selectableCollectionView.collectionViewLayout.invalidateLayout()
                        self.selectedCollectionView.collectionViewLayout.invalidateLayout()
                    })
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = collectionView == selectableCollectionView ? furiganaItems[indexPath.row] : selectedItems[indexPath.row]
        
        // Create a label to calculate size
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = text
        label.sizeToFit()
        
        // Add padding and spacing
        let padding: CGFloat = 20
        let height: CGFloat = 44  // or use a dynamic height if needed
        
        return CGSize(width: label.frame.width + padding, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
