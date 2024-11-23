import Combine

protocol ToDoRepositoryProtocol {
    func getToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDos(_ todos: [ToDo])
    func deleteToDo(withId id: Int)
    func updateTodo(_ todo: ToDo)
}
