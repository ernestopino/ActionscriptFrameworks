package idv.cjcat.stardust.twoD.renderers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.display.AddChildMode;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * This renderer adds display object particles to the target container's display list, 
	 * removes dead particles from the display list, 
	 * and updates the display object's x, y, rotation, scaleX, scaleY, and alpha properties.
	 */
	public class DisplayObjectRenderer extends Renderer {
		
		public var addChildMode:int;
		/**
		 * The target container.
		 */
		public var container:DisplayObjectContainer;
		/**
		 * Whether to change a display object's parent to the target container if the object already belongs to another parent.
		 */
		public var forceParentChange:Boolean;
		
		public function DisplayObjectRenderer(container:DisplayObjectContainer = null, addChildMode:int = 0) {
			this.container = container;
			this.addChildMode = addChildMode;
			forceParentChange = false;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			if (!container) return;
			
			var particle:Particle;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = iter.particle) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				
				if (!forceParentChange) {
					if (displayObj.parent) {
						iter.next();
						continue;
					}
				}
				
				switch (addChildMode) {
					case AddChildMode.RANDOM:
						container.addChildAt(displayObj, Math.floor(Math.random() * container.numChildren));
						break;
					case AddChildMode.TOP:
						container.addChild(displayObj);
						break;
					case AddChildMode.BOTTOM:
						container.addChildAt(displayObj, 0);
						break;
					default:
						container.addChildAt(displayObj, Math.floor(Math.random() * container.numChildren));
						break;
				}
				
				iter.next();
			}
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			var particle:Particle;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = iter.particle) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				if (displayObj.parent) DisplayObjectContainer(displayObj.parent).removeChild(displayObj);
				
				iter.next();
			}
		}
		
		override protected function render(e:EmitterEvent):void {
			var particle:Particle2D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle2D(iter.particle)) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				
				displayObj.x = particle.x;
				displayObj.y = particle.y;
				displayObj.rotation = particle.rotation;
				displayObj.scaleX = displayObj.scaleY = particle.scale;
				displayObj.alpha = particle.alpha;
				
				iter.next();
			}
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "DisplayObjectRenderer";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@addChildMode = addChildMode;
			xml.@forceParentChange = forceParentChange;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@addChildMode.length()) addChildMode = parseInt(xml.@addChildMode);
			if (xml.@forceParentChange.length()) forceParentChange = (xml.@forceParentChange == "true");
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}