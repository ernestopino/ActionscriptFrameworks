package com.epinom.vetusta.musicexperience.vos
{
	public class ResolutionVO
	{
		private var _width:Number;
		private var _height:Number;
		
		public function ResolutionVO() {}
		
		public function get width():Number { return _width; }
		public function set width(value:Number):void { _width = value; }
		
		public function get height():Number { return _height; }
		public function set height(value:Number):void { _height = value; }
		
		public function toString():String
		{
			var str:String = "[ResolutionVO] : " + "width=" + _width +  ", height=" + _height;
			return str;
		}
	}
}