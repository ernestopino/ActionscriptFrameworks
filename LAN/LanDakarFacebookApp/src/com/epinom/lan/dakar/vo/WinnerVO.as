/**
 * ...
 * WinnerVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 25/09/2010
 */

package com.epinom.lan.dakar.vo
{
	import flash.display.Bitmap;
	import flash.display.Loader;

	public class WinnerVO
	{
		private var _id:uint;
		private var _pic:String;
		private var _bitmap:Bitmap;
		private var _name:String;
		private var _gift:String;
		private var _date:String;
		private var _loader:Loader;
		
		public function WinnerVO() {}

		public function get id():uint { return _id; }
		public function set id(value:uint):void { _id = value; }
		
		public function get pic():String { return _pic; }
		public function set pic(value:String):void { _pic = value; }
		
		public function get bitmap():Bitmap { return _bitmap; }
		public function set bitmap(value:Bitmap):void { _bitmap = value; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		public function get gift():String { return _gift; }
		public function set gift(value:String):void { _gift = value; }
		
		public function get date():String { return _date; }
		public function set date(value:String):void { _date = value; }
		
		public function get loader():Loader { return _loader; }
		public function set loader(value:Loader):void { _loader = value; }
	}
}