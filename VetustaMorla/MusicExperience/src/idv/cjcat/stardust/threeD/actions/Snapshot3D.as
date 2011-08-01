package idv.cjcat.stardust.threeD.actions  {
	import flash.events.Event;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.threeD.actions.Action3D;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	/**
	 * Takes a "snapshot" of the current particle states upon the <code>takeSnapshot3D</code> method call. 
	 * The particle states can be later restored using the <code>Snapshot3DRestore</code> class.
	 * 
	 * @see idv.cjcat.stardust.threeD.actions.SnapshotRestore3D
	 */
	public class Snapshot3D extends Action3D {
		
		public function Snapshot3D() {
			
		}
		
		public function takeSnapshot3D(e:Event = null):void {
			_snapshotTaken = false;
		}
		
		private var _snapshotTaken:Boolean = true;
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p3D:Particle3D = Particle3D(particle);
			
			if (_snapshotTaken) {
				skipThisAction = true;
				return;
			}
			
			p3D.dictionary[Snapshot3D] = new SnapshotData3D(p3D);
		}
		
		override public function postUpdate(emitter:Emitter, time:Number):void {
			if (!_snapshotTaken) _snapshotTaken = true;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Snapshot3D";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}