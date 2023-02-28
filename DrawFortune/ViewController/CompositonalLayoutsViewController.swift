import UIKit


// ダミーデータ
fileprivate var dummyData = ["1", "2", "3", "4", "5", "6", "7"]


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
        switch gravity {
        case .left:
            itemList = dummyData
        
        case .right:
            // 適切な並び順になったダミーデータを注入
            itemList = optimizeDummyDataArray(dummyData)
        }
    }
    
    // ダミーデータを適切な並び順にする（5つ毎にスライスして逆順にし、結合する）
    private func optimizeDummyDataArray(_ dummyData: [String]) -> [String] {
        var newArray = dummyData
        let splittedReverseArray1 = newArray.safeRange(range: 0..<5).reversed().map { $0 }
        let splittedReverseArray2 = newArray.safeRange(range: 5..<10).reversed().map { $0 }
        let splittedReverseArray3 = newArray.safeRange(range: 10..<15).reversed().map { $0 }
        let splittedReverseArray4 = newArray.safeRange(range: 15..<20).reversed().map { $0 }
        
        newArray = splittedReverseArray1 + splittedReverseArray2 + splittedReverseArray3 + splittedReverseArray4
        return newArray
    }
    
    // ダミーデータを追加
    @objc private func addDummyData(_ sender: UIButton) {
        dummyData.append(String(itemList.count + 1))
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

// 範囲外が指定されても、取れる限りの要素を取得
extension Array {
    func safeRange(range: Range<Int>) -> ArraySlice<Element> {
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
            CollectionViewPreviewWrapper(itemList: dummyData)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
