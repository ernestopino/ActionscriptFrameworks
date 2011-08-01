package com.epinom.btob.ui
{
	import com.epinom.btob.data.ComponentVO;
	import com.epinom.btob.objects.InterfaceObject;
	
	import flash.display.DisplayObject;
	
	public class BtobComponent
	{
		private var _vo:ComponentVO;
		private var _io:InterfaceObject;
		private var _displayObject:DisplayObject;
		
		public function BtobComponent(vo:ComponentVO, io:InterfaceObject, displayObject:DisplayObject)
		{
			super();
			
			_vo = vo;
			_io = io;
			_displayObject = displayObject;
		}
		
		public function get vo():ComponentVO { return _vo; }
		public function set vo(value:ComponentVO):void { _vo = value; }
		
		public function get io():InterfaceObject { return _io; }
		public function set io(value:InterfaceObject):void { _io = value; }
		
		public function get displayObject():DisplayObject { return _displayObject; }
		public function set displayObject(value: DisplayObject):void { _displayObject = value; }
	}
}