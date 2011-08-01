/**
 * ...
 * Component
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 20/09/2010
 */

package com.epinom.lan.dakar.ui
{
	import com.epinom.lan.dakar.managers.MainManager;
	import com.epinom.lan.dakar.vo.ComponentVO;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class Component extends Sprite
	{	
		/**
		 * @property
		 * Objeto de datos con la configuracion del objeto visual
		 */
		private var _vo:ComponentVO;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */
		public function Component(vo:ComponentVO)
		{
			super();
			this.vo = vo;
		}
		
		/**
		 * @PUBLIC METHODS
		 * Funciones publicas de la clase
		 */
		
		/**
		 * @method
		 * Getters y Setters
		 */
		public function get vo():ComponentVO { return _vo; }
		public function set vo(value:ComponentVO):void { _vo = value; }
		
		/**
		 * @method
		 * Adicionan un nuevo objeto visual al contenedor
		 * Para utilizar este metodo, primero debe ser agregado el objeto al escenario, puesto que en caso opuesto la referencia al stage seria null
		 */ 
		public override function addChild(child:DisplayObject):DisplayObject
		{
			// Si el objeto tiene especificado que se le haga un cambio de posicion
			if (_vo.changePositionX)	
				child.x = stage.stageWidth * _vo.percentageX / 100;			
			if (_vo.changePositionY)
				child.y = stage.stageHeight * _vo.percentageY / 100;
			
			// Adicionando objeto
			return super.addChild(child);
		}
	}
}