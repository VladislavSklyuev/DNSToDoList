import Combine
import Foundation

class ToDosViewModel {
    @Published var todos: [ToDo] = [.mock]
    @Published var errorMessage: String?
    
    private let toDoRepository: ToDoRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
        fetchToDos()
        saveToDos()
    }
    
    func fetchToDos() {
        toDoRepository
            .getToDos()
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
    
    func saveToDos() {
        $todos
            .receive(on: DispatchQueue.global())
            .sink { [weak self] todos in
                self?.toDoRepository.saveToDos(todos)
            }
            .store(in: &cancellables)

    }
}
