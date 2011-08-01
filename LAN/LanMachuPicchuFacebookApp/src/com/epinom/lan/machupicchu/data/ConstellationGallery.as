package com.epinom.lan.machupicchu.data
{
	public class ConstellationGallery
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:ConstellationGallery = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 
		
		private var _pageNumber:int;
		private var _totalPages:int;
		private var _prevButtonActive:Boolean;
		private var _nextButtonActive:Boolean;
		private var _viewMyConstellationButtonActive:Boolean;
		private var _gallery:Array;
		
		public function ConstellationGallery()
		{			
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciación fallida: Use ConstellationGallery.getInstance() para crar nuevas instancias.");
			} else {	
				trace("ConstellationGallery->ConstellationGallery()");
			}	
		}
		
		public function destructor():void
		{
			trace("ConstellationGallery->destructor()");
			
			_pageNumber = -1;
			_totalPages = -1;
			_prevButtonActive = false;
			_nextButtonActive = false;
			_viewMyConstellationButtonActive = false;
			_gallery = new Array();
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase ConstellationGallery
		 * 
		 * @return	instancia	Unica instancia de la clase ConstellationGallery 	
		 */
		public static function getInstance():ConstellationGallery 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new ConstellationGallery();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * @Getters and Setters
		 */
		public function get pageNumber():int { return _pageNumber; }
		public function set pageNumber(value:int) { _pageNumber = value; }
		
		public function get totalPages():int { return _totalPages; }
		public function set totalPages(value:int) { _totalPages = value; }
		
		public function get prevButtonActive():Boolean { return _prevButtonActive; }
		public function set prevButtonActive(value:Boolean) { _prevButtonActive = value; }
		
		public function get nextButtonActive():Boolean { return _nextButtonActive; }
		public function set nextButtonActive(value:Boolean) { _nextButtonActive = value; }
		
		public function get viewMyConstellationButtonActive():Boolean { return _viewMyConstellationButtonActive; }
		public function set viewMyConstellationButtonActive(value:Boolean) { _viewMyConstellationButtonActive = value; }
		
		public function get gallery():Array { return _gallery; }
		public function set gallery(value:Array) { _gallery = value; }
	}
}