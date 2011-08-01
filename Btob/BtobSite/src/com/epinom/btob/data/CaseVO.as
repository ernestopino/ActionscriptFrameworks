package com.epinom.btob.data
{
	public class CaseVO
	{
		private var _id:uint;
		private var _ref:String;
		private var _name:String;
		private var _title:String;
		private var _summary:String;
		private var _description:String;
		private var _typeThumb:String;
		private var _urlThumb:String;
		private var _urlPost:String;
		private var _isGreat:Boolean;
		private var _serviceList:Array;
		private var _isVoted:Boolean;
		private var _rating:uint;
		private var _dataEventObject:DataEventObject;
		private var _linkList:Array;
		private var _gallery:Array;	
		
		/* Propiedad que se utiliza como contenedora de datos necesarios. 
		   Tiene un caracter generico (cualquier clase la puede utilizar a su forma siempre y cuando sobreescriba datas anteriores utilizados por otras clases)
		*/
		private var _dao:Object;
		
		private var _isDataCaseLoaded:Boolean;
		
		public function CaseVO() 
		{ 
			_serviceList = new Array();
			_linkList = new Array();
			_gallery = new Array(); 
			_isDataCaseLoaded = false;
		}
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void { _id = value; }
		
		public function get ref():String { return _ref; }
		public function set ref(value:String):void { _ref = value; }
		
		public function get name():String { return _name; }
		public function set name(value:String):void { _name = value; }
		
		public function get title():String { return _title; }
		public function set title(value:String):void { _title = value; }
		
		public function get summary():String { return _summary; }
		public function set summary(value:String):void { _summary = value; }
		
		public function get description():String { return _description; }
		public function set description(value:String):void { _description = value; }
		
		public function get typeThumb():String { return _typeThumb; }
		public function set typeThumb(value:String):void { _typeThumb = value; }
		
		public function get urlThumb():String { return _urlThumb; }
		public function set urlThumb(value:String):void { _urlThumb = value; }
		
		public function get urlPost():String { return _urlPost; }
		public function set urlPost(value:String):void { _urlPost = value; }
		
		public function get isGreat():Boolean { return _isGreat; }
		public function set isGreat(value:Boolean):void { _isGreat = value; }
		
		public function get serviceList():Array { return _serviceList; }
		public function set serviceList(value:Array):void { _serviceList = value; }	
		
		public function get isVoted():Boolean { return _isVoted; }
		public function set isVoted(value:Boolean):void { _isVoted = value; }
		
		public function get rating():uint { return _rating; }
		public function set rating(value:uint):void { _rating = value; }
		
		public function get dataEventObject():DataEventObject { return _dataEventObject; }
		public function set dataEventObject(value:DataEventObject):void { _dataEventObject = value; }
		
		public function get linkList():Array { return _linkList; }
		public function set linkList(value:Array):void { _linkList = value; }
		
		public function get gallery():Array { return _gallery; }
		public function set gallery(value:Array):void { _gallery = value; }
		
		public function get dao():Object { return _dao; }
		public function set dao(value:Object):void { _dao = value; }
		
		public function get isDataCaseLoaded():Boolean { return _isDataCaseLoaded; }
		public function set isDataCaseLoaded(value:Boolean):void { _isDataCaseLoaded = value; }
		
		public function toString():String
		{
			var str:String = "[CaseVO] : " + "id=" + _id + " ref=" + _ref  + " name=" + _name;
			return str;
		}
	}
}