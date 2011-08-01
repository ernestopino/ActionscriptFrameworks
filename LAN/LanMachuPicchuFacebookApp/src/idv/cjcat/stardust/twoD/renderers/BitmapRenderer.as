package idv.cjcat.stardust.twoD.renderers {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.twoD.particles.Particle2D;
	
	/**
	 * This renderer draws display object particles into a bitmap.
	 */
	public class BitmapRenderer extends Renderer {
		
		/**
		 * The target bitmap to draw display object into.
		 */
		public var targetBitmapData:BitmapData;
		/**
		 * The blend mode for drawing.
		 */
		public var blendMode:String;
		
		public function BitmapRenderer(targetBitmapData:BitmapData = null, blendMode:String = "normal") {
			this.targetBitmapData = targetBitmapData;
			this.blendMode = blendMode;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			//do nothing
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			//do nothing
		}
		
		override protected function render(e:EmitterEvent):void {
			if (!targetBitmapData) return;
			
			targetBitmapData.lock();
			var particle:Particle2D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle2D(iter.particle)) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				
				var mat:Matrix = new Matrix();
				mat.scale(particle.scale, particle.scale);
				mat.rotate(particle.rotation * StardustMath.DEGREE_TO_RADIAN);
				mat.translate(particle.x, particle.y);
				
				targetBitmapData.draw(displayObj, mat, new ColorTransform(1, 1, 1, particle.alpha), blendMode);
				
				iter.next();
			}
			targetBitmapData.unlock();
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "BitmapRenderer";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@blendMode = blendMode;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@blendMode.length()) blendMode = xml.@blendMode;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}