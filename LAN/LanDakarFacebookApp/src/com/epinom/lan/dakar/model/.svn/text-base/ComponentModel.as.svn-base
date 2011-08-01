/**
 * ...
 * DataModel
 * Modelo de componentes de la aplicacion
 * 
 * @author Ernesto Pino Martínez
 * @date 20/10/2010
 */

package com.epinom.lan.dakar.model
{
	import com.epinom.lan.dakar.ui.Component;
	import com.epinom.lan.dakar.structs.HashMap;

	public class ComponentModel
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:ComponentModel = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 
		
		/**
		 * @property
		 * Tabla Hash para los componentes de la aplicacion
		 */
		private var _componentHashMap:HashMap;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */
		public function ComponentModel()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciacion fallida: Use ComponentModel.getInstance() para crar una nueva instancia.");				
			} else {				
				_componentHashMap = new HashMap();
			}
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LanDakarFacebookTabManager
		 * 
		 * @return	instancia	Unica instancia de la clase LanDakarFacebookTabManager 	
		 */
		public static function getInstance():ComponentModel
		{
			if(_instance == null)
			{
				_allowInstantiation = true;
				_instance = new ComponentModel();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * @method
		 * Adicionan un nuevo objeto visual a la lista de componentes
		 */ 
		public function addComponent(component:Component):void {
			_componentHashMap.add(component.vo.hashId, component);
		}
		
		/**
		 * @method
		 * Adicionan un nuevo objeto visual a la lista de componentes
		 */ 
		public function getComponent(key:String):Component {
			return _componentHashMap.getValue(key);
		}
		
	}
}