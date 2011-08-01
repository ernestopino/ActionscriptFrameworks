/**
 * ...
 * AuthorVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 20/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class AuthorVO
	{
		private var _name:String;
		private var _lastname:String;
		private var _alias:String;
		private var _email:String;
		private var _web:String;
		private var _blog:String;
		
		public function AuthorVO() {}		
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		public function get lastname():String { return _lastname; }
		public function set lastname(value:String):void { _lastname = value; }
		
		public function get alias():String { return _alias; }
		public function set alias(value:String):void { _alias = value; }
		
		public function get email():String { return _email; }
		public function set email(value:String):void { _email = value; }
		
		public function get web():String { return _web; }
		public function set web(value:String):void { _web = value; }
		
		public function get blog():String { return _blog; }
		public function set blog(value:String):void { _blog = value; }
		
		public function toString():String
		{
			var str:String = "[AuthorVO] : " + "name=" + _name + ", lastname=" + _lastname + ", alias=" + _alias + ", email=" + _email + ", web=" + _web + ", blog=" + _blog;
			return str;
		}
	}
}