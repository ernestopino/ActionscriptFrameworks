package idv.cjcat.stardust.twoD.events {
	import flash.events.Event;
	import idv.cjcat.stardust.twoD.actions.SnapshotRestore;
	
	public class SnapshotRestoreEvent extends Event {
		
		public static const COMPLETE:String = "stardustSnapshotRestoreComplete";
		
		public function SnapshotRestoreEvent(type:String) {
			super(type);
		}
	}
}