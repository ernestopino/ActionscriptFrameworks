/**
 * ...
 * SettingsVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 20/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class SettingsVO
	{
		private var _settingsXMLLocation:String;
		private var _winnersXMLLocation:String;
		
		private var _appName:String;
		private var _version:String;
		private var _author:AuthorVO;
		private var _owner:OwnerVO;
		private var _resolution:ResolutionVO;
		private var _soundList:Array;
		private var _componentList:Array;
		
		public function SettingsVO(){
			_soundList = new Array();
			_componentList = new Array();
		}
		
		public function get settingsXMLLocation():String { return _settingsXMLLocation; }		
		public function set settingsXMLLocation(value:String):void { _settingsXMLLocation = value; }
		
		public function get winnersXMLLocation():String { return _winnersXMLLocation; }		
		public function set winnersXMLLocation(value:String):void { _winnersXMLLocation = value; }
			
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
		
		public function get componentList():Array { return _componentList; }
		public function set componentList(value:Array):void { _componentList = value; }	
		
		public function getComponentByHash(hash:String):ComponentVO
		{
			var component:ComponentVO = null;
			for(var i:uint = 0; i < _componentList.length; i++) {
				if((_componentList[i] as ComponentVO).hashId == hash) {
					component = _componentList[i] as ComponentVO;
					break;
				}
			}
			
			return component;
		}
		
		public function updateComponent(hash:String, component:ComponentVO):Boolean
		{
			var success:Boolean = false;
			var component:ComponentVO = null;
			for(var i:uint = 0; i < _componentList.length; i++) {
				if((_componentList[i] as ComponentVO).hashId == hash) {
					_componentList[i] = component;
					success = true;
					break;
				}
			}
			
			return success;
		}
		
		public function toString():String
		{
			var str:String = "SettingsVO:\n" +
							 " - settingsLocation=" + _settingsXMLLocation + "\n" +
							 " - appName=" + _appName + "\n" + 
							 " - version=" + _version + "\n" + 
							 " - author=" + _author.toString() + "\n" + 
							 " - owner=" + _owner.toString() + "\n" +
							 " - soundList.length=" + _soundList.length + "\n" +
							 " - componentList.length=" + _componentList.length + "\n" +
							 " - resolution=" + _resolution.toString();
			return str;
		}
	}
}