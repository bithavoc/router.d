import vapor;
import std.stdio : writeln;
import std.regex : match;

class MyContext {

}

unittest {
    {
        // root hit
        auto router = new Router!MyContext('/');
        auto originalContext = new MyContext;
        MyContext routedContext = null;
        router.map("GET", "/") ^ (context, string[string] params) {
            routedContext = context;
        };
        router.execute("GET", "/", originalContext);
        assert(originalContext == routedContext, "The routed context is not the same the original context");
    }

    {
        auto route = new Route!MyContext("/project/:project_id/tasks/:id");

        assert(route.routeParams[0] == ":project_id");
        assert(route.routeParams[1] == ":id");

        auto m = match("/project/1/tasks/2", route.compiledPath);
        assert(m.captures[1] == "1");
        assert(m.captures[2] == "2");
    }
}
