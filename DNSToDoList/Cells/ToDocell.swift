import UIKit


final class ToDoCell: UITableViewCell {
    
    private enum SizeConstants {
        static let descriptionLabelSize: CGFloat = 20
        static let todoStatusLabelSize: CGFloat = 14
        static let dateToDoLabelSize: CGFloat = 12
        static let todoStatusLabelNumberOfLines = 2
        static let toDoWasCreatedLabelNumberOfLines = 1
        static let spacingVStack: CGFloat = 4
        static let vStackTopAnchor: CGFloat = 12
        static let vStackLeadingAnchor: CGFloat = 8
    }
    
    // TODO: Проверить все отступы и размеры шрифтов
    @Autolayout private var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: SizeConstants.descriptionLabelSize)
        $0.textAlignment = .left
        $0.textColor = .black
        return $0
    }(UILabel())
    
    @Autolayout private var todoStatusLabel: UILabel = {
        $0.numberOfLines = SizeConstants.todoStatusLabelNumberOfLines
        $0.font = UIFont.systemFont(ofSize: SizeConstants.todoStatusLabelSize)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    @Autolayout private var dateAndTimeTheToDoWasCreatedLabel: UILabel = {
        $0.numberOfLines = SizeConstants.toDoWasCreatedLabelNumberOfLines
        $0.font = UIFont.systemFont(ofSize: SizeConstants.dateToDoLabelSize)
        $0.textAlignment = .left
        $0.textColor = .black
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    private func setConstraints() {
        let vStack = UIStackView(views: [descriptionLabel,
                                         todoStatusLabel,
                                         dateAndTimeTheToDoWasCreatedLabel],
                                 axis: .vertical,
                                 spacing: SizeConstants.spacingVStack,
                                 alignment: .leading)
        addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                        constant: SizeConstants.vStackTopAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: SizeConstants.vStackLeadingAnchor)
        ])
    }
    
    func configureCell(toDoTitle: String, toDoStatus: String, date: Date) {
        descriptionLabel.text = toDoTitle
        todoStatusLabel.text = toDoStatus
        switch toDoStatus {
        case "Новая задача":
            todoStatusLabel.textColor = .systemGreen
        case "В работе":
            todoStatusLabel.textColor = .systemPurple
        default:
            todoStatusLabel.textColor = .systemGray
        }
        
        dateAndTimeTheToDoWasCreatedLabel.text = date.toString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI

struct ToDoCellProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().background(.white).edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = ToDoCell
        let view = ToDoCell()
        func makeUIView(context: Context) -> ToDoCell {
            return view
        }
        func updateUIView(_ uiView: ToDoCell, context: Context) { }
    }
}
