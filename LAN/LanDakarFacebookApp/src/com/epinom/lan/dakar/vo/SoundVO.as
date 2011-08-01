/**
 * ...
 * SoundVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 20/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class SoundVO
	{
		private var _id:uint;
		private var _url:String;
		
		public function SoundVO(){}
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void { _id = value; }
		
		public function get url():String { return _url; }
		public function set url(value:String):void { _url = value; }
	}
}