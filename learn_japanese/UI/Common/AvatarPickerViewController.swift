import UIKit

protocol AvatarPickerDelegate: AnyObject {
    func didSelectAvatar(_ avatarName: String)
}

class AvatarPickerViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AvatarPickerDelegate?
    
    private let avatars = [
        "avatar_1", "avatar_2", "avatar_3", "avatar_4", "avatar_5",
        "avatar_6", "avatar_7", "avatar_8", "avatar_9"
    ]
    
    private var selectedAvatar: String?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(AvatarCell.self, forCellWithReuseIdentifier: AvatarCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    convenience init(delegate: AvatarPickerDelegate? = nil, selectedAvatar: String) {
        self.init()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.delegate = delegate
        self.selectedAvatar = selectedAvatar
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension AvatarPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.identifier, for: indexPath) as! AvatarCell
        cell.setAvatar(UIImage(named: avatars[indexPath.row]), avatars[indexPath.row] == selectedAvatar)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedAvatar = avatars[indexPath.row]
        collectionView.reloadData()
        delegate?.didSelectAvatar(avatars[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - AvatarCell
class AvatarCell: UICollectionViewCell {
    static let identifier = "AvatarCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        return imageView
    }()
        
    func setAvatar(_ avatar: UIImage?, _ isSelected: Bool) {
        avatarImageView.image = avatar
        checkmarkImageView.isHidden = !isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(checkmarkImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            checkmarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            checkmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            checkmarkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        ])
        contentView.bringSubviewToFront(checkmarkImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
