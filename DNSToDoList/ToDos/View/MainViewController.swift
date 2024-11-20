import UIKit

// TODO: - Таблицу отдельным файлом
final class MainViewController: UIViewController {
    
    private var toDos = ToDo.mock
    
    // TODO: - строковые литералы в константы
    private enum Constants {
        static let heightForRowAt: CGFloat = 80
    }
    
    @Autolayout private var titleLabel: UILabel = {
        $0.text = "Задачи"
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.textAlignment = .left
        $0.textColor = .white
        return $0
    }(UILabel())
    
    @Autolayout private var test: UIButton = {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        return $0
    }(UIButton())
    
    // TODO: - Добавить картинку "микрофона" справа
    // TODO: - Определить нужен ли вообще поиск?
//    @Autolayout private var searchBar: UISearchBar = {
//        $0.barStyle = .default
//        $0.placeholder = "Search"
//        //searchBar.delegate = self
//        $0.backgroundImage = UIImage()
//        $0.isTranslucent = true
//        return $0
//    }(UISearchBar())
    
    lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
        return $0
    }(UITableView())
    
    // TODO: Убирать нави панель только так?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setConstraints()
        addActions()
    }
    
    private func setConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(test)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            
            test.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            test.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            
//            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addActions() {
        test.addTarget(self, action: #selector(addItem), for: .touchUpInside)
    }
    
    @objc func addItem() {
        // Добавляем новый элемент в массив
        let todo = ToDo(toDo: "Покататься на велике", description: "Просто сесть и поехать", status: .inWork, dateAndTimeTheToDoWasCreated: .now)
        toDos.append(todo)
        
        // Обновляем таблицу
        tableView.reloadData()
    }

    
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier, for: indexPath) as? ToDoCell else {
            return UITableViewCell()
        }
        
        cell.configure(toDoTitle: toDos[indexPath.row].toDo, toDoStatus: toDos[indexPath.row].status.rawValue, date: toDos[indexPath.row].dateAndTimeTheToDoWasCreated)
        cell.backgroundColor = .black
        return cell
    }
}


// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    // Высота ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightForRowAt
    }
    
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: -
//extension MainViewController {
//    func display(_ toDos: ToDoEntity) {
//        self.toDos = toDos.todos
//        
//        // MARK: - WTF!?
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        
//    }
//}
