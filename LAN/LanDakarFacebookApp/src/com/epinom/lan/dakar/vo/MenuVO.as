/**
 * ...
 * MenuVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 21/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class MenuVO
	{
		private var _hash:String;
		private var _button0Text:String;
		private var _button1Text:String;
		private var _button2Text:String;
		
		public function MenuVO() {}
		
		public function get hash():String { return _hash; }		
		public function set hash(value:String):void { _hash = value; }
		
		public function get button0Text():String { return _button0Text; }
		public function set button0Text(value:String):void { _button0Text = value; }
		
		public function get button1Text():String { return _button1Text; }
		public function set button1Text(value:String):void { _button1Text = value; }
		
		public function get button2Text():String { return _button2Text; }
		public function set button2Text(value:String):void { _button2Text = value; }
	}
}