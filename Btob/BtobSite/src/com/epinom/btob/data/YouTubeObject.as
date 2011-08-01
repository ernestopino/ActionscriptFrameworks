package com.epinom.btob.data
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class YouTubeObject
	{
		private var _id:uint;
		private var _loader:Loader;
		private var _videoPlayer:Object;
		private var _container:Sprite;
		private var _itemGalleryVO:ItemGalleryVO;
		private var _item_mc:MovieClip;
		
		public function YouTubeObject(id:uint, loader:Loader, videoPlayer:Object = null, container:Sprite = null, itemGalleryVO:ItemGalleryVO = null, item_mc:MovieClip = null)
		{
			_id = id;
			_loader = loader;
			_videoPlayer = videoPlayer
			_container = container;
			_itemGalleryVO = itemGalleryVO;
			_item_mc = item_mc;
		}
		
		public function get id():uint { return _id; }
		public function set id(value:uint):void { _id = value; }
		
		public function get loader():Loader { return _loader; }
		public function set loader(value:Loader):void { _loader = value; }
		
		public function get videoPlayer():Object { return _videoPlayer; }
		public function set videoPlayer(value:Object):void { _videoPlayer = value; }
		
		public function get container():Sprite { return _container; }
		public function set container(value:Sprite):void { _container = value; }
		
		public function get itemGalleryVO():ItemGalleryVO { return _itemGalleryVO; }
		public function set itemGalleryVO(value:ItemGalleryVO):void { _itemGalleryVO = value; }
		
		public function get item_mc():MovieClip { return _item_mc; }
		public function set item_mc(value:MovieClip):void { _item_mc = value; }
	}
}