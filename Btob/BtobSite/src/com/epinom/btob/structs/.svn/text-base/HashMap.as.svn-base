/**
* ...
* HashMap, Versión AS3.1
* Modelo funcional de un hash map (tabla hash)
* 
* @author 		PollyJex
* @modified     by Ernesto Pino Martínez
*/

package com.epinom.btob.structs
{
	public dynamic class HashMap
	{
		/**
		 * @property
		 * Mantiene el conteo del ingreso de registros
		 */
		private var _recordCount:int = 0;
		
		/**
		 * @property
		 * Identificador de clave (key)
		 */
		private var _idKey:String;
		
		/**
		 * @constructor
		 * Constructor de la clase
		 * 
		 * @param	idLabel		Identificador de la clave
		 */
		public function HashMap(idKey:String = null) 
		{
			// Si el valor pasado por parametro es valido lo asigno a la propiedad _idKey, sino le asigno un valor por defecto ("$key_")
			(idKey == null) ? _idKey = "$key_" : _idKey = idKey;
		}

		/**
		 * @method
		 * Inserta un registro 
		 * 
		 * @param	key		Nombre de la clave
		 * @param	value	Valor	
		 * @return			void
		 */
		public function add(key:String, value:*):void 
		{
			// Agrego una propiedad dinamica y le asigno un valor
			this[resolveKey(key)] = value;
			
			// Aumento el la cantidad de registros
			_recordCount++;
		}
		
		/**
		 * @method
		 * Elimina un registro
		 * 
		 * @param	key 	Nombre de la clave
		 * @return			void
		 */
		public function remove(key:String):void
		{
			// Si existe un registro con dicha clave
			if(containsKey(key))
			{			
				// Elimino el registro
				delete this[resolveKey(key)];
				
				// Disminuyo el contador de registros
				_recordCount--;	
			}			
		}
		
		/**
		 * @method
		 * Verifica si existe la clave
		 * 
		 * @param	key 		Nombre de la clave
		 * @return				Boolean
		 */
		public function containsKey(key:String):Boolean 
		{
			// Si existe un registro con dicha clave retorno true, sino false
			if (this[resolveKey(key)] != undefined) 
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * @method
		 * Verifica si exite el valor
		 * 
		 * @param	value 	Valor
		 * @return			Boolean
		 */
		public function containsValue(value:*):Boolean 
		{	
			// Si existe un registro con dicha valor retorno true, sino false
			if (this[resolveKeyValue(value)] != undefined)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * @method
		 * Retorna la clave asociada al valor
		 * 
		 * @param	value	Valor
		 * @return			String
		 */
		public function getKey(value:*):String 
		{		
			// Retorno la clave sin el identificador del registro cuya valor sea igual a value
			return resolveOriginalKey(resolveKeyValue(value));
			
		}
		
		/**
		 * @method
		 * Retorna el valor asociado a una clave
		 * 
	 	 * @param	key 	Identificador
		 * @return			*
		 */
		public function getValue(key:String):*
		{		
			// Retorno el valor del registro que esta asociado a la clave key
			return this[resolveKey(key)];
		}
		
		/**
		 * @method
		 * Retorna el valor de la cantidad de registros
		 *
		 * @return	int
		 */
		public function recordCount():int 
		{		
			return _recordCount;
		}
		
		/**
		 * @method
		 * Verifica si la mapa hash esta vacio
		 * 
		 * @return	Boolean
		 */
		public function isEmpty():Boolean
		{
			return !_recordCount;
		}
		
		/**
		 * @method
	 	 * Reinicia el registro
 		 *  
		 * @return	void
		 */
		public function clear():void
		{		
			// Si la lista no esta vacia
			if (!isEmpty())
			{			
				// Recorro cada registro del mapa hash
				for (var key:String in this)
				{
					// Si el identificado de clave es parte de esta clave, que siempre va a ser asi, significa que hemos dado con el registro que se quiere eliminar
					if (key.indexOf(_idKey, 0) != -1)
					{
						// Eliminamos dicho registroS
						delete this[key];
					}
				}
				
				// Reiniciamos el contador de registros
				_recordCount = 0;
			}
		}
			
		/**
		 * @method
		 * Devuelve el valor original de la clave eliminanda
		 * 
		 * @param	key		Nombre de la clave
		 * @return			String
		 */
		public function resolveOriginalKey(key:String):String 
		{
			// Si la la clave pasada es parte de la clave de algun registro	
			if(key.indexOf(_idKey, 0) != -1)
			{
				// Devolvemos la clave original sin tener en cuenta el identificador de clave
				return key.substr( _idKey.length);
			}
			
			// Si no existe ningun clave que cumpla lo anterior, devolvemos la propia clave
			return key;
		}
		
		/**
		* @method
		* Resuelve una clave
		* 
		* @param	key		Nombre de la clave
		* @return			String
		*/
		private function resolveKey(key:String):String 
		{
			// El identificador de clave no esta contenido en la clave pasada por parametro
			if (key.indexOf(_idKey, 0) != -1 )
			{
				// Devolvemos dicha clave
				return key;
			}
			
			// Si no se cumple lo anterior, devolvemo la convinacion del identificador con la clave
			return _idKey + key;
		}
		
		/**
		 * @method
		 * Metodo que permite la comprobacion de contenio
		 *	 
		 * @param	value	Valor a buscar
		 * @return	String
		 */
		private function resolveKeyValue(value:*):String
		{
			// Recorro cada registro del mapa hash
			for (var key:String in this)
			{				
				// Si existe algun registro con valor igual al pasado por parametro
				if (this[key] === value) 
				{
					// Retorno dicha clave
					return key;
				}
			}
			
			// Si no se cumple lo anterior, retorno valor que significa que no existe registro con igual valor al pasado por parametro
			return null;	
		}
		
		public function actionsForElements(fActions:Function):void
		{
			// Recorro cada registro del mapa hash
			for (var key:String in this)
			{				
				fActions(this[key]);
			}
		}
	}
}