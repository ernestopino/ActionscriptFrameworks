package com.epinom.btob.data
{
	public class LinkVO
	{
		private var _id:uint;
		private var _text:String;
		private var _url:String;
		
		public function LinkVO() {}
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void { _id = value; }
		
		public function get text():String { return _text; }
		public function set text(value:String):void { _text = value; }
		
		public function get url():String { return _url; }
		public function set url(value:String):void { _url = value; }
	}
}