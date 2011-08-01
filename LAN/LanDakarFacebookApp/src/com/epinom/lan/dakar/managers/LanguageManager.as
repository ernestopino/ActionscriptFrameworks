/**
 * ...
 * LanguageManager
 * Controla el lenguaje de la aplicacion
 * 
 * @author Ernesto Pino Martínez
 * @date 21/09/2010
 */

package com.epinom.lan.dakar.managers
{
	import com.digitalsurgeons.loading.BulkLoader;
	import com.epinom.lan.dakar.vo.LanguageVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LanguageManager extends EventDispatcher
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:LanguageManager = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 			
		
		/**
		 * @property
		 */
		private var _languageApplication:String;
		
		/**
		 * @property
		 */
		private var _data:LanguageVO;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */
		public function LanguageManager() 
		{
			trace("LanguageManager->LanguageManager()");
			
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciación fallida: Use LanguageManager.getInstance() para crar nuevas instancias.");
			} else {								
				
				// Idioma temporal
				_languageApplication = TableDataManager.UNDEFINED;
				_data = new LanguageVO();
			}			
		}
		
		
		/**
		 * @PUBLIC METHODS
		 * Funciones publicas de la clase
		 */
		
		/**
		 * @Getters and Setters
		 */
		public function get languageApplication():String { return _languageApplication; }
		public function get data():LanguageVO { return _data; }
		public function set data(value:LanguageVO) { _data = value; }
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LanDakarFacebookTabManager
		 * 
		 * @return	instancia	Unica instancia de la clase LanguageManager 	
		 */
		public static function getInstance():LanguageManager 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new LanguageManager();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * @method
		 * Realiza peticion a un servicio PHP externo de la configuracion de lenguaje de la aplicacion.
		 * Despacha un evento de completititud de la configuracion para que la clase "MainManager" pueda continuar con su ejecucion
		 */
		public function loadLanguageConfiguration(flashvars:Object):void
		{
			if(flashvars.language != null)
			{
				// Verificando lenguaje de la aplicacion
				if(flashvars.language == TableDataManager.SPANISH)		
					_languageApplication = TableDataManager.SPANISH;
				else if(flashvars.language == TableDataManager.FRENCH)
					_languageApplication = TableDataManager.FRENCH;
				else
					throw new Error("Lenguage de aplicacion desconocido: " + flashvars.language);
			}
			else
			{
				_languageApplication = TableDataManager.SPANISH;
				trace(_languageApplication);
			}
			
			// Despachando evento para avisar a las clases suscriptoras que se ha cargado el lenguaje satisfactoriamente
			dispatchEvent(new Event(TableDataManager.LANGUAGE_LOADED));
		}
	}
}