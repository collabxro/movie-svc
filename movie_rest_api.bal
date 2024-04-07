import ballerina/http;

service /app on new http:Listener(9000) {
    resource function post movies(@http:Payload Movie[] movies)returns error? {
        foreach Movie movie in movies {
            error? ret = addMovie(movie);
            if ret is error {
               return ret;
            }  
        }
    }

    resource function get movies() returns Movie[]|error {
        return getTenRandomMovies();
    }
}