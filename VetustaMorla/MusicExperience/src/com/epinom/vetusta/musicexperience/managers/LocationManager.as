package com.epinom.vetusta.musicexperience.managers
{
	import com.epinom.vetusta.musicexperience.data.HashMap;
	import com.epinom.vetusta.musicexperience.ui.Location;

	public class LocationManager
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:LocationManager = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 
		
		private var _locationMap:HashMap;
		
		public function LocationManager()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciación fallida: Use LocationManager.getInstance() para crar nuevas instancias.");
			} else {
				_locationMap = new HashMap();
			}
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LocationManager
		 * 
		 * @return	instancia	Unica instancia de la clase LocationManager 	
		 */
		public static function getInstance():LocationManager 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new LocationManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function add(location:Location):String 
		{
			var key:String = "L" + location.vo.id + "-" + location.vo.idCell;
			_locationMap.add(key, location);	
			return key;
		}
		
		public function locationWithKey(key:String):Location
		{
			return _locationMap.getValue(key);
		}
	}
}