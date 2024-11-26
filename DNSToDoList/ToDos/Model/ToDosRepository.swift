import Combine

class ToDosRepository: ToDoRepositoryProtocol {
    
    private let toDoService: ToDoServiceProtocol
    
    init(todoService: ToDoServiceProtocol) {
        self.toDoService = todoService
    }
    
    func getToDos() -> AnyPublisher<[ToDo], Error> {
        return toDoService.fetchToDos()
    }
    
    func saveToDo(_ todo: ToDo) {
        toDoService.saveToDo(todo)
    }
    
    func deleteToDo(withId id: Int) {
        toDoService.deleteToDo(withId: id)
    }
    
    func updateTodo(_ todo: ToDo) {
        toDoService.updateTodo(todo)
    }
}
