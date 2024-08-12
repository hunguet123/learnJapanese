import UIKit

class SelectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectableItems: [String] = ["Item ", "Item ", "Item ", "Item ", "Item ", "Item ", "Item ", "Item 4",]
    var selectedItems: [String] = []
    let maxSelectableItems = 3
    
    var selectableCollectionView: UICollectionView!
    var selectedCollectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        // Setup layout for selectable items collection view
        let selectableLayout = UICollectionViewFlowLayout()
        selectableLayout.scrollDirection = .vertical
        selectableLayout.minimumLineSpacing = 30
        selectableLayout.minimumInteritemSpacing = 30
        selectableLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Căn chỉnh về start
        
        // Setup selectable items collection view
        selectableCollectionView = UICollectionView(frame: .zero, collectionViewLayout: selectableLayout)
        selectableCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectableCollectionView.delegate = self
        selectableCollectionView.dataSource = self
        selectableCollectionView.backgroundColor = .clear
        selectableCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(selectableCollectionView)
        
        NSLayoutConstraint.activate([
            selectableCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            selectableCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            selectableCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            selectableCollectionView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10)
        ])
        
        // Setup layout for selected items collection view
        let selectedLayout = UICollectionViewFlowLayout()
        selectedLayout.scrollDirection = .vertical
        selectedLayout.minimumLineSpacing = 30
        selectedLayout.minimumInteritemSpacing = 30
        selectedLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0) // Căn chỉnh về start
        
        // Setup selected items collection view
        selectedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: selectedLayout)
        selectedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.backgroundColor = .clear
        selectedCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(selectedCollectionView)
        
        NSLayoutConstraint.activate([
            selectedCollectionView.topAnchor.constraint(equalTo: selectableCollectionView.bottomAnchor, constant: 20),
            selectedCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            selectedCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            selectedCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == selectableCollectionView ? selectableItems.count : selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = collectionView == selectableCollectionView ? selectableItems[indexPath.row] : selectedItems[indexPath.row]
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
            let selectedItem = selectableItems.remove(at: indexPath.row)
            selectedItems.append(selectedItem)
            
            let indexPathToInsert = IndexPath(item: selectedItems.count - 1, section: 0)
            
            if let cell = collectionView.cellForItem(at: indexPath) {
                let startFrame = collectionView.convert(cell.frame, to: self)
                let endFrame = CGRect(x: selectedCollectionView.frame.minX + 20, y: selectedCollectionView.frame.minY + 20, width: cell.frame.width, height: cell.frame.height)
                
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
            selectableItems.append(deselectedItem)
            
            let indexPathToInsert = IndexPath(item: selectableItems.count - 1, section: 0)
            
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
        let text = collectionView == selectableCollectionView ? selectableItems[indexPath.row] : selectedItems[indexPath.row]
        
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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Điều chỉnh theo nhu cầu của bạn
    }
}
