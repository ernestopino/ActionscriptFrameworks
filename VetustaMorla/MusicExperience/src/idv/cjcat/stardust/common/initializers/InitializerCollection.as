package idv.cjcat.stardust.common.initializers {
	import flash.events.Event;
	import idv.cjcat.stardust.common.events.InitializerEvent;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This class is used internally by classes that implements the <code>InitializerCollector</code> interface.
	 */
	public class InitializerCollection implements InitializerCollector {
		
		/** @private */
		sd var initializers:Array;
		
		public function InitializerCollection() {
			initializers = [];
		}
		
		public final function addInitializer(initializer:Initializer):void {
			if (initializers.indexOf(initializer) < 0) initializers.push(initializer);
			initializer.addEventListener(InitializerEvent.PRIORITY_CHANGE, sortInitializers);
			sortInitializers();
		}
		
		public final function removeInitializer(initializer:Initializer):void {
			var index:int;
			if ((index = initializers.indexOf(initializer)) >= 0) {
				var initializer:Initializer = Initializer(initializers.splice(index, 1)[0]);
				initializer.removeEventListener(InitializerEvent.PRIORITY_CHANGE, sortInitializers);
			}
		}
		
		public final function sortInitializers(e:Event = null):void {
			initializers.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
		}
		
		public final function clearInitializers():void {
			for each (var initializer:Initializer in initializers) removeInitializer(initializer);
		}
	}
}