package idv.cjcat.stardust.common.particles {
	
	public class ParticleArray implements ParticleCollection {
		
		/** @private */
		internal var array:Array = [];
		
		public function ParticleArray() {
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function add(particle:Particle):void {
			array.push(particle);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():ParticleIterator {
			return new ParticleArrayIterator(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function sort():void {
			array.sortOn("x", Array.NUMERIC);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int {
			return array.length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear():void {
			array = [];
		}
	}
}