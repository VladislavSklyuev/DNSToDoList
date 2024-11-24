import UIKit


final class ToDoCell: UITableViewCell {
    
    private enum SizeConstants {
        static let descriptionLabelSize: CGFloat = 20
        static let todoStatusLabelSize: CGFloat = 14
        static let dateToDoLabelSize: CGFloat = 12
    }
    
    // TODO: Проверить все отступы и размеры шрифтов
    @Autolayout private var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: SizeConstants.descriptionLabelSize)
        $0.textAlignment = .left
        $0.textColor = .black
        return $0
    }(UILabel())
    
    @Autolayout private var todoStatusLabel: UILabel = {
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: SizeConstants.todoStatusLabelSize)
        $0.textAlignment = .left
        $0.textColor = .black
        return $0
    }(UILabel())
    
    @Autolayout private var dateAndTimeTheToDoWasCreatedLabel: UILabel = {
        $0.numberOfLines = 1
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
                                 spacing: 4,
                                 alignment: .leading)
        addSubview(vStack)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        ])
    }
    
    func configureCell(toDoTitle: String, toDoStatus: String, date: Date) {
        descriptionLabel.text = toDoTitle
        todoStatusLabel.text = toDoStatus
        dateAndTimeTheToDoWasCreatedLabel.text = date.convert(date: date)
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
