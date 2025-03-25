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
                furiganaWords = matchingModel.furigana
                maxSelectableItems = matchingModel.furigana.count
                questionText = matchingModel.questionText
                translation = matchingModel.translation
                audioUrl = matchingModel.audio
            }
            updateUI()
        }
    }
    
    private var furiganaWords: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var maxSelectableItems: Int = 0
    private var questionText: String = ""
    private var translation: String = ""
    private var audioUrl: String = ""
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.register(WordCell.self, forCellWithReuseIdentifier: "WordCell")
        return collectionView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.1
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let latinhCharactersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let audioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationText.confirm, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = AppColors.buttonEnable
        button.setTitleColor(.gray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Thêm shadow effect
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Nhấn và giữ các nút để sắp xếp câu trả lời"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onConfirmTapped: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(collectionView)
        addSubview(imageView)
        addSubview(questionLabel)
        addSubview(translationLabel)
        addSubview(latinhCharactersLabel)
        addSubview(audioButton)
        addSubview(confirmButton)
        addSubview(instructionLabel)
        
        let selectedLayout = UICollectionViewFlowLayout()
        selectedLayout.scrollDirection = .vertical
        selectedLayout.minimumLineSpacing = 30
        selectedLayout.minimumInteritemSpacing = 30
        selectedLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        NSLayoutConstraint.activate([
            // Câu hỏi ở đầu tiên
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            // Hình ảnh
            imageView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Nút âm thanh ở góc phải trên của image
            audioButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            audioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            audioButton.widthAnchor.constraint(equalToConstant: 50),
            audioButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Bản dịch ngay dưới image
            translationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            translationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            translationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            translationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            // Chữ Latin dưới bản dịch
            latinhCharactersLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 16),
            latinhCharactersLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Hướng dẫn ngay dưới chữ Latin
            instructionLabel.topAnchor.constraint(equalTo: latinhCharactersLabel.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            instructionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            // Collection view có thể chọn
            collectionView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -16),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            // Nút xác nhận ở dưới cùng
            confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            confirmButton.topAnchor.constraint(greaterThanOrEqualTo: collectionView.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }
    
    private func updateUI() {
        imageView.image = UIImage(named: matchingModel?.image ?? "")
        questionLabel.text = questionText
        translationLabel.text = translation
        
        if let latinArray = matchingModel?.latin {
            latinhCharactersLabel.text = latinArray.joined(separator: " ")
        } else {
            latinhCharactersLabel.text = ""
        }
        collectionView.reloadData()
    }
    
    @objc private func audioButtonTapped() {
        AudioUtils.shared.playSound(filename: audioUrl)
    }
    
    @objc private func confirmButtonTapped() {
        onConfirmTapped?(matchingModel?.correctAnswer == furiganaWords.joined())
    }
    
    private func performBatchUpdates(updates: () -> Void) {
        collectionView.performBatchUpdates(updates)
    }
}

extension WordSortView: UICollectionViewDelegate,
                        UICollectionViewDataSource,
                        UICollectionViewDelegateFlowLayout,
                        UICollectionViewDragDelegate,
                        UICollectionViewDropDelegate{
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return furiganaWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell", for: indexPath) as? WordCell {
            cell.label.text = furiganaWords[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDragDelegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let word = furiganaWords[indexPath.item]
        let itemProvider = NSItemProvider(object: word as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = word
        return [dragItem]
    }
    
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath,
                  let word = dropItem.dragItem.localObject as? String else { return }
            
            // Xóa từ ở vị trí cũ
            furiganaWords.remove(at: sourceIndexPath.item)
            // Chèn từ vào vị trí mới
            furiganaWords.insert(word, at: destinationIndexPath.item)
            
            // Cập nhật collection view
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .cancel)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        previewParameters.backgroundColor = .white
        return previewParameters
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
