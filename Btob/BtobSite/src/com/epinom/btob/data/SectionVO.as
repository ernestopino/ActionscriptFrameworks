package com.epinom.btob.data
{
	public class SectionVO
	{
		private var _id:uint;
		private var _name:String;
		private var _urlSWF:String;
		private var _urlImage:String;
		
		public function SectionVO() {} 
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void {_id = value; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void {_name = value; }
		
		public function get urlSWF():String { return _urlSWF; }
		public function set urlSWF(value:String):void {_urlSWF = value; }
		
		public function get urlImage():String { return _urlImage; }
		public function set urlImage(value:String):void {_urlImage = value; }
	}
}