package idv.cjcat.stardust.common.actions {
	import flash.events.Event;
	import idv.cjcat.stardust.common.events.ActionEvent;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This class is used internally by classes that implements the <code>ActionCollector</code> interface.
	 */
	public class ActionCollection implements ActionCollector {
		
		/** @private */
		sd var actions:Array;
		
		public function ActionCollection() {
			actions = [];
		}
		
		public final function addAction(action:Action):void {
			actions.push(action);
			action.addEventListener(ActionEvent.PRIORITY_CHANGE, sortActions);
			sortActions();
		}
		
		public final function removeAction(action:Action):void {
			var index:int;
			while ((index = actions.indexOf(action)) >= 0) {
				var action:Action = Action(actions.splice(index, 1)[0]);
				action.removeEventListener(ActionEvent.PRIORITY_CHANGE, sortActions);
			}
		}
		
		public final function clearActions():void {
			for each (var action:Action in actions) removeAction(action);
		}
		
		public final function sortActions(e:Event = null):void {
			actions.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
		}
	}
}