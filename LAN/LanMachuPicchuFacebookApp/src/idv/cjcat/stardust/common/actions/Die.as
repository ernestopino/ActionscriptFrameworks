package idv.cjcat.stardust.common.actions {
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Instantly marks a particle as dead.
	 * 
	 * <p>
	 * This action should be used with action triggers. 
	 * If this action is directly added to an emitter, all particles will be marked dead upon birth.
	 * </p>
	 */
	public class Die extends Action {
		
		public function Die() {
			
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			particle.isDead = true;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Die";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}