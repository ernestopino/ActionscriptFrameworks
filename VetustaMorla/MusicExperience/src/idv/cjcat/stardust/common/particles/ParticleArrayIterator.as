package idv.cjcat.stardust.common.particles {
	
	public class ParticleArrayIterator implements ParticleIterator {
		
		/** @private */
		internal var index:int;
		/** @private */
		internal var array:ParticleArray;
		
		public function ParticleArrayIterator(array:ParticleArray) {
			this.array = array;
			reset();
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset():void {
			if (array) index = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function next():void {
			if (index < array.array.length) index++;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get particle():Particle {
			if (index == array.array.length) return null;
			return array.array[index];
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove():void {
			if (array.array[index]) {
				array.array.splice(index, 1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function clone():ParticleIterator {
			var iter:ParticleArrayIterator = new ParticleArrayIterator(array);
			iter.index = index;
			return iter;
		}
		
		/**
		 * @inheritDoc
		 */
		public function dump(target:ParticleIterator):ParticleIterator {
			var iter:ParticleArrayIterator = ParticleArrayIterator(target);
			if (iter) {
				iter.array = array;
				iter.index = index;
			}
			return target;
		}
	}
}