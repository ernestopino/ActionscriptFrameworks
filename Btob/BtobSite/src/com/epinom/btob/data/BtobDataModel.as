package com.epinom.btob.data
{
	public class BtobDataModel
	{
		private static var _instance:BtobDataModel;
		private static var _allowInstantiation:Boolean;
		
		private var _settings:SettingsVO;
		private var _componentList:Array;
		private var _sectionList:Array;
		
		public function BtobDataModel()
		{
			if (!_allowInstantiation)
			{
				throw new Error("ERROR: Instantiation failed. Use BtobDataModel.getInstance() instead of new.");
			}
			else
			{				
				_settings = new SettingsVO();
				_componentList = new Array();
				_sectionList = new Array();
			}
		}
		
		public static function getInstance():BtobDataModel
		{
			if(_instance == null)
			{
				_allowInstantiation = true;
				_instance = new BtobDataModel();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get settings():SettingsVO { return _settings; }
		public function set settings(value:SettingsVO):void { _settings = value; }
		
		public function get componentList():Array { return _componentList; }
		public function set componentList(value:Array):void { _componentList = value; }
		
		public function get sectionList():Array { return _sectionList; }
		public function set sectionList(value:Array):void { _sectionList = value; }			
	}
}