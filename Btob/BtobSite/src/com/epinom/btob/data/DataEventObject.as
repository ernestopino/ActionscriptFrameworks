package com.epinom.btob.data
{
	public dynamic class DataEventObject
	{
		private var _origin:String;
		private var _destination:String;
		private var _subdestination:String;
		private var _action:String;
		private var _type:String;
		
		public function DataEventObject(origin:String = null, destination:String = null, action:String = null, type:String = null, subdestination:String = null)
		{
			_origin = origin;
			_destination = destination;
			_subdestination = subdestination;
			_action = action;
			_type = type;
		}
		
		public function get origin():String { return _origin; }
		public function set origin(value:String):void { _origin = value; }
		
		public function get destination():String { return _destination; }
		public function set destination(value:String):void { _destination = value; }
		
		public function get subdestination():String { return _subdestination; }
		public function set subdestination(value:String):void { _subdestination = value; }
		
		public function get action():String { return _action; }
		public function set action(value:String):void { _action = value; }	
		
		public function get type():String { return _type; }
		public function set type(value:String):void { _type = value; }	
				
		public function toString():String {
			return "[DataEventObject]: origin=" + _origin + ", destination=" + _destination + ", subdestination=" + _subdestination + ", action=" + _action + ", type=" + _type;			
		}
	}
}