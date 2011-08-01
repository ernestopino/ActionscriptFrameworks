package com.epinom.lan.machupicchu.vos
{
	public class ItemGalleryVO
	{
		private var _id:String;
		private var _name:String;
		private var _author:String;
		private var _urlImage:String;
		private var _voted:Boolean;
		
		public function ItemGalleryVO() {}
		
		/**
		 * @Getters and Setters
		 */
		public function get id():String { return _id; }
		public function set id(value:String) { _id = value; }
		
		public function get name():String { return _name; }
		public function set name(value:String) { _name = value; }
		
		public function get author():String { return _author; }
		public function set author(value:String) { _author = value; }
		
		public function get urlImage():String { return _urlImage; }
		public function set urlImage(value:String) { _urlImage = value; }
		
		public function get voted():Boolean { return _voted; }
		public function set voted(value:Boolean) { _voted = value; }
	}
}