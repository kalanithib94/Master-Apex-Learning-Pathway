/**
 * Reusable HttpCalloutMock for tests of OutboundCalloutFuture and any other
 * callout-making class in the project.
 */
@IsTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String safeBody = (req.getBody() == null) ? '' : req.getBody().replace('"', '\\"');
        res.setBody('{"args":{},"data":"' + safeBody + '","origin":"127.0.0.1","url":"' + req.getEndpoint() + '"}');
        res.setStatusCode(200);
        return res;
    }
}
