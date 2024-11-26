import Combine

protocol ToDoServiceProtocol {
    func fetchToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDo(_ toDo: ToDo)
    func deleteToDo(withId id: Int)
    func updateTodo(_ todo: ToDo)
}

protocol ToDoRepositoryProtocol {
    func getToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDo(_ todo: ToDo)
    func deleteToDo(withId id: Int)
    func updateTodo(_ todo: ToDo)
}
