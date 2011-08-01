/**
* ...
* XMLManager, Versión AS3.3
* Lleva el control de toda la informacion cargada por xmls
* Utiliza un patron Singleton, con el objetivo de que solo pueda existir una unica instancia de la clase.
* 
* @author Ernesto Pino Martínez
* @version v06/12/2008 20:20
*/

package com.epinom.btob.managers
{
	/**
	 * @import
	 */
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoaderDataFormat;
	
	import com.epinom.btob.events.EventComplex;
	
	public class XMLManager extends EventDispatcher
	{
		/**
		 * @property
		 * Instancia de la clase XMLManager, se instancia una unica vez (Singleton)
		 */
		private static var _instance:XMLManager = null;
		
		/**
		 * @property
		 * Objeto Loader que permite realizar acciones de carga de ficheros externos
		 */
		private var _urlLoader:URLLoader;
		
		/**
		 * @property
		 * Valores constantes
		 */
		public static const XML_LOAD_COMPLETE:String = "onXMLLoadComplete";

		/**
		 * @constructor
		 * Constructor de la clase
		 * 
		 * @param	singleton	Objeto de tipo Singleton, garantiza que la clase se intancie una unice vez
		 */
		public function XMLManager(singleton:Singleton)
		{
			trace("XMLManager->XMLManager()");						
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase XMLManager
		 * 
		 * @return	_instance	Unica instancia de la clase XMLManager 	
		 */
		public static function getInstance():XMLManager
		{
			if (_instance == null)
				_instance = new XMLManager(new Singleton());
			return _instance;
		}
		
		/**
		 * @method
		 * Carga el fichero xml externo
		 * 
		 * @param	url		URL del fichero a cargar
		 */
		public function load(url:String):void
		{
			trace("XMLManager->load()");
			
			// Cargando fichero xml 			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onCompleteHandler, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler, false, 0, true);
			_urlLoader.load(new URLRequest(url));
		}
		
		/**
		 * @evento
		 * Se ejecuta al finalizar la carga del fichero xml
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onCompleteHandler(evt:Event):void
		{
			trace("XMLManager->onCompleteHandler()");
			
			try
			{
				// Obteniendo 
				var data:XML = new XML(evt.target.data);
				
				// Configurando formato del fichero
				XML.ignoreWhitespace = true;
				
				// Creando un evento complejo
				var evt_complex:EventComplex = new EventComplex(XML_LOAD_COMPLETE, data); 
				
				// Despachando evento personalizado			
				this.dispatchEvent(evt_complex);
				
				// Eliminando detectores de eventos
				_urlLoader.removeEventListener(Event.COMPLETE, onCompleteHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);				
			}
			catch(err:Error)
			{
				trace("No se ha podido parsear el XML: " + err.message);		
			}				
		}	
		
		/**
		 * @evento
		 * Se ejecuta si hay un error mientras se carga el fichero xml
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onIOErrorHandler(evt:IOErrorEvent):void
		{
			trace("XMLManager->onIOErrorHandler()");
			trace("Ha ocurrido un error mientras se intentaba cargar el XML: " + evt.text);	
		}		
	}
}

/**
 * @singleton
 */
class Singleton{}

