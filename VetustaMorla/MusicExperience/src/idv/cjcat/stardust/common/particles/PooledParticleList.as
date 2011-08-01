package idv.cjcat.stardust.common.particles {
	
	/** @private */
	public class PooledParticleList extends ParticleList {
		
		public function PooledParticleList(particleType:Boolean = ParticleList.TWO_D) {
			super(particleType);
		}
		
		override protected function createNode(particle:Particle):ParticleNode {
			return ParticleNodePool.get(particle);
		}
	}
}