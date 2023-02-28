import UIKit


// ダミーデータ
fileprivate let dummyData = ["hoge", "hugo", "gege", "heee", "bufoon"]


final class CompositonalLayoutsViewController: UIViewController {
    /// コレクションビューの各セルに追加されるデータ
    var itemList: [String] {
        get { collectionView.itemList }
        set { collectionView.itemList = newValue }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        construct()
        
        // ダミーデータを注入
        itemList = dummyData
    }
    
    // MARK: - Private
    
    private let collectionView = CollectionView()
    
    private func construct() {
        view.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// プレビュー用にコレクションビューを切り出している
final class CollectionView: UICollectionView {
    /// コレクションビューの各セルに追加されるデータ
    var itemList: [String] = [] {
        didSet { updateDisplay() }
    }
    
    // MARK: - Override
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: compositionalLayout)
        
        construct()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }
    
    // MARK: - Private
    
    private let compositionalLayout: UICollectionViewLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private func construct() {
        delegate = self
        dataSource = self
        register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        
        updateDisplay()
    }
    
    private func updateDisplay() {
        reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionView: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDataSource

extension CollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        cell.labelText = itemList[indexPath.item]
        return cell
    }
}

/// カスタムセル
final class CollectionCell: UICollectionViewCell {
    static let identifier = "collectionCell"
    
    var labelText: String = "" {
        didSet { updateDisplay() }
    }
    
    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText = ""
    }
    
    // MARK: - Private
    
    private let label: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.backgroundColor = .brown
        return view
    }()
    
    private func construct() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        updateDisplay()
    }
    
    private func updateDisplay() {
        label.text = labelText
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct CollectionCellPreviewWrapper: UIViewRepresentable {
    typealias UIViewType = CollectionCell
    
    let labelText: String
    
    func makeUIView(context: Context) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.labelText = labelText
    }
}

struct CollectionViewPreviewWrapper: UIViewRepresentable {
    typealias UIViewType = CollectionView
    
    let itemList: [String]
    
    func makeUIView(context: Context) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.itemList = itemList
    }
}

struct CollectionViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer(minLength: 50)

            Text("セル")
            CollectionCellPreviewWrapper(labelText: "hoge")
            
            Spacer(minLength: 50)
            
            Text("コレクションビュー")
            CollectionViewPreviewWrapper(itemList: dummyData)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
