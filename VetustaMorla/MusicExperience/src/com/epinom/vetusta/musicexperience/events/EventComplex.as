/**
* ...
* EventComplex, Versión AS3.1
* Representa un evento complejo personlizable, incluye un atributo "data" por si es necesario pasar datos con el evento despachado.
* 
* @author Ernesto Pino Martínez
* @version v06/12/2008 21:32
*/

package com.epinom.vetusta.musicexperience.events
{
	/**
	 * @import
	 */
	import flash.events.Event
	
	public class EventComplex extends Event
	{	
		/**
		 * @property
		 * Datos del objeto emisor
		 */
		private var _data:Object;
		
		/**
		 * @constructor
		 * Constructor de la clase
		 * 
		 * @param	type			Tipo de evento
		 * @param 	data			Datos del evento emisor
		 * @param	bubbles			Indica si un evento es un evento de propagación.
		 * @param	cancelable		Indica si se puede evitar el comportamiento asociado al evento.
		 */
		public function EventComplex(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			// Inicializando constructor de la clase Event
			super(type, bubbles, cancelable);
			
			// Si el parametro "data" tiene valor es almacenado, sino se crea un objeto nuevo
			(data) ? _data = data : _data = new Object();
		}	
		
		/**
		 * Devuelve el objeto de datos del evento
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * Configura el objeto de datos del evento
		 */
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}