package idv.cjcat.stardust.threeD.initializers {
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.utils.construct;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	/**
	 * Assign a display object to the <code>target</code> properties of a particle. 
	 * This information can be visualized by <code>DisplayObjectRenderer3D</code>.
	 * 
	 * @see idv.cjcat.stardust.threeD.renderers.DisplayObjectRenderer3D
	 */
	public class DisplayObjectClass3D extends Initializer3D {
		
		public var displayObjectClass:Class;
		public var constructorParams:Array;
		public function DisplayObjectClass3D(displayObjectClass:Class = null, constructorParams:Array = null) {
			this.displayObjectClass = displayObjectClass;
			this.constructorParams = constructorParams;
		}
		
		override public function initialize(p:Particle):void {
			if (!displayObjectClass) return;
			p.target = construct(displayObjectClass, constructorParams);
		}
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "DisplayObjectClass3D";
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}