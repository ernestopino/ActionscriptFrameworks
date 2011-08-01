/**
 * ...
 * LanguageVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 22/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class ModalWindowVO
	{
		private var _hash:String;
		private var _titleText:String;
		private var _text:String;
		private var _buttonText:String;
		
		public function ModalWindowVO() {}
		
		public function get hash():String { return _hash; }		
		public function set hash(value:String):void { _hash = value; }
		
		public function get titleText():String { return _titleText; }		
		public function set titleText(value:String):void { _titleText = value; }	
		
		public function get text():String { return _text; }		
		public function set text(value:String):void { _text = value; }
		
		public function get buttonText():String { return _buttonText; }		
		public function set buttonText(value:String):void { _buttonText = value; }
	}
}