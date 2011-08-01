package idv.cjcat.stardust.threeD.nd3d.renderers {
	import de.nulldesign.nd3d.objects.Object3D;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	/**
	 * This renderer adds <code>Object3D</code> particles to a render list, 
	 * removes dead particles from the render list, 
	 * and updates the <code>Object3D</code> objects' x, y, z, angleX, angleY, angleZ, scaleX, scaleY, and scaleZ properties.
	 */
	public class ND3DObject3DRenderer extends Renderer {
		
		private var _renderList:Array;
		
		/**
		 * 
		 * @param	renderList  The render list.
		 */
		public function ND3DObject3DRenderer(renderList:Array) {
			_renderList = renderList;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				if (_renderList.indexOf(particle.target) < 0) {
					if (particle.target) {
						_renderList.push(particle.target);
					}
				}
				
				iter.next();
			}
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var index:int;
				if ((index = _renderList.indexOf(particle.target)) > 0) {
					_renderList.splice(index, 1);
				}
				
				iter.next();
			}
		}
		
		override protected function render(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var obj:Object3D = particle.target as Object3D;
				
				obj.xPos = particle.x;
				obj.yPos = particle.y;
				obj.zPos = particle.z;
				obj.angleX = particle.rotationX * StardustMath.DEGREE_TO_RADIAN;
				obj.angleY = particle.rotationY * StardustMath.DEGREE_TO_RADIAN;
				obj.angleZ = particle.rotationZ * StardustMath.DEGREE_TO_RADIAN;
				obj.scaleX = obj.scaleY = obj.scaleZ = particle.scale;
				
				iter.next();
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ND3DObject3DRenderer";
		}
		
		//------------------------------------------------------------------------------------------------$
		//end of XML
	}
}