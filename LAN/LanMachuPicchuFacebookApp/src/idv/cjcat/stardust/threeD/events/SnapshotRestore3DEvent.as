package idv.cjcat.stardust.threeD.events {
	import flash.events.Event;
	import idv.cjcat.stardust.threeD.actions.SnapshotRestore3D;
	
	public class SnapshotRestore3DEvent extends Event {
		
		public static const COMPLETE:String = "stardustSnapshotRestore3DComplete";
		
		public function SnapshotRestore3DEvent(type:String) {
			super(type);
		}
	}
}