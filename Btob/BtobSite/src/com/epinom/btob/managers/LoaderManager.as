/**
* ...
* LoaderManager, Versión AS3.3
* Lleva el control de toda la carga de archivos SWF, JPEG, GIF o PNG
* Utiliza un patron Singleton, con el objetivo de que solo pueda existir una unica instancia de la clase.
* 
* @author Ernesto Pino Martínez
* @version v09/12/2008 0:09
*/

package com.epinom.btob.managers
{
	/**
	 * @import
	 */
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.display.Loader;
	
	import com.epinom.btob.events.EventComplex;
	
	public class LoaderManager extends EventDispatcher
	{
		/**
		 * @property
		 * Instancia de la clase LoaderManager, se instancia una unica vez (Singleton)
		 */
		private static var _instance:LoaderManager = null;
		
		/**
		 * @property
		 * Objeto Loader que permite realizar acciones de carga de ficheros externos de tipo SWF
		 */
		private var _swfLoader:Loader;
		
		/**
		 * @property
		 * Objeto Loader que permite realizar acciones de carga de ficheros externos de JPG
		 */
		private var _jpgLoader:Loader;
		
		/**
		 * @property
		 * Objeto de datos que conforma el evento complejo para carga de ficheros SWF
		 */
		private var _dataSWF:Object;
		
		/**
		 * @property
		 * Objeto de datos que conforma el evento complejo para carga de ficheros JPG
		 */
		private var _dataJPG:Object;
		
		/**
		 * @property
		 * Valores constantes
		 */
		public static const SWF_TYPE:String = "SWF";
		public static const JPG_TYPE:String = "JPG";
		public static const SWF_LOAD_COMPLETE:String = "onSWFLoadComplete";
		public static const JPG_LOAD_COMPLETE:String = "onJPGLoadComplete";

		/**
		 * @constructor
		 * Constructor de la clase
		 * 
		 * @param	singleton	Objeto de tipo Singleton, garantiza que la clase se intancie una unice vez
		 */
		public function LoaderManager(singleton:Singleton)
		{
			trace("LoaderManager->LoaderManager()");						
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LoaderManager
		 * 
		 * @return	_instance	Unica instancia de la clase LoaderManager 	
		 */
		public static function getInstance():LoaderManager
		{
			if (_instance == null)
				_instance = new LoaderManager(new Singleton());
			return _instance;
		}
		
		/**
		 * @method
		 * Devuelve una referencia al cargador swf
		 * 
		 * @return	_swfLoader	Cargador SWF
		 */
		public function get swfLoader():Loader
		{
			return _swfLoader;
		}
		
		/**
		 * @method
		 * Devuelve una referencia al cargador jpg
		 * 
		 * @return	_jpgLoader	Cargador JPG
		 */
		public function get jpgLoader():Loader
		{
			return _jpgLoader;
		}
		
		/**
		 * @method
		 * Carga archivos SWF
		 * 
		 * @param	url		URL del fichero a cargar
		 */
		public function loadSWF(url:String, id:String):void
		{
			trace("LoaderManager->loadSWF()");
			
			// Creando objeto de datos para evento complejo
			_dataSWF = new Object();
			_dataSWF.id = id;
			_dataSWF.type = SWF_TYPE;
			
			// Cargando fichero 	
			_swfLoader = new Loader();		
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoadCompleteHandler, false, 0, true);
			_swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onSWFProgressLoadHandler, false, 0, true);
			_swfLoader.load(new URLRequest(url));			
		}
		
		/**
		 * @method
		 * Carga archivos JPG
		 * 
		 * @param	url		URL del fichero a cargar
		 */
		public function loadJPG(url:String, id:String):void
		{
			trace("LoaderManager->loadJPG()");
			
			// Creando objeto de datos para evento complejo
			_dataJPG = new Object();
			_dataJPG.id = id;
			_dataJPG.type = JPG_TYPE;
			
			// Cargando fichero 	
			_jpgLoader = new Loader();			
			_jpgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onJPGLoadCompleteHandler, false, 0, true);
			_jpgLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onJPGProgressLoadHandler, false, 0, true);
			_jpgLoader.load(new URLRequest(url));			
		}
		
		/**
		 * @evento
		 * Se ejecuta al finalizar la carga del fichero SWF externo
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onSWFLoadCompleteHandler(evt:Event):void
		{
			trace("LoaderManager->onSWFLoadCompleteHandler()");
			
			try
			{			
				// Creando un evento complejo
				var evt_complex:EventComplex = new EventComplex(SWF_LOAD_COMPLETE, _dataSWF); 
				
				// Despachando evento personalizado			
				this.dispatchEvent(evt_complex);
				
				// Eliminando detectores de eventos
				_swfLoader.removeEventListener(Event.COMPLETE, onSWFLoadCompleteHandler);
				_swfLoader.removeEventListener(ProgressEvent.PROGRESS, onSWFProgressLoadHandler);				
			}
			catch(err:Error)
			{
				trace("No se ha podido cargar el fichero: " + err.message);		
			}				
		}	
		
		/**
		 * @evento
		 * Se ejecuta al finalizar la carga del fichero JPG externo
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onJPGLoadCompleteHandler(evt:Event):void
		{
			trace("LoaderManager->onJPGLoadCompleteHandler()");
			
			try
			{
				// Creando datos del evento
				var data:String = new String();
				
				// Creando un evento complejo
				var evt_complex:EventComplex = new EventComplex(JPG_LOAD_COMPLETE, data); 
				
				// Despachando evento personalizado			
				this.dispatchEvent(evt_complex);
				
				// Eliminando detectores de eventos
				_jpgLoader.removeEventListener(Event.COMPLETE, onJPGLoadCompleteHandler);
				_jpgLoader.removeEventListener(ProgressEvent.PROGRESS, onJPGProgressLoadHandler);				
			}
			catch(err:Error)
			{
				trace("No se ha podido cargar el fichero: " + err.message);		
			}				
		}	
		
		/**
		 * @evento
		 * Se ejecuta mientras el fichero SWF se este cargando
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onSWFProgressLoadHandler(evt:ProgressEvent):void
		{
			trace("LoaderManager->onSWFProgressLoadHandler()");
			
			// Despachando evento 
			this.dispatchEvent(evt);
		}	
		
		/**
		 * @evento
		 * Se ejecuta mientras el fichero JPG se este cargando
		 * 
		 * @param	evt		Evento contenedor de datos
		 */
		public function onJPGProgressLoadHandler(evt:ProgressEvent):void
		{
			trace("LoaderManager->onJPGProgressLoadHandler()");
			
			// Despachando evento 
			this.dispatchEvent(evt);
		}
	}
}

/**
 * @singleton
 */
class Singleton{}