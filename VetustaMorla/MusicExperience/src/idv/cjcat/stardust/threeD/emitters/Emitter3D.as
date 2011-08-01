package idv.cjcat.stardust.threeD.emitters {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.particles.ParticleList;
	import idv.cjcat.stardust.common.particles.PooledParticleList;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	import idv.cjcat.stardust.threeD.particles.PooledParticle3DFactory;
	
	use namespace sd;
	
	/**
	 * 2D Emitter.
	 */
	public class Emitter3D extends Emitter {
		
		public function Emitter3D(clock:Clock = null) {
			super(clock);
			factory = new PooledParticle3DFactory();
			_particles = new PooledParticleList(ParticleList.THREE_D);
		}
		
		override public final function addAction(action:Action):void {
			if (!action.supports3D) {
				throw new IllegalOperationError("This action does not support 3D: " + getQualifiedClassName(Object(action).constructor as Class));
			}
			super.addAction(action);
		}
		
		override public final function addInitializer(initializer:Initializer):void {
			if (!initializer.supports3D) {
				throw new IllegalOperationError("This initializer does not support 3D: " + getQualifiedClassName(Object(initializer).constructor as Class));
			}
			super.addInitializer(initializer);
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Emitter3D";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}