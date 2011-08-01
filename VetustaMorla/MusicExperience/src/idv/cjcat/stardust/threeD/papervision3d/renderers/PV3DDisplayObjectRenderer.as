package idv.cjcat.stardust.threeD.papervision3d.renderers {
	import flash.display.Sprite;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.papervision3d.initializers.PV3DDisplayObjectClass;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	import org.papervision3d.core.geom.Particles;
	import org.papervision3d.core.geom.renderables.Particle;
	
	/**
	 * This renderer adds <code>particle</code> object to a <code>particles</code> object, 
	 * removes dead particles from the <code>particles</code> object, 
	 * and updates the <code>Particle</code> objects' x, y, z, rotationZ, and size properties.
	 * 
	 * @see org.papervision3d.core.geom.Particles
	 * @see org.papervision3d.core.geom.renderables.Particle
	 */
	public class PV3DDisplayObjectRenderer extends Renderer {
		
		private var particleContainer:Particles;
		
		public function PV3DDisplayObjectRenderer(particleContainer:Particles = null) {
			this.particleContainer = particleContainer;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			if (!particleContainer) return;
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var p:org.papervision3d.core.geom.renderables.Particle
					= particle.target as org.papervision3d.core.geom.renderables.Particle;
				
				particleContainer.addParticle(p);
				particle.dictionary[PV3DDisplayObjectRenderer] = particleContainer;
				
				iter.next();
			}
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var p:org.papervision3d.core.geom.renderables.Particle
					= particle.target as org.papervision3d.core.geom.renderables.Particle;
				var container:Particles = particle.dictionary[PV3DDisplayObjectRenderer];
				
				container.removeParticle(p);
				
				iter.next();
			}
		}
		
		override protected function render(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var p:org.papervision3d.core.geom.renderables.Particle =
					particle.target as org.papervision3d.core.geom.renderables.Particle;
				
				p.x = particle.x;
				p.y = particle.y;
				p.z = particle.z;
				p.rotationZ = particle.rotationZ;
				p.size = particle.scale;
				Sprite(particle.dictionary[PV3DDisplayObjectClass]).getChildAt(0).alpha = particle.alpha;
				
				iter.next();
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "PV3DDisplayObjectRenderer";
		}
		
		//------------------------------------------------------------------------------------------------$
		//end of XML
	}
}