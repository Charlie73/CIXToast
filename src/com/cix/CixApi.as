package com.cix {
	
	import OAuth.*;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class CixApi {
		
		private const _endpoint:String = "http://api.cixonline.com/v1.0/cix.svc";
		private const _consumerToken:OAuthConsumer = new OAuthConsumer("fc6da04b940640bda8dc763c1cac1f","34ef50c8b7ffdf22a10c2dfa8e9374");
		
		private var _requestToken:OAuthToken;
		private var _accessToken:OAuthToken;
		public var _hsGetRequestToken:HTTPService = new HTTPService();
		public var _hsGetAccessToken:HTTPService = new HTTPService();
		public var _hsNextUnread:HTTPService = new HTTPService();
		public var _hsUserProfile:HTTPService = new HTTPService();
		public var _hsUserForums:HTTPService = new HTTPService();
		public var _hsUserScratchPad:HTTPService = new HTTPService();
		public var _hsPointersBack:HTTPService = new HTTPService();
		public var _hsForumTopics:HTTPService = new HTTPService();

		public function get RequestToken():OAuthToken { return this._requestToken; }
		public function get AccessToken():OAuthToken { return this._accessToken; }
		public function set AccessToken( accessToken:OAuthToken ):void { this._accessToken = accessToken; }
		
		public function CixApi() {
			_hsGetRequestToken.addEventListener(ResultEvent.RESULT, gotRequestToken);
			_hsGetAccessToken.addEventListener(ResultEvent.RESULT, gotAccessToken);
			_hsUserForums.resultFormat="xml";
			_hsForumTopics.resultFormat="xml";
		}
		
		/**
		* Get a request token
		*/
		public function getRequestToken():void {
      		var req:OAuthRequest = new OAuthRequest("GET", _endpoint + "/getrequesttoken", null, _consumerToken, null);
      		
      		_hsGetRequestToken.url=req.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
      		_hsGetRequestToken.send();
		}
		
		private function gotRequestToken(e:ResultEvent):void {
			_requestToken = new OAuthToken(_hsGetRequestToken.lastResult.toString().substr(12, 30), _hsGetRequestToken.lastResult.toString().substr(62, 30));	
		}

		/**
		 * Get an access token using a requestToken 
		 */
		public function getAccessToken():void {
    		var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/getaccesstoken", null, _consumerToken, _requestToken);
      		
      		_hsGetAccessToken.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
      		_hsGetAccessToken.send();
		}
		
		private function gotAccessToken(e:ResultEvent):void {
			_accessToken = new OAuthToken(_hsGetAccessToken.lastResult.toString().substr(12, 30), _hsGetAccessToken.lastResult.toString().substr(62, 30));
		}
		
		public function getNextUnread():void {	
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/user/nextunread.xml", null, _consumerToken, _accessToken);
      		_hsNextUnread.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsNextUnread.send();
		}
		
		public function getUserProfile():void {	
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/user/profile.xml", null, _consumerToken, _accessToken);
      		_hsUserProfile.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsUserProfile.send();
		}

		public function getUserForums():void {
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/user/forums.xml", null, _consumerToken, _accessToken);
      		_hsUserForums.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsUserForums.send();
		}
		
		public function getForumTopics(forum:String):void { 
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/forums/" + forum + "/topics.xml", null, _consumerToken, _accessToken);
      		_hsForumTopics.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsForumTopics.send();
		}
		
		/**
		 BackMsgs - Get the last x messages within a topic, set to 0 if you only want unread messages.   
		 */
		public function getScratchPad(clientName:String, maxMsgs:int, backMsgs:int=0):void {
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/user/" + clientName + "/" + maxMsgs.toString() + "/" + backMsgs.toString() + "/scratchpad.xml", null, _consumerToken, _accessToken);
      		_hsUserScratchPad.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsUserScratchPad.send();		
		}
		
		public function setPointersBack(clientName:String, backDays:int=0):void {
			var request:OAuthRequest = new OAuthRequest("GET", _endpoint + "/user/" + clientName + "/" + backDays.toString() + "/setpointersback.xml", null, _consumerToken, _accessToken);
      		_hsPointersBack.url=request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(),"url",null);
			_hsPointersBack.send();	
		}
	}
}