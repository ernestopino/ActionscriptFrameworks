package com.epinom.btob.events
{
	import flash.events.Event;

	public class XMLServiceEvent extends Event
	{
		static public const XML_LOADED:String = "xmlLoaded";
		static public const XML_ERROR:String = "xmlError";
		
		private var _xml:XML;
		private var _message:String;
		private var _error:Error;
		
		public function XMLServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{		
			super(type, bubbles, cancelable);
		}
		
		public function get xml():XML { return _xml; }
		
		public function set xml(value:XML):void 
		{
			_xml = value;
		}
		
		public function get message():String { return _message; }
		
		public function set message(value:String):void 
		{
			_message = value;
		}
		
		public function get error():Error { return _error; }
		
		public function set error(value:Error):void 
		{
			_error = value;
		}
	}
}