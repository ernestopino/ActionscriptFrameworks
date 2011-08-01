package idv.cjcat.stardust.common.renderers {
	import flash.events.Event;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	
	/**
	 * visualizes the particle according to the numeric data.
	 * An emitter only takes charge of the simulation of particles. 
	 * The <code>particlesAdded()</code>, <code>particlesRemoved()</code>, and <code>render()</code> methods 
	 * are called automatically, since they are listeners to emitter events.
	 */
	public class Renderer extends StardustElement {
		
		private var _emitters:Array;
		
		public function Renderer() {
			_emitters = [];
		}
		
		/**
		 * [Abstract Method] This method listens to the associated emitters for <code>EmitterEvent.PARTICLES_ADDED</code> events.
		 * @param	e
		 */
		protected function particlesAdded(e:EmitterEvent):void {
			//abstract method
		}
		
		/**
		 * [Abstract Method] This method listens to the associated emitters for <code>EmitterEvent.PARTICLES_REMOVED</code> events.
		 * @param	e
		 */
		protected function particlesRemoved(e:EmitterEvent):void {
			//abstract method
		}
		
		/**
		 * [Abstract Method] This method listens to the associated emitters for <code>EmitterEvent.STEPPED</code> events.
		 * @param	e
		 */
		protected function render(e:EmitterEvent):void {
			//abstract method
		}
		
		/**
		 * Adds an emitter to the renderer.
		 * @param	emitter
		 */
		public final function addEmitter(emitter:Emitter):void {
			if (_emitters.indexOf(emitter) < 0) {
				emitter.addEventListener(EmitterEvent.PARTICLES_ADDED, particlesAdded);
				emitter.addEventListener(EmitterEvent.PARTICLES_REMOVED, particlesRemoved);
				emitter.addEventListener(EmitterEvent.STEPPED, render);
				_emitters.push(emitter);
			}
		}
		
		/**
		 * Removes an emitter from the renderer.
		 * @param	emitter
		 */
		public final function removeEmitter(emitter:Emitter):void {
			var index:int = _emitters.indexOf(emitter);
			if (index >= 0) {
				_emitters.splice(index, 1);
				emitter.removeEventListener(EmitterEvent.PARTICLES_ADDED, particlesAdded);
				emitter.removeEventListener(EmitterEvent.PARTICLES_REMOVED, particlesRemoved);
				emitter.removeEventListener(EmitterEvent.STEPPED, render);
			}
		}
		
		/**
		 * Removes all emitters from the renderer.
		 */
		public final function clearEmitters():void {
			for each (var emitter:Emitter in _emitters) removeEmitter(emitter);
		}
		
		/**
		 * The number of particles in the renderer.
		 * @return
		 */
		public final function get numParticles():int {
			var sum:int = 0;
			for each (var emitter:Emitter in _emitters) {
				sum += emitter.numParticles;
			}
			return sum;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return _emitters;
		}
		
		override public function getXMLTagName():String {
			return "Renderer";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <renderers/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			
			if (_emitters.length > 0) {
				xml.appendChild(<emitters/>);
				var emitter:Emitter;
				for each (emitter in _emitters) {
					xml.emitters.appendChild(emitter.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			clearEmitters();
			for each (var node:XML in xml.emitters.*) {
				addEmitter(builder.getElementByName(node.@name) as Emitter);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}