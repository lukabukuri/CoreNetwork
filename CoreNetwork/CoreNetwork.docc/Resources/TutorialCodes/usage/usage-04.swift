import Foundation

final class MovieListServiceWorker {
    
    private let url = "developers.themoviedb.org"
    private let path = "3/movies/get-movie-lists"
    
    func fetchMovies(genre: String?) async throws -> [Movie] {
        return try await Network.request(url: url,
                                         path: path,
                                         query: ["genre" : genre],
                                         type: [Movie].self)
    }
    
}
