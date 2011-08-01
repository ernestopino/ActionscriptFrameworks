package idv.cjcat.stardust.threeD.zedbox.renderers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	import idv.cjcat.stardust.threeD.zedbox.initializers.ZBDisplayObjectClass;
	import idv.cjcat.zedbox.display.IZedBoxSprite;
	import idv.cjcat.zedbox.display.ZedScene;
	import idv.cjcat.zedbox.display.ZedSprite;
	import idv.cjcat.zedbox.geom.Matrix3D;
	import idv.cjcat.zedbox.geom.Vec3D;
	import idv.cjcat.zedbox.geom.Vec3DPool;
	import idv.cjcat.zedbox.zb;
	
	/**
	 * This renderer adds <code>ZedSprite</code> particles to a  <code>IZedBoxSprite</code> container (either a <code>ZedSprite</code> or a <code>ZedScene</code>), 
	 * removes dead particles from the container, 
	 * and updates the <code>ZedSprite</code> objects' x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY, scaleZ, and alpha properties.
	 * 
	 * @see idv.cjcat.zedbox.IZedBoxSprit
	 * @see idv.cjcat.zedbox.ZedScene
	 * @see idv.cjcat.zedbox.ZedSprite
	 */
	public class ZBDisplayObjectRenderer extends Renderer {
		
		private var _container:IZedBoxSprite;
		
		public function ZBDisplayObjectRenderer(container:IZedBoxSprite = null) {
			this.container = container;
		}
		
		public function get container():IZedBoxSprite { return _container; }
		public function set container(value:IZedBoxSprite):void {
			if (!value) value = new ZedScene();
			_container = value;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			if (!container) return;
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var zedSprite:ZedSprite = particle.target as ZedSprite;
				
				container.addChild(zedSprite);
				
				iter.next();
			}
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var zedSprite:ZedSprite = particle.target as ZedSprite;
				var displayObj:DisplayObject = DisplayObject(particle.dictionary[ZBDisplayObjectClass]);
				
				IZedBoxSprite(zedSprite.parent).removeChild(zedSprite);
				IZedBoxSprite(displayObj.parent).removeChild(displayObj);
				
				iter.next();
			}
		}
		
		override protected function render(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				renderZedSprite(particle);
				
				iter.next();
			}
		}
		
		private var _zedSprite:ZedSprite;
		private var _displayObj:DisplayObject;
		private var _scene:ZedScene;
		private var _vel:Vec3D;
		private function renderZedSprite(particle:Particle3D):void {
			_zedSprite = particle.target as ZedSprite;
			//if (!zedSprite) return;
			
			_displayObj = DisplayObject(particle.dictionary[ZBDisplayObjectClass]);
			
			_zedSprite.x = particle.x;
			_zedSprite.y = particle.y;
			_zedSprite.z = particle.z;
			_displayObj.scaleX = _displayObj.scaleY = particle.scale;
			_displayObj.rotation = particle.rotationZ;
			_displayObj.alpha = particle.alpha;
			
			//scene velocity
			_scene = _zedSprite.zb::superParent as ZedScene;
			if (_scene) {
				_vel = Vec3DPool.get(particle.vx, particle.vy, particle.vz);
				_zedSprite.zb::_flatMatrix.transformThisVecWithoutTranslation(_vel);
				_scene.zb::cameraMatrix.transformThisVec(_vel);
				particle.screenVX = _vel.x;
				particle.screenVY = _vel.y;
				Vec3DPool.recycle(_vel);
			}
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "ZBDisplayObjectRenderer";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}