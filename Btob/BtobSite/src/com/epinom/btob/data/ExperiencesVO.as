package com.epinom.btob.data
{
	public class ExperiencesVO
	{
		private var _clientList:Array;		
		
		public function ExperiencesVO() { _clientList = new Array(); }
		
		public function get clientList():Array { return _clientList; }
		public function set clientList(value:Array):void { _clientList = value; } 
	}
}