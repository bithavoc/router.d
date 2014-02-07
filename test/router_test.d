import webcaret.router;
import std.stdio : writeln;
import std.regex : match;

class MyRequest : IRoutedRequest {
    private:
        string[string] _params;

    public:

    @property string[string] params() {
        return _params;
    }
    @property void params(string[string] params) {
        _params = params;
    }
}

class MyResponse {

}

unittest {
    {
        // root hit
        auto router = new Router!(MyRequest, MyResponse);
        auto originalRequest = new MyRequest;
        auto originalResponse = new MyResponse;
        MyRequest routedRequest = null;
        MyResponse routedResponse = null;
        router.map("GET", "/") ^ (req, res) {
            routedRequest = req;
            routedResponse = res;
        };
        router.execute("GET", "/", originalRequest, originalResponse);
        assert(originalRequest == routedRequest, "The routed request is not the same the original request");
        assert(originalResponse == routedResponse, "The routed response is not the same the original response");
    }

    {
        auto route = new Route!(MyRequest, MyResponse)("/project/:project_id/tasks/:id");

        assert(route.routeParams[0] == "project_id");
        assert(route.routeParams[1] == "id");

        auto m = match("/project/1/tasks/2", route.compiledPath);
        assert(m.captures[1] == "1");
        assert(m.captures[2] == "2");
    }

    {
        auto router = new Router!(MyRequest, MyResponse);
        auto originalReq = new MyRequest;
        auto originalRes = new MyResponse;

        router.map("GET", "/project/:project_id/tasks/:id") ^ (req, res) {
          assert(req.params["project_id"] == "1");
          assert(req.params["id"] == "2");
        };
        router.execute("GET", "/project/1/tasks/2", originalReq, originalRes);
    }
    {
        auto router = new Router!(MyRequest, MyResponse);
        auto originalReq = new MyRequest;
        auto originalRes = new MyResponse;

        router.get("/project/:project_id/tasks/:id") ^ (req, res) {
          assert(req.params["project_id"] == "1");
          assert(req.params["id"] == "2");
        };
        router.execute("GET", "/project/1/tasks/2", originalReq, originalRes);
    }
}
