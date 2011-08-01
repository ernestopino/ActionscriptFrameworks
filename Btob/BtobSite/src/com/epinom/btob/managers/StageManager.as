/**
* ...
* StageManager, Versión AS3.3
* Controla todo los elementos de la interfaz, especificamente el reposicionamiento de los elementos con redimensionamiento del browser
* 
* @author Ernesto Pino Martínez
* @version v07/12/2008 22:05
*/

package com.epinom.btob.managers
{
	/**
	 * @import
	 */	
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.objects.InterfaceObject;
	import com.epinom.btob.structs.HashMap;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class StageManager extends Sprite
	{
		/**
		 * @property
		 * Unica instancia de la clase, esta clase utiliza un patrom Singleton
		 */
		private static var _instance:StageManager = null;
		
		/**
		 * @property
		 * Referencia al escenario de la pelicula principal
		 */
		private var _stage:Stage;
		
		/**
		 * @property
		 * Lista de objetos que se encuentran en pantalla
		 */
		private var _hashMap:HashMap;
		
		/**
		 * @property
		 * Valor minimo del ancho del escenario para el cual los objetos dejan de reposicionarse
		 */ 
		private var _minWidth:Number;	
		
		/**
		 * @property
		 * Valor minimo del alto del escenario para el cual los objetos dejan de reposicionarse
		 */ 
		private var _minHeight:Number;
		
		/**
		 * @property
		 * Valores constantes
		 */
		public static const STAGE_RESIZE:String = "onStageResize";
		
		/**
		 * @constructor
		 * Constructor de la clase
		 * 
		 * @param	singleton		Objeto de tipo Singleton, garantiza que la clase se intancie una unice vez		 
		 */
		function StageManager(singleton:Singleton)
		{
			trace("StageManager->StageManager()");
			
			// Obteniendo referencia al escenario principal
			_stage = SiteManager.getInstance().getStageReference();
			
			// Inicializando propiedades
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.addEventListener(Event.RESIZE, onResizeHandler);
			_hashMap = new HashMap();			
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase InterfaceManager
		 * 
		 * @return	instancia		Unica instancia de la clase StageManager 	
		 */
		public static function getInstance():StageManager
		{
			if (_instance == null)
				_instance = new StageManager(new Singleton());
			return _instance;
		}
		
		/**
		 * Configura la resolucion minima para el redimencionamiento del browser
		 * 
		 * @param	minWidth		Ancho minimo de resolucion para el cual deja de redimencionarse la aplicacion
		 * @param	minHeight		Alto minimo de resolucion para el cual deja de redimencionarse la aplicacion
		 */
		public function config(minWidth:Number, minHeight:Number):void
		{
			_minWidth = minWidth;
			_minHeight = minHeight;
		}
		
		/**
		 * @method
		 * Visualiza la aplicacion a pantalla completa
		 * 
		 * @param	status		Estado de visualizacion de pantalla
		 */
		public function fullScreen(status:String):void
		{			
			_stage.displayState = status;
		}
		
		/**
		 * @method
		 * Adiciona un objeto al escenario
		 * 
		 * @param	idHash			Identificador del objeto en la tabla hash
		 * @param	object			Objeto a almacenar
		 * @param	visualObject	Indica si el objeto debe ser agregado a la lista de visualizacion
		 */
		public function addObject(idHash:String, object:*, visualObject:Boolean = true):void
		{		
			trace("StageManager->addObject()");		
			
			// Agrega un elemento a la tabla hash
			_hashMap.add(idHash, object);
			
			// Posicionando del objeto
			locateObject(object);	
			if (visualObject)
				_stage.addChild((object as InterfaceObject).interactiveObject);	
		}
		
		/**
		 * @method
		 * Elimina un objeto de la lista de visualizacion
		 * 
		 * @param	idHash		Identificador del objeto en la tabla hash
		 */
		public function removeObject(idHash:String):InterfaceObject
		{
			var io:InterfaceObject = getItemAt(idHash) as InterfaceObject;
			_stage.removeChild(io.interactiveObject);
			_hashMap.remove(idHash);
			return io;			
		}
		
		/**
		 * @method
		 * Devuelve un elemento registrado en la tabla hash dado su identificador
		 * 
		 * @param	idHash		Cadena que identifica el elemento en la tabla hash
		 * @return	*			Objeto representado en el escenario
		 */
		public function getItemAt(idHash:String):*
		{
			// Devuelve el objeto asociado a dicha clave
			var object:InterfaceObject = _hashMap.getValue(idHash);
			return object;
		}
		
		/**
		 * @method
		 * Visualiza un objeto, lo agrega a la lista de visualizacion
		 * 
		 * @param	idHash		Identificador del objeto en la tabla hash		 
		 */
		public function visualizeObject(idHash:String):void
		{
			var object:* = _hashMap.getValue(idHash);
			_stage.addChild((object as InterfaceObject).interactiveObject);	
		}			
		
		/**
		 * @method
		 * Posiciona un objeto en el escenario
		 * 
		 * @param	object		Objeto que se posicionara en el escenario
		 */
		public function locateObject(object:*):void
		{
			trace("StageManager->locateObject()");
			
			// Conviertiendo el objeto generico en un InterfaceObject
			var object:InterfaceObject = object as InterfaceObject;				
			
			// Si el objeto no ha sido posicionado la primera vez
			if (!object.positionInitialized) 
			{
				// Actualizando inicializacion de posicionamiento
				object.positionInitialized = true;
				
				// Posiciono el objeto por primera vez
				object.interactiveObject.x = _stage.stageWidth * object.percentageX / 100;
				object.interactiveObject.y = _stage.stageHeight * object.percentageY / 100;
			}
			else
			{
				// Si el objeto tiene especificado que se le haga un cambio de posicion cuando ocurra un redimensionamiento del browser
				if (object.changePositionX)	
					object.interactiveObject.x = _stage.stageWidth * object.percentageX / 100;

				if (object.changePositionY)
					object.interactiveObject.y = _stage.stageHeight * object.percentageY / 100;
			}

			// Si el objeto tiene especificado que se le haga un cambio de tamaño cuando ocurra un redimensionamiento del browser
			if (object.changeSize)
			{
				object.interactiveObject.width = _stage.stageWidth * object.percentageWidth / 100;
				object.interactiveObject.height = _stage.stageHeight * object.percentageHeight / 100;
			}
			
			if (object.centralReference)
			{
				// Variables para el control del calculo
				var position:Number;
				var totalSeparation:Number;					
				var totalWidth:Number;
				
				// Variable para controlar el orden del objeto
				var order:int = object.totalElements - object.elementOrder + 1;
				
				// Si la cantidad de objetos a posicionar es PAR
				if (object.totalElements % 2 == 0)
				{									
					// Calculando posicionamiento
					totalSeparation = ((object.totalElements / 2 - order) * object.separation) + (object.separation / 2);
					totalWidth = ((object.totalElements / 2 - order) * object.interactiveObject.width) + (object.interactiveObject.width / 2);
					position = _stage.stageWidth / 2 + totalSeparation + totalWidth;											
				}
				else	// Si la cantidad de objetos a posicionar es IMPAR
				{
					for (var j:int = object.totalElements; j > 0 ; j--) 
					{
						// Calculando posicionamiento
						totalSeparation = (Math.floor(object.totalElements / 2) - (order - 1)) * object.separation;
						totalWidth = (Math.floor(object.totalElements / 2) - (order - 1)) * object.interactiveObject.width;
						position = _stage.stageWidth / 2 + totalSeparation + totalWidth;	
					}
				}
				
				// Posicionando objeto
				object.interactiveObject.x = position;
				object.interactiveObject.y = _stage.stageHeight * object.yPosition / 100; 			
			}
		}
		
		/**
		 * @event
		 * Se ejecuta cuando se redimensiona el escenario
		 * Ejecuta la funcion actionsForElements() de la clase HashMap, pasandole por parametro la funcion locateObject() de la clase StageManager,
		 * lo que hace que se realicen las acciones establecidas en la funcion locateObject() para cada registro de la clase HashMap
		 * 
		 * @param	evt		Evento 
		 */
		private function onResizeHandler(evt:Event):void
		{
			trace("StageManager->onResizeHandler()");		
			
			 // Comprobando dimensiones minimas
			if ((_minWidth != 0 && _minHeight != 0) && (_stage.stageWidth >= _minWidth && _stage.stageHeight >= _minHeight))
			{
				// Ejecuto acciones para cada registro de la clase HashMap
				_hashMap.actionsForElements(this.locateObject);
			}				
		}
	}
}

/**
 * @singleton
 */
class Singleton{}