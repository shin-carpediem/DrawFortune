import UIKit

final class CompositonalLayoutsViewController: UIViewController {
    /// コレクションビューの各セルに追加されるデータ
    var itemList: [String] {
        get { collectionView.itemList }
        set { collectionView.itemList = newValue }
    }
    
    /// 要素の並ぶ順番
    var gravity: CollectionView.Gravity {
        get { collectionView.gravity }
        set { collectionView.gravity = newValue }
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
    
    private let collectionView = CollectionView()
    
    private lazy var addDataButton: UIButton = {
        let view = UIButton()
        view.setTitle("Add One Data", for: .normal)
        view.backgroundColor = .cyan
        view.addTarget(self, action: #selector(addDummyData(_:)), for: .touchUpInside)
        return view
    }()
    
    private func construct() {
        // TODO: 一旦ここで順番を変えてる
        gravity = .right
        
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
        optimizeDummyDataArraySortOrder()
    }
    
    // ダミーデータ
    private var dummyData = ["1", "2", "3"]
    
    // ダミーデータを適切な並び順にする（5つ毎にスライスして逆順にし、結合する & 右下に異なるタイプのデータを追加）
    private func optimizeDummyDataArraySortOrder() {
        var newArray = dummyData
        switch gravity {
        case .left:
            newArray.append("Different")
            itemList = newArray
            
        case .right:
            // TODO: やばい
            let splittedReverseArray1 = newArray.safeRange(0..<5).reversed().map { $0 }
            let splittedReverseArray2 = newArray.safeRange(5..<10).reversed().map { $0 }
            let splittedReverseArray3 = newArray.safeRange(10..<15).reversed().map { $0 }
            if newArray.count <= 4 {
                // セルが1行目に収まる(1~5個)時
                itemList = ["Different"] + splittedReverseArray1 + splittedReverseArray2
            } else if newArray.count <= 9 {
                // セルが2行(6~10個)の時
                itemList = splittedReverseArray1 + ["Different"] + splittedReverseArray2
            } else if newArray.count == 10 {
                // セルが11個の時
                itemList = splittedReverseArray1 + splittedReverseArray2 + ["Different"] + splittedReverseArray3
            }
        }
    }
    
    // ダミーデータを追加
    @objc private func addDummyData(_ sender: UIButton) {
        dummyData.append(String(itemList.count))
        updateDisplay()
    }
}

final class CollectionView: UICollectionView {
    /// コレクションビューの各セルに追加されるデータ
    var itemList: [String] = [] {
        didSet { updateDisplay() }
    }
    
    /// 要素の並ぶ順番
    enum Gravity {
        /// 左から順に
        case left
        /// 右から順に
        case right
    }
    
    var gravity: Gravity = .left {
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
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
        switch gravity {
        case .left:
            transform = CGAffineTransform(scaleX: 1, y: 1)
            
        case .right:
            // コレクションビュー自体を左右に反転
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
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
        cell.isDifferentCell = itemList[indexPath.item] == "Different"
        switch gravity {
        case .left:
            cell.transform  = CGAffineTransform(scaleX: 1, y: 1)
            
        case .right:
            // セル自体を左右に反転
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        return cell
    }
}

/// カスタムセル
final class CollectionCell: UICollectionViewCell {
    static let identifier = "collectionCell"
    
    var labelText: String = "" {
        didSet { updateDisplay() }
    }
    
    /// 通常とは違うセルか
    var isDifferentCell: Bool = false {
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
        isDifferentCell = false
    }
    
    // MARK: - Private
    
    private let label: UILabel = {
        let view = UILabel()
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
        if isDifferentCell {
            label.textColor = .blue
            label.backgroundColor = .systemPink
        } else {
            label.textColor = .black
            label.backgroundColor = .brown
        }
    }
}

extension Array {
    // 範囲外が指定されても、取れる限りの要素を取得
    func safeRange(_ range: Range<Int>) -> ArraySlice<Element> {
        return self.dropFirst(range.startIndex).prefix(range.endIndex)
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
            CollectionViewPreviewWrapper(itemList: ["1", "2", "3"])
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
