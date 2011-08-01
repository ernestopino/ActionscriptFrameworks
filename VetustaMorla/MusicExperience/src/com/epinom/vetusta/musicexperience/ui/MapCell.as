package com.epinom.vetusta.musicexperience.ui
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class MapCell extends Sprite
	{
		private var _idCell:String;
		private var _idGrid:String;
		private var _idBlock:String;
		private var _imageName:String;
		private var _urlImageServer:String;
		private var _image:Bitmap;
		private var _mcName:String;
		private var _urlMovieClipServer:String;
		private var _mc:MovieClip;
		private var _loadPriority:uint;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function MapCell() { super(); }
		
		/**
		 * Getters y Setters
		 */
		
		public function get idCell():String { return _idCell; }
		public function set idCell(value:String):void { _idCell = value; }
		
		public function get idGrid():String { return _idGrid; }
		public function set idGrid(value:String):void { _idGrid = value; }
		
		public function get idBlock():String { return _idBlock; }
		public function set idBlock(value:String):void { _idBlock = value; }
		
		public function get imageName():String { return _imageName; }
		public function set imageName(value:String):void { _imageName = value; }
		
		public function get urlImageServer():String { return _urlImageServer; }
		public function set urlImageServer(value:String):void { _urlImageServer = value; }
		
		public function get image():Bitmap { return _image; }
		public function set image(value:Bitmap):void { _image = value; }
		
		public function get mcName():String { return _mcName; }
		public function set mcName(value:String):void { _mcName = value; }
		
		public function get urlMovieClipServer():String { return _urlMovieClipServer; }
		public function set urlMovieClipServer(value:String):void { _urlMovieClipServer = value; }
		
		public function get mc():MovieClip { return _mc; }
		public function set mc(value:MovieClip):void { _mc = value; }
		
		public function get loadPriority():uint { return _loadPriority; }
		public function set loadPriority(value:uint):void { _loadPriority = value; }
		
		public function get offsetX():Number { return _offsetX; }
		public function set offsetX(value:Number):void { _offsetX = value; }
		
		public function get offsetY():Number { return _offsetY; }
		public function set offsetY(value:Number):void { _offsetY = value; }
	}
}