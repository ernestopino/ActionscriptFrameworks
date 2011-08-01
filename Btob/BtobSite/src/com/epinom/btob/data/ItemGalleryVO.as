package com.epinom.btob.data
{
	import flash.display.Sprite;

	public class ItemGalleryVO
	{
		private var _id:uint;
		private var _type:String;
		private var _thumb:String;
		private var _url:String;
		private var _thumbContainer:Sprite;
		private var _mediaContainer:Sprite;
		
		public function ItemGalleryVO() {}
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void {_id = value; }
		
		public function get type():String { return _type; }
		public function set type(value:String):void {_type = value; }
		
		public function get thumb():String { return _thumb; }
		public function set thumb(value:String):void {_thumb = value; }
		
		public function get url():String { return _url; }
		public function set url(value:String):void {_url = value; }
		
		public function get thumbContainer():Sprite { return _thumbContainer; }
		public function set thumbContainer(value:Sprite):void {_thumbContainer = value; }
		
		public function get mediaContainer():Sprite { return _mediaContainer; }
		public function set mediaContainer(value:Sprite):void {_mediaContainer = value; }
	}
}