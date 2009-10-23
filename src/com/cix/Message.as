package com.cix
{
	public class Message {		
		private var _forum:String;
		private var _topic:String;
		private var _messageID:String;
		private var _body:String;
		private var _author:String;
		private var _posted:Date;
		
		public function Message(forum:String, topic:String, messageID:String, body:String, author:String, posted:Date) {
			this._forum = forum;
			this._topic = topic;
			this._messageID = messageID;
			this._body = body;
			this._author = author;
			this._posted = posted;
		}
		
		public function get Forum():String { return _forum; }
		public function get Topic():String { return _topic; }
		public function get MessageID():String { return _messageID; }
		public function get Body():String { return _body; }
		public function get Author():String { return _author; }
		public function get Posted():Date { return _posted; }
	}
}