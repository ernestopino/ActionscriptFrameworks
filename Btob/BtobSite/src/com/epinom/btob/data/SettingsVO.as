package com.epinom.btob.data
{
	public class SettingsVO
	{
		private var _settingsXMLLocation:String;
		private var _appName:String;
		private var _version:String;
		private var _author:AuthorVO;
		private var _owner:OwnerVO;
		private var _resolution:ResolutionVO;
		private var _soundList:Array;
		private var _sectionVOList:Array;
		private var _componentVOList:Array;
		private var _greatVOList:Array;
		
		public function SettingsVO(){
			_sectionVOList = new Array();
			_componentVOList = new Array();
			_greatVOList = new Array();
			_soundList = new Array();
		}
		
		public function get settingsXMLLocation():String { return _settingsXMLLocation; }		
		public function set settingsXMLLocation(value:String):void { _settingsXMLLocation = value; }			
		
		public function get appName():String { return _appName; }		
		public function set appName(value:String):void { _appName = value; }
		
		public function get version():String { return _version; }		
		public function set version(value:String):void { _version = value; }
		
		public function get author():AuthorVO { return _author; }
		public function set author(value):void { _author = value; }
		
		public function get owner():OwnerVO { return _owner; }
		public function set owner(value:OwnerVO):void { _owner = value; }
		
		public function get resolution():ResolutionVO { return _resolution; }
		public function set resolution(value:ResolutionVO):void { _resolution = value; }
		
		public function get soundList():Array { return _soundList; }
		public function set soundList(value:Array):void { _soundList = value; }
		
		public function get sectionVOList():Array { return _sectionVOList; }
		public function set sectionVOList(value:Array):void { _sectionVOList = value; }
		
		public function get componentVOList():Array { return _componentVOList; }
		public function set componentVOList(value:Array):void { _componentVOList = value; }
		
		public function get greatVOList():Array { return _greatVOList; }
		public function set greatVOList(value:Array):void { _greatVOList = value; }
		
		public function getSectionByName(name:String):SectionVO
		{
			var section:SectionVO = null;
			for(var i:uint = 0; i < _sectionVOList.length; i++) {
				if((_sectionVOList[i] as SectionVO).name == name) {
					section = _sectionVOList[i] as SectionVO;
					break;
				}
			}
			
			return section;
		}
		
		public function getComponentByHash(hash:String):ComponentVO
		{
			var component:ComponentVO = null;
			for(var i:uint = 0; i < _componentVOList.length; i++) {
				if((_componentVOList[i] as ComponentVO).hashId == hash) {
					component = _componentVOList[i] as ComponentVO;
					break;
				}
			}
			
			return component;
		}	
		
		public function updateComponent(hash:String, component:ComponentVO):Boolean
		{
			var success:Boolean = false;
			var component:ComponentVO = null;
			for(var i:uint = 0; i < _componentVOList.length; i++) {
				if((_componentVOList[i] as ComponentVO).hashId == hash) {
					_componentVOList[i] = component;
					success = true;
					break;
				}
			}
			
			return success;
		}
		
		public function toString():String
		{
			var str:String = "SettingsVO:\n" +
							 " - location=" + _settingsXMLLocation + "\n" + 
							 " - appName=" + _appName + "\n" + 
							 " - version=" + _version + "\n" + 
							 " - author=" + _author.toString() + "\n" + 
							 " - owner=" + _owner.toString() + "\n" +
							 " - soundList.length=" + _soundList.length + "\n" +
							 " - resolution=" + _resolution.toString();
			return str;
		}
	}
}