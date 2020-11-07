global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
   //Implement http mock callout here
   global HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setStatus('Failure');
      res.setStatusCode(500);
      return res; 
   }
}