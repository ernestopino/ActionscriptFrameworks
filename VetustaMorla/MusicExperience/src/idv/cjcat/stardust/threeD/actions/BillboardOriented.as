﻿package idv.cjcat.stardust.threeD.actions {
	import flash.display.DisplayObject;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	/**
	 * Causes particles' rotation to align to their velocities.
	 * 
	 * <p>
	 * For native Stardust 3D engine only.
	 * </p>
	 */
	public class BillboardOriented extends Action3D {
		
		/**
		 * How fast the particles align to their velocities, 1 by default.
		 * 
		 * <p>
		 * 1 means immediate alignment. 0 means no alignment at all.
		 * </p>
		 */
		public var factor:Number;
		/**
		 * The rotation angle offset in degrees.
		 */
		public var offset:Number;
		public function BillboardOriented(factor:Number = 1, offset:Number = 0) {
			this.factor = factor;
			this.offset = offset;
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p3D:Particle3D = Particle3D(particle);
			var displacement:Number = (Math.atan2(p3D.screenVX, -p3D.screenVY) * StardustMath.RADIAN_TO_DEGREE + offset) - p3D.rotationZ;
			p3D.rotationZ += factor * displacement;
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "BillboardOriented";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@factor = factor;
			xml.@offset = offset;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@factor.length()) factor = parseFloat(xml.@factor);
			if (xml.@offset.length()) offset = parseFloat(xml.@offset);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}