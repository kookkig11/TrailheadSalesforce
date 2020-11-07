global class ProjectCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
    global HTTPResponse respond(HTTPRequest req) {
      
      //   String inputJSON = '{\n' +
      //                      ' "opportunityId": "00641000004EKmFAAW",\n'+
      //                      ' "opportunityName": "Super-Duper Big Deal",\n'+
      //                      ' "accountName": "ACME Corp, Inc.",\n'+
      //                      ' "closeDate": "2016-10-30",\n'+
      //                      ' "amount": 150000' +
      //                      '\n}';

      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      // res.setBody(inputJSON);
      res.setStatus('Success');
      res.setStatusCode(201);
      return res; 
    }
}