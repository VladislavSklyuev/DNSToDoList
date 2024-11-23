import Combine
import Foundation

final class ToDosViewModel {
    @Published var todos: [ToDo] = []
    @Published var errorMessage: String?
    
    private let toDoRepository: ToDoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
        fetchToDos()
        saveToDos()
        errorBinding()
    }
    
    private func fetchToDos() {
        toDoRepository
            .getToDos()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                default: break
                }
            } receiveValue: { [weak self] todos in
                todos.forEach { todo in
                    print(todo.id)
                }
                self?.todos.removeAll()
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Надо ли?
    func errorBinding() {
        $errorMessage
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                if errorMessage != nil {
                    print("Error: (message)")
                }
            }
            .store(in: &cancellables)
    }
    
    func saveToDos() {
        toDoRepository.saveToDos(todos)
    }
    
    func deleteToDo(withId id: Int) {
        toDoRepository.deleteToDo(withId: id)
    }
    
    func updateToDo(_ todo: ToDo) {
        toDoRepository.updateTodo(todo)
    }
}
