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
                self?.todos.removeAll()
                self?.todos = todos
            }
            .store(in: &cancellables)
    }
    
    func errorBinding() {
        $errorMessage
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                if errorMessage != nil {
                    print("Error: \(String(describing: errorMessage))")
                }
            }
            .store(in: &cancellables)
    }
    
    func saveToDo() {
        guard let item = todos.last else { return }
        toDoRepository.saveToDo(item)
    }
    
    func deleteToDo(withId id: Int) {
        toDoRepository.deleteToDo(withId: id)
    }
    
    func updateToDo(_ todo: ToDo) {
        toDoRepository.updateTodo(todo)
    }
}
