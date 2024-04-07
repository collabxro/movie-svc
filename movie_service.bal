// import ballerina/io;
import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

public type Movie record {|
    string id?;
    string title;
    int year;
    string genere;
    string director;
    string actors;
|};

final mysql:Client dbClient = check new(host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE);

isolated function addMovie(Movie movie) returns error? {
    sql:ParameterizedQuery query = `INSERT INTO movies (title, year, genere, director, actors)
                                  VALUES (${movie.title}, ${movie.year}, ${movie.genere}, ${movie.director}, ${movie.actors})`;
    sql:ExecutionResult|error result = check dbClient->execute(query);
    if result is error {
        return result;
    }
}

isolated function getTenRandomMovies() returns Movie[]|error {
    Movie[] movies = [];
    stream<Movie, error?> resultStream = dbClient->query(
        `SELECT * FROM movies ORDER BY RAND() LIMIT 10`
    );
    check from Movie movie in resultStream
        do {
            movies.push(movie);
        };
    check resultStream.close();
    return movies;
}
