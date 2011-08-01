package idv.cjcat.stardust.common.actions.triggers {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.emitters.Emitter;
	
	/**
	 * This action trigger will be triggered if a particle is dead.
	 */
	public class DeathTrigger extends ActionTrigger {
		
		public function DeathTrigger() {
			
		}
		
		override public function testTrigger(emitter:Emitter, particle:Particle, time:Number):Boolean {
			return particle.isDead;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "DeathTrigger";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}