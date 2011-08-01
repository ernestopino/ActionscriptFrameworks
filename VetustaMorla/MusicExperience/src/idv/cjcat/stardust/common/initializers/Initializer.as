package idv.cjcat.stardust.common.initializers {
	import flash.events.Event;
	import idv.cjcat.stardust.common.events.InitializerEvent;
	import idv.cjcat.stardust.common.particles.InfoRecycler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	
	[Event(name = "stardustInitializerPriorityChange" , type = "idv.cjcat.stardust.common.events.InitializerEvent")]
	
	/**
	 * An initializer is used to alter just once (i.e. initialize) a particle's properties upon the particle's birth.
	 * 
	 * <p>
	 * An initializer can be associated with an emitter or a particle factory. 
	 * </p>
	 */
	public class Initializer extends StardustElement implements InfoRecycler {
		
		/**
		 * Denotes if the initializer is active, true by default.
		 */
		public var active:Boolean;
		
		//private var _mask:int;
		private var _priority:int;
		
		/** @private */
		protected var _supports2D:Boolean;
		/** @private */
		protected var _supports3D:Boolean;
		
		public function Initializer() {
			_supports2D = _supports3D = true;
			
			priority = CommonInitializerPriority.getInstance().getPriority(Object(this).constructor as Class);
			
			active = true;
			//_mask = 1;
		}
		
		/**
		 * Whether this initializer supports 2D.
		 */
		public function get supports2D():Boolean { return _supports2D; }
		/**
		 * Whether this initializer supports 3D.
		 */
		public function get supports3D():Boolean { return _supports3D; }
		
		/** @private */
		public final function doInitialize(particles:ParticleCollection):void {
			if (active) {
				var particle:Particle;
				var iter:ParticleIterator = particles.getIterator();
				while (particle = iter.particle) {
					initialize(particle);
					if (needsRecycle()) particle.recyclers[this] = this;
					
					iter.next();
				}
			}
		}
		
		/**
		 * [Template Method] This is the method that alters a particle's properties.
		 * 
		 * <p>
		 * Override this property to create custom initializers.
		 * </p>
		 * @param	particle
		 */
		public function initialize(particle:Particle):void {
			//abstract method
		}
		
		/**
		 * Initializers will be sorted according to their priorities.
		 * 
		 * <p>
		 * This is important, 
		 * since some initializers may rely on other initializers to perform initialization beforehand. 
		 * You can alter the priority of an initializer, but it is recommended that you use the default values.
		 * </p>
		 */
		public function get priority():int { return _priority; } 	
		public function set priority(value:int):void {
			_priority = value;
			dispatchEvent(new InitializerEvent(InitializerEvent.PRIORITY_CHANGE, this));
		}
		
		/**
		 * [Template Method] This method is called after a particle's death if the <code>needsRecycle()</code> method returns true.
		 * @param	particle
		 */
		public function recycleInfo(particle:Particle):void {
			
		}
		
		public function needsRecycle():Boolean {
			return false;
		}
		
		/**
		 * The initializer will affect a particle only if it's active and the bitwise AND of the initializer's mask and the particle's mask is non-zero, 
		 * 1 by default.
		 * 
		 * <p>
		 * This can be used to mask out specific particles that you do not wish to be affected by an action.
		 * </p>
		 */
		//public function get mask():int { return _mask; }
		//public function set mask(value:int):void {
			//_mask = value;
		//}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "Initializer";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <initializers/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			
			xml.@active = active;
			//xml.@mask = mask;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@active.length()) active = (xml.@active == "true");
			//mask = parseInt(xml.@mask);
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}