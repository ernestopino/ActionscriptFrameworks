/**
 * ...
 * MainManager, versión AS3
 * Conecta el fichero principal (main.swf), con la logica de la aplicacion (clases)
 * 
 * @author Ernesto Pino Martínez
 * @date 10/09/2010
 */

package com.epinom.btob.managers
{
	import flash.display.Sprite;
	
	public class MainManager extends Sprite
	{
		public function MainManager()
		{
			super();
			trace("MainManager");
			SiteManager.getInstance(this.stage);
		}
	}
}