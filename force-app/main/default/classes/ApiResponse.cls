public with sharing class ApiResponse {
  public Integer code { get; private set; }
  public String body { get; private set; }
  public Boolean isSuccess { get; private set; }
  public String responseMsg { get; private set; }

  public ApiResponse(HttpResponse response) {
    this.code = response.getStatusCode();
    this.body = response.getBody();
    this.isSuccess = false;
    this.responseMsg = this.getResponseFromStatus(); // also sets proper value for isSuccess
  
  }
  public String getResponseFromStatus() {
    switch on this.code {
      // 20x Success messages
      when 200, 201, 202, 203, 204, 205, 206, 207, 208, 226 {
        this.isSuccess = true;
        this.responseMsg = this.body;
      }
      //30x Redirect messages
      when 300 {
        this.responseMsg = 'Multiple responses; ' + this.body;
      }
      when 301 {
        this.responseMsg = 'Moved permanently; ' + this.body;
      }
      when 302 {
        this.responseMsg = 'Found or moved temporarily; ' + this.body;
      }
      when 303 {
        this.responseMsg = 'See other; ' + this.body;
      }
      when 305 {
        this.responseMsg = 'Use proxy; ' + this.body;
      }
      when 307 {
        this.responseMsg = 'Temporarily redirected; ' + this.body;
      }
      when 308 {
        this.responseMsg = 'Permanently redirected; ' + this.body;
      }
      // 40X Client (aka user) errors
      when 400 {
        this.responseMsg = 'Misc bad request; ' + this.body;
      }
      when 401 {
        this.responseMsg = 'Unauthorized; ' + this.body;
      }
      when 402 {
        this.responseMsg = 'Payment required; ' + this.body;
      }
      when 403 {
        this.responseMsg = 'Forbidden; ' + this.body;
      }
      when 404 {
        this.responseMsg = 'Not Found; ' + this.body;
      }
      when 405 {
        this.responseMsg =
          'Method not allowed (i.e., POST where only GET allowed); ' +
          this.body;
      }
      when 406 {
        this.responseMsg =
          'Not Acceptable (Problem with header?); ' + this.body;
      }
      when 407 {
        this.responseMsg = 'Proxy authentication required; ' + this.body;
      }
      when 408 {
        this.responseMsg = 'Request timeout; ' + this.body;
      }
      when 410 {
        this.responseMsg = 'Gone; ' + this.body;
      }
      when 415 {
        this.responseMsg = 'Unsupported media type; ' + this.body;
      }
      when 429 {
        this.responseMsg = 'Too many requests; ' + this.body;
      }
      // 50X Server errors
      when 500 {
        this.responseMsg = 'Internal server error; ' + this.body;
      }
      when 501 {
        this.responseMsg = 'Not implemented; ' + this.body;
      }
      when 502 {
        this.responseMsg = 'Bad gateway; ' + this.body;
      }
      when 503 {
        this.responseMsg = 'Service unavailable; ' + this.body;
      }
      when 504 {
        this.responseMsg = 'Gateway timeout; ' + this.body;
      }
      when 505 {
        this.responseMsg = 'Http version not supported; ' + this.body;
      }
      when 507 {
        this.responseMsg = 'Insufficient storage; ' + this.body;
      }
      when 508 {
        this.responseMsg = 'Loop detected; ' + this.body;
      }
      when 511 {
        this.responseMsg = 'Network authentication required; ' + this.body;
      }
      when else {
        this.responseMsg = this.code + '; ' + this.body;
      }
    }
    return this.responseMsg;
  }
}
