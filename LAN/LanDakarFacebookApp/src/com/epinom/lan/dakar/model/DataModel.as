/**
 * ...
 * DataModel
 * Modelo de datos de la aplicacion
 * 
 * @author Ernesto Pino Martínez
 * @date 20/10/2010
 */

package com.epinom.lan.dakar.model
{
	import com.epinom.lan.dakar.vo.SettingsVO;

	public class DataModel
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:DataModel = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 
		
		/**
		 * @property
		 * Configuracion de la aplicacion
		 */
		private var _settings:SettingsVO;
		
		/**
		 * @property
		 * Lista de ganadores
		 */
		private var _winnerList:Array;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */
		public function DataModel()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciacion fallida: Use DataModel.getInstance() para crar una nueva instancia.");				
			} else {				
				_settings = new SettingsVO();
				_winnerList = new Array();
			}
		}
		
		/**
		 * @PUBLIC METHODS
		 * Funciones publicas de la clase
		 */
		
		/**
		 * @method
		 * Getters y Setters
		 */
		public function get settings():SettingsVO { return _settings; }
		public function set settings(value:SettingsVO):void { _settings = value; }

		public function get winnerList():Array { return _winnerList; }
		public function set winnerList(value:Array):void { _winnerList = value; }
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LanDakarFacebookTabManager
		 * 
		 * @return	instancia	Unica instancia de la clase LanDakarFacebookTabManager 	
		 */
		public static function getInstance():DataModel
		{
			if(_instance == null)
			{
				_allowInstantiation = true;
				_instance = new DataModel();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
				
	}
}