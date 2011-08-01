/**
* ...
* InterfaceObject, Versión AS3.2
* Representa un objeto visualizado en pantalla
* 
* @author Ernesto Pino Martínez
* @version v07/12/2008 23:07
*/

package com.epinom.vetusta.musicexperience.vos
{
	/**
	 * @import
	 */
	import flash.display.DisplayObject;
	
	public class InterfaceObject
	{
		/**
		 * @property
		 * Objeto que se quiere reposicionar cuando se redimensiona el escenario principal	
		 */
		private var _interactiveObject:DisplayObject;
		
		/**
		 * @property
		 * Especifica si al objeto se le ha inicializado su posicion
		 */
		private var _positionInitialized:Boolean;
		
		/**
		 * @property
		 * Identificador de clase del objeto	
		 */
		private var _className:String;
		
		/**
		 * @property
		 * Nombre de instancia
		 */
		private var _instanceName:String;
		
		/**
		 * @property
		 * Identificador de objeto Hash
		 */
		private var _hashId:String;
		
		/**
		 * @property
		 * Valor boleano que indica cambio de tamaño del objeto
		 */
		private var _changeSize:Boolean;
		
		/**
		 * @property
		 * Ancho porcentual del objeto con respecto al ancho del escenario
		 */
		private var _percentageWidth:Number;
		
		/**
		 * @property
		 * Alto porcentual del objeto con respecto al ancho del escenario
		 */
		private var _percentageHeight:Number;
		
		/**
		 * @property
		 * Valor boleano que indica cambio de la posicion del objeto en el eje de las X
		 */
		private var _changePositionX:Boolean;
		
		/**
		 * @property
		 * Valor boleano que indica cambio de la posicion del objeto en el eje de las Y
		 */
		private var _changePositionY:Boolean;
		
		/**
		 * @property
		 * X porcentual del objeto
		 */
		private var _percentageX:Number;
		
		/**
		 * @property
		 * Y porcentual del objeto
		 */
		private var _percentageY:Number;
		
		/**
		 * @property
		 * Valor booleano que indica Referencia Central
		 */
		private var _centralReference:Boolean;
		
		/**
		 * @property
		 * Valor que indica la orden del elemento
		 */
		private var _elementOrder:int;
		
		/**
		 * @property
		 * Valor que indica la posicion del elemento en el eje Y
		 */
		private var _yPosition:Number;
		
		/**
		 * @property
		 * Valor que indica la separacion entre elementos con referencia central activada
		 */
		private var _separation:Number;
		
		/**
		 * @property
		 * Valor que indica la cantidad de elementos con referencia central activada
		 */
		private var _totalElements:int;
		
		/**
		 * @property
		 * Valor boleano que indica separacion porcentual
		 */
		private var _percentagePadding:Boolean;
		
		/**
		 * @property
		 * Valor de la separacion superior
		 */
		private var _paddingTop:Number;
		
		/**
		 * @property
		 * Valor de la separacion inferior
		 */
		private var _paddingBottom:Number;
		
		/**
		 * @property
		 * Valor de la separacion izquierda
		 */
		private var _paddingLeft:Number;
		
		/**
		 * @property
		 * Valor de la separacion derecha
		 */
		private var _paddingRight:Number;
		
		/**
		  * @constructor
		  * Constructor de la clase
		  * 
		  * @param	object					Instancia de una de las subclase de InteractiveObject que se quiere reposicionar cuando se redimensione el escenario principal		 
		  * @param	className 				Identificador de clase del objeto
		  * @param	instanceName			Nombre de instancia
		  * @param  hashId					Identificador Hash
		  * @param	changeSize				Indica si el objeto cambia de posicion cuando se redimenciona el escenario	
		  * @param  percentageWidth			Ancho porcentual del objeto con respecto al ancho el escenario
		  * @param  percentageHeight		Alto porcentual del objeto con respecto al ancho el escenario
		  * @param	changePositionX			Indica si el objeto cambia de tamaño cuando se redimenciona el escenario en el eje de las X
		  * @param	changePositionY			Indica si el objeto cambia de tamaño cuando se redimenciona el escenario en el eje de las Y
		  * @param 	percentageX				X porcentual del objeto
		  * @param  percentageY				Y porcentual del objeto
		  * @param	centralReference		Indica si esta activado el centrado referencial
		  * @param	elementOrder			Orden del elemento
		  * @param	yPosition				Posion en el eje Y
		  * @param	separation				Separacion entre elementos con centrado referencial
		  * @param	totalElements			Total de elementos con centrado referencial activado
		  * @param  percentagePadding		Valor boleano que indica separacion porcentual
		  * @param	paddingTop				Separacion superior
		  * @param	paddingBottom			Separacion inferior
		  * @param	paddingLeft				Separacion izquierda
		  * @param	paddingRight			Separacion derecha
		  */
		public function InterfaceObject(object:DisplayObject, className:String, instanceName:String, hashId:String, changeSize:Boolean, percentageWidth:Number, percentageHeight:Number, 
										changePositionX:Boolean, changePositionY:Boolean, percentageX:Number, percentageY:Number, centralReference:Boolean = false, elementOrder:int = -1, yPosition:Number = -1, separation:Number = -1, 
										totalElements:int = -1, percentagePadding:Boolean = false, paddingTop:Number = -1, paddingBottom:Number = -1, paddingLeft:Number = -1, paddingRight:Number = -1)
		{
			// Inicializando propiedades
			_interactiveObject = object;
			_positionInitialized = false;
			_className = className;
			_instanceName = instanceName;
			_hashId = hashId;
			_changeSize = changeSize;
			_percentageWidth = percentageWidth;
			_percentageHeight = percentageHeight;
			_changePositionX = changePositionX;
			_changePositionY = changePositionY;
			_percentageX = percentageX;
			_percentageY = percentageY;
			_centralReference = centralReference;
			_elementOrder = elementOrder;
			_yPosition = yPosition;
			_separation = separation;
			_totalElements = totalElements;			
			_percentagePadding = percentagePadding;
			_paddingTop = paddingTop;
			_paddingBottom = paddingBottom;
			_paddingLeft = paddingLeft;
			_paddingRight = paddingRight;
		}
		
		/**
		 * @getter
		 * Devuelve una referencia al objeto interactivo
		 * 
		 * @return	interactiveObject
		 */
		public function get interactiveObject():DisplayObject
		{
			return _interactiveObject;
		}
		
		/**
		 * @getter
		 * Devuelve una referencia al objeto interactivo
		 * 
		 * @return	interactiveObject
		 */
		public function set interactiveObject(value:DisplayObject):void
		{
			_interactiveObject = value;
		}
		
		/**
		 * @getter
		 * Devuelve si la posicion del objeto ha sido inicializada
		 * 
		 * @return	positionInitialized
		 */
		public function get positionInitialized():Boolean
		{
			return _positionInitialized;
		}
		
		/**
		 * @setter
		 * Cambia el valor de la inicializacion de posicion del objeto
		 * 
		 * @param value		Nuevo valor
		 */
		public function set positionInitialized(value:Boolean):void
		{
			_positionInitialized = value;
		}
		
		/**
		 * @getter
		 * Devuelve el identificador de clase del objeto
		 * 
		 * @return	className
		 */
		public function get className():String
		{
			return _className;
		}			
		
		/**
		 * @setter
		 * Configura el identificador de clase del objeto
		 * 
		 * @param	className
		 */
		public function set className(className:String):void
		{
			_className = className;
		}
		
		/**
		 * @getter
		 * Devuelve el nombre de instancia del objeto
		 * 
		 * @return	instanceName
		 */
		public function get instanceName():String
		{
			return _instanceName;
		}
		
		/**
		 * @setter
		 * Configura el nombre de instancia del objeto
		 * 
		 * @param	instanceName
		 */
		public function set instanceName(instanceName:String):void
		{
			_instanceName = instanceName;
		}
		
		/**
		 * @getter
		 * Devuelve el identificador hash del objeto
		 * 
		 * @return	hashId
		 */
		public function get hashId():String
		{
			return _hashId;
		}
		
		/**
		 * @setter
		 * Configura el identificador hash del objeto
		 * 
		 * @param	hashId
		 */
		public function set hashId(hashId:String):void
		{
			_hashId = hashId;
		}
		
		/**
		 * @getter
		 * Devuelve el valor boleano que indica cambio de tamaño del objeto
		 * 
		 * @return	changeSize
		 */
		public function get changeSize():Boolean
		{
			return _changeSize;
		}
		
		/**
		 * @setter
		 * Configura el valor boleano que indica cambio de tamaño del objeto
		 * 
		 * @param	changeSize
		 */
		public function set changeSize(changeSize:Boolean):void
		{
			_changeSize = changeSize;
		}
		
		/**
		 * @getter
		 * Devuelve el ancho porcentual del objeto con respecto al ancho del escenario
		 * 
		 * @return	percentageWidth
		 */
		public function get percentageWidth():Number
		{
			return _percentageWidth;
		}
		
		/**
		 * @setter
		 * Configura el ancho porcentual del objeto con respecto al ancho del escenario
		 * 
		 * @param	changeSize
		 */
		public function set percentageWidth(percentageWidth:Number):void
		{
			_percentageWidth = percentageWidth;
		}
		
		/**
		 * @getter
		 * Devuelve el alto porcentual del objeto con respecto al ancho del escenario
		 * 
		 * @return	percentageHeight
		 */
		public function get percentageHeight():Number
		{
			return _percentageHeight;
		}
		
		/**
		 * @setter
		 * Configura el alto porcentual del objeto con respecto al ancho del escenario
		 * 
		 * @param	percentageHeight
		 */
		public function set percentageHeight(percentageHeight:Number):void
		{
			_percentageHeight = percentageHeight;
		}
				
		/**
		 * @getter
		 * Devuelve el valor boleano que indica cambio de posicion del objeto  en el eje de las X
		 * 
		 * @return	changePosition
		 */
		public function get changePositionX():Boolean
		{
			return _changePositionX;
		}
		
		/**
		 * @setter
		 * Configura el valor boleano que indica cambio de posicion del objeto en el eje de las X
		 * 
		 * @param	changePosition
		 */
		public function set changePositionX(changePositionX:Boolean):void
		{
			_changePositionX = changePositionX;
		}
		
		/**
		 * @getter
		 * Devuelve el valor boleano que indica cambio de posicion del objeto en el eje de las Y
		 * 
		 * @return	changePositionY
		 */
		public function get changePositionY():Boolean
		{
			return _changePositionY;
		}
		
		/**
		 * @setter
		 * Configura el valor boleano que indica cambio de posicion del objeto en el eje de las Y
		 * 
		 * @param	changePositionY
		 */
		public function set changePositionY(changePositionY:Boolean):void
		{
			_changePositionY = changePositionY;
		}
		
		/**
		 * @getter
		 * Devuelve la X porcentual del objeto
		 * 
		 * @return	percentageX
		 */
		public function get percentageX():Number
		{
			return _percentageX;
		}
		
		/**
		 * @setter
		 * Configura la X porcentual del objeto
		 * 
		 * @param	percentageX
		 */
		public function set percentageX(percentageX:Number):void
		{
			_percentageX = percentageX;
		}
		
		/**
		 * @getter
		 * Devuelve la Y porcentual del objeto
		 * 
		 * @return	percentageY
		 */
		public function get percentageY():Number
		{
			return _percentageY;
		}
		
		/**
		 * @setter
		 * Configura la Y porcentual del objeto
		 * 
		 * @param	percentageY
		 */
		public function set percentageY(percentageY:Number):void
		{
			_percentageY = percentageY;
		}
		
		/**
		 * @getter
		 * Indica si el objeto tiene activado el centrado referencial
		 * 
		 * @return	_centralReference
		 */
		public function get centralReference():Boolean
		{
			return _centralReference;
		}
		
		/**
		 * @setter
		 * Configura el centrado referencial del objeto
		 * 
		 * @param	centralReference
		 */
		public function set centralReference(centralReference:Boolean):void
		{
			_centralReference = centralReference;
		}
		
		/**
		 * @getter
		 * Devuelve el orden del elemento con propiedad de centrado referencial activada
		 * 
		 * @return	_elementOrder
		 */
		public function get elementOrder():int
		{
			return _elementOrder;
		}
		
		/**
		 * @setter
		 * Configura el orden del objeto con centrado referencial
		 * 
		 * @param	elementOrder
		 */
		public function set elementOrder(elementOrder:int):void
		{
			_elementOrder = elementOrder;
		}
		
		/**
		 * @getter
		 * Devuelve el valor de posicion del elemento para el eje Y
		 * 
		 * @return	_yPosition
		 */
		public function get yPosition():Number
		{
			return _yPosition;
		}
		
		/**
		 * @setter
		 * Configura el valor de posicion del elemento para el eje Y
		 * 
		 * @param	yPosition
		 */
		public function set yPosition(yPosition:Number):void
		{
			_yPosition = yPosition;
		}
		
		/**
		 * @getter
		 * Devuelve la separacion entre objetos con propiedad de centrado referencial activado
		 * 
		 * @return	_separation
		 */
		public function get separation():Number
		{
			return _separation;
		}
		
		/**
		 * @setter
		 * Configura la separacion entre objetos con propiedad de centrado referencial activado
		 * 
		 * @param	separation
		 */
		public function set separation(separation:Number):void
		{
			_separation = separation;
		}
		
		/**
		 * @getter
		 * Devuelve la cantidad de objetos con propiedad de centrado referencial activado
		 * 
		 * @return	_totalElements
		 */
		public function get totalElements():int
		{
			return _totalElements;
		}
		
		/**
		 * @setter
		 * Configura la cantidad de objetos con propiedad de centrado referencial activado
		 * 
		 * @param	totalElements
		 */
		public function set totalElements(totalElements:int):void
		{
			_totalElements = totalElements;
		}
		
		/**
		 * @getter
		 * Devuelve el valor boleano que indica separacion porcentual
		 * 
		 * @return	percentagePadding
		 */
		public function get percentagePadding():Boolean
		{
			return _percentagePadding;
		}
		
		/**
		 * @setter
		 * Configura el valor boleano que indica separacion porcentual
		 * 
		 * @param	percentagePadding
		 */
		public function set percentagePadding(percentagePadding:Boolean):void
		{
			_percentagePadding = percentagePadding;
		}
		
		/**
		 * @getter
		 * Devuelve el valor de separacion superior
		 * 
		 * @return	paddingTop
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * @setter
		 * Configura el valor de separacion superior
		 * 
		 * @param	paddingTop
		 */
		public function set paddingTop(paddingTop:Number):void
		{
			_paddingTop = paddingTop;
		}
		
		/**
		 * @getter
		 * Devuelve el valor de separacion inferior
		 * 
		 * @return	paddingBottom
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * @setter
		 * Configura el valor de separacion inferior
		 * 
		 * @param	paddingBottom
		 */
		public function set paddingBottom(paddingBottom:Number):void
		{
			_paddingBottom = paddingBottom;
		}
		
		/**
		 * @getter
		 * Devuelve el valor de separacion izquierda
		 * 
		 * @return	paddingLeft
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * @setter
		 * Configura el valor de separacion izquierda
		 * 
		 * @param	paddingLeft
		 */
		public function set paddingLeft(paddingLeft:Number):void
		{
			_paddingLeft = paddingLeft;
		}
		
		/**
		 * @getter
		 * Devuelve el valor de separacion derecha
		 * 
		 * @return	paddingRight
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		/**
		 * @setter
		 * Configura el valor de separacion derecha
		 * 
		 * @param	paddingRight
		 */
		public function set paddingRight(paddingRight:Number):void
		{
			_paddingRight = paddingRight;
		}
	}
}