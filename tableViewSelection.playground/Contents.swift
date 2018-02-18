import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    private var model = (1...5).map { ([String](repeating: "multiline test", count: $0).joined(separator: "\n"), false)}
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutAttribute] = [.top, .bottom, .leading, .trailing]
        NSLayoutConstraint.activate(attributes.map { NSLayoutConstraint(item: tableView, attribute: $0, relatedBy: .equal, toItem: self.view, attribute: $0, multiplier: 1, constant: 0) })
        tableView.register(TableViewCell.self, forCellReuseIdentifier: String(describing: TableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        view.setNeedsLayout()
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self), for: indexPath) as! TableViewCell
        cell.model = model[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (text, isChecked) = model[indexPath.row]
        model[indexPath.row] = (text, !isChecked)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class TableViewCell: UITableViewCell {
    var model: (String, Bool)! {
        didSet {
            stackView.isHidden = false
            let (text, isChecked) = model
            label.text = text
            checkBox.image = isChecked ? TableViewCell.filledCheckmarkImage : TableViewCell.emptyCheckmarkImage
        }
    }
    static var emptyCheckmarkImage: UIImage = {
        return  UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { context in
            UIColor.darkGray.setStroke()
            context.stroke(context.format.bounds)
        }
    }()
    static var filledCheckmarkImage: UIImage = {
        return  UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { context in
            UIColor.darkGray.setStroke()
            UIColor.lightGray.setStroke()
            context.fill(context.format.bounds.insetBy(dx: 10, dy: 10))
            context.stroke(context.format.bounds)

        }
    }()
    private var label = UILabel()
    private var checkBox = UIImageView(image: TableViewCell.filledCheckmarkImage)
    private lazy var stackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.setContentHuggingPriority(UILayoutPriority(800), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(checkBox)
        self.contentView.addSubview(stackView)
        let attributes: [(NSLayoutAttribute, CGFloat)] = [(.top, 15), (.bottom, -15), (.leading, 15), (.trailing, -15)]
        NSLayoutConstraint.activate(attributes.map { NSLayoutConstraint(item: stackView, attribute: $0.0, relatedBy: .equal, toItem: self.contentView, attribute: $0.0, multiplier: 1, constant: $0.1) })
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        return stackView
    }()
}

PlaygroundPage.current.liveView = ViewController()
