import vapor;
import std.stdio : writeln;

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
}
