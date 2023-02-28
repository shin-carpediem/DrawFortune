import UIKit


// ダミーデータ
fileprivate var dummyData = ["1", "2", "3", "4", "5"]


final class CompositonalLayoutsViewController: UIViewController {
    var count: Int = dummyData.count
    
    /// コレクションビューの各セルに追加されるデータ
    var itemList: [String] {
        get { collectionView.itemList }
        set { collectionView.itemList = newValue }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        construct()
    }
    
    // MARK: - Private
    
    private let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    private let collectionView: CollectionView = {
        let view = CollectionView()
        // コレクションビュー自体を左右に反転
        view.transform = CGAffineTransform(scaleX: -1, y: 1)
        return view
    }()
    
    private lazy var addDataButton: UIButton = {
        let view = UIButton()
        view.setTitle("Add One Data", for: .normal)
        view.backgroundColor = .cyan
        view.addTarget(self, action: #selector(addDummyData(_:)), for: .touchUpInside)
        return view
    }()
    
    private func construct() {
        view.backgroundColor = .white
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        vStack.addArrangedSubview(collectionView)
        vStack.addArrangedSubview(addDataButton)
        
        updateDisplay()
    }
    
    private func updateDisplay() {
        // ダミーデータを注入
        itemList = dummyData
    }
    
    // ダミーデータを追加
    @objc private func addDummyData(_ sender: UIButton) {
        count += 1
        dummyData.append(String(count))
        updateDisplay()
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
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
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
