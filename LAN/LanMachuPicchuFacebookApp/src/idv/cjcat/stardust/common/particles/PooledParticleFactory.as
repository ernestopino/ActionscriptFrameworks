package idv.cjcat.stardust.common.particles {
	import idv.cjcat.stardust.common.initializers.Initializer;
	
	/** @private */
	public class PooledParticleFactory extends ParticleFactory {
		
		protected var particlePool:ParticlePool;
		
		public function PooledParticleFactory() {
			particlePool = ParticlePool.getInstance();
		}
		
		override protected function createNewParticle():Particle {
			return particlePool.get();
		}
		
		public function recycle(particle:Particle):void {
			particlePool.recycle(particle);
		}
	}
}