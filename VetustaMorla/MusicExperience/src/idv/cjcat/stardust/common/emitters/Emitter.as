package idv.cjcat.stardust.common.emitters {
	import flash.events.Event;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.actions.ActionCollection;
	import idv.cjcat.stardust.common.actions.ActionCollector;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.events.ActionEvent;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.events.InitializerEvent;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.initializers.InitializerCollection;
	import idv.cjcat.stardust.common.initializers.InitializerCollector;
	import idv.cjcat.stardust.common.particles.InfoRecycler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleArray;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleCollectionType;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.particles.ParticleList;
	import idv.cjcat.stardust.common.particles.ParticleListIterator;
	import idv.cjcat.stardust.common.particles.ParticleListIteratorPool;
	import idv.cjcat.stardust.common.particles.ParticlePool;
	import idv.cjcat.stardust.common.particles.PooledParticleFactory;
	import idv.cjcat.stardust.common.particles.PooledParticleList;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	import idv.cjcat.stardust.threeD.emitters.Emitter3D;
	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	
	use namespace sd;
	
	[Event(name = "stardustEmitterEmpty" , type = "idv.cjcat.stardust.common.events.EmitterEvent")]
	[Event(name = "stardustEmitterParticleAdded" , type = "idv.cjcat.stardust.common.events.EmitterEvent")]
	[Event(name = "stardustEmitterParticleRemoved" , type = "idv.cjcat.stardust.common.events.EmitterEvent")]
	[Event(name = "stardustEmitterStepped" , type = "idv.cjcat.stardust.common.events.EmitterEvent")]
	
	/**
	 * This class takes charge of the actual particle simulation of the Stardust particle system.
	 * 
	 * <p>
	 * The <code>EmitterEvent.PARTICLES_ADDED</code> event is dispatched whenever there are particles added or created in the emitter in each step. 
	 * The <code>EmitterEvent.PARTICLES_REMOVED</code> event is dispatched whenever there are dead particles removed from the emitter in each step. 
	 * The <code>EmitterEvent.STEPPED</code> event is dispatched when a step is finished.
	 * </p>
	 */
	public class Emitter extends StardustElement implements ActionCollector, InitializerCollector {
		
		private var _clock:Clock;
		/**
		 * Whether the emitter is active, true by default.
		 * 
		 * <p>
		 * If the emitter is active, it creates particles in each step according to its clock. 
		 * Note that even if an emitter is not active, the simulation of existing particles still goes on in each step.
		 * </p>
		 */
		public var active:Boolean;
		/** @private */
		public var needsSort:Boolean;
		
		/** @private */
		sd var _particles:ParticleCollection;
		/** @private */
		protected var factory:PooledParticleFactory;
		
		private var _actionCollection:ActionCollection;
		
		public function Emitter(clock:Clock = null) {
			needsSort = false;
			
			//NOTE: factory object should be assigned in emitter subclass constructors
			this.clock = clock;
			this.active = true;
			
			_actionCollection = new ActionCollection();
			_particles = new PooledParticleList();
		}
		
		/**
		 * The clock determines how many particles the emitter creates in each step.
		 */
		public function get clock():Clock { return _clock; }
		public function set clock(value:Clock):void {
			if (!value) value = new SteadyClock(0);
			_clock = value;
		}
		
		//main loop
		//------------------------------------------------------------------------------------------------
		/**
		 * This property determines how fast the simulation goes on.
		 * 
		 * <p>
		 * For instance, setting this property to 2 causes the simulation to go twice as fast as normal. 
		 * And setting this property to 0.5 causes the simulation to go half as fast as normal.
		 */
		public var stepTimeInterval:Number = 1;
		
		private var deadParticles:ParticleCollection = new PooledParticleList();
		
		/**
		 * This method is the main simulation loop of the emitter.
		 * 
		 * <p>
		 * In order to keep the simulation go on, this method should be called continuously. 
		 * It is recommended that you call this method through the <code>Event.ENTER_FRAME</code> event or the <code>TimerEvent.TIMER</code> event.
		 * </p>
		 * @param	event
		 */
		public final function step(e:Event = null):void {
			var action:Action;
			var activeActions:Array;
			var p:Particle;
			var iter:ParticleIterator;
			var live:Boolean;
			var sorted:Boolean = false;
			
			//query clock ticks
			if (active) {
				var pCount:int = clock.getTicks(stepTimeInterval);
				var newParticles:ParticleCollection = factory.createParticles(pCount);
				addParticles(newParticles);
			}
			
			//filter out active actions
			activeActions = [];
			for each (action in actions) {
				if (action.active) {
					if (action.mask) activeActions.push(action);
				}
			}
			
			//sorting
			for each (action in activeActions) {
				if (action.needsSortedParticles) {
					//sort particles
					particles.sort();
					
					//set sorted index iterators
					iter = _particles.getIterator();
					while (p = iter.particle) {
						p.sortedIndexIterator = iter.dump(ParticleListIteratorPool.get());
						iter.next();
					}
					sorted = true;
					break;
				}
			}
			
			//update the first particle
			iter = particles.getIterator();
			p = iter.particle
			if (p) {
				live = true;
				for each (action in activeActions) {
					//preUpdate
					action.preUpdate(this, stepTimeInterval);
					
					//main update
					if (action.mask & p.mask) action.update(this, p, stepTimeInterval);
					
					//collect dead particle
					if (live && p.isDead) {
						deadParticles.add(p);
						live = false;
					}
				}
				if (live) iter.next();
				else iter.remove();
			}
			
			//update the remaining particles
			while (p = iter.particle) {
				live = true;
				for each (action in activeActions) {
					if (p.mask & action.mask) {
						//update particle
						action.update(this, p, stepTimeInterval);
					}
					//collect dead particle
					if (live && p.isDead) {
						deadParticles.add(p);
						live = false;
					}
				}
				if (live) iter.next();
				else iter.remove();
			}
			
			//postUpdate
			for each (action in activeActions) {
				action.postUpdate(this, stepTimeInterval);
			}
			
			//recycle sorted index iterators
			if (sorted) {
				iter = _particles.getIterator();
				while (p = iter.particle) {
					ParticleListIteratorPool.recycle(ParticleListIterator(p.sortedIndexIterator));
					iter.next();
				}
				iter = deadParticles.getIterator();
				while (p = iter.particle) {
					ParticleListIteratorPool.recycle(ParticleListIterator(p.sortedIndexIterator));
					iter.next();
				}
			}
			
			//remove dead particles
			if (deadParticles.size) dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_REMOVED, deadParticles));
			iter = deadParticles.getIterator();
			while (p = iter.particle) {
				for (var key:* in p.recyclers) {
					var recycler:InfoRecycler = key as InfoRecycler;
					if (recycler) recycler.recycleInfo(p);
				}
				p.destroy();
				factory.recycle(p);
				iter.next();
			}
			deadParticles.clear();
			
			dispatchEvent(new EmitterEvent(EmitterEvent.STEPPED, _particles));
			if (!numParticles) dispatchEvent(new EmitterEvent(EmitterEvent.EMITTER_EMPTY, null));
		}
		
		//------------------------------------------------------------------------------------------------
		//end of main loop
		
		
		//actions & initializers
		//------------------------------------------------------------------------------------------------
		/** @private */
		sd final function get actions():Array { return _actionCollection.sd::actions; }
		
		/**
		 * Adds an action to the emitter.
		 * @param	action
		 */
		public function addAction(action:Action):void {
			_actionCollection.addAction(action);
		}
		
		/**
		 * Removes an action from the emitter.
		 * @param	action
		 */
		public final function removeAction(action:Action):void {
			_actionCollection.removeAction(action);
		}
		
		/**
		 * Removes all actions from the emitter.
		 */
		public final function clearActions():void {
			_actionCollection.clearActions();
		}
		
		/** @private */
		sd final function get initializers():Array { return factory.sd::initializerCollection.sd::initializers; }
		
		/**
		 * Adds an initializer to the emitter.
		 * @param	initializer
		 */
		public function addInitializer(initializer:Initializer):void {
			factory.addInitializer(initializer);
		}
		
		/**
		 * Removes an initializer form the emitter.
		 * @param	initializer
		 */
		public final function removeInitializer(initializer:Initializer):void {
			factory.removeInitializer(initializer);
		}
		
		/**
		 * Removes all initializers from the emitter.
		 */
		public final function clearInitializers():void {
			factory.clearInitializers();
		}
		//------------------------------------------------------------------------------------------------
		//end of actions & initializers
		
		
		//particles
		//------------------------------------------------------------------------------------------------
		
		/**
		 * The number of particles in the emitter.
		 */
		public final function get numParticles():int {
			return _particles.size;
		}
		
		/**
		 * This method is used to manually add existing particles to the emitter's simulation.
		 * 
		 * <p>
		 * You should use the <code>particleFactory</code> class to manually create particles.
		 * </p>
		 * @param	particles
		 */
		public final function addParticles(particles:ParticleCollection):void {
			var particle:Particle;
			var iter:ParticleIterator = particles.getIterator();
			while (particle = iter.particle) {
				this._particles.add(particle);
				iter.next();
			}
			if (particles.size) dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_ADDED, particles));
		}
		
		/**
		 * Clears all particles from the emitter's simulation.
		 */
		public final function clearParticles():void {
			var temp:ParticleCollection = _particles;
			_particles = new ParticleList();
			if (temp.size) dispatchEvent(new EmitterEvent(EmitterEvent.PARTICLES_REMOVED, temp));
			
			var particle:Particle;
			var iter:ParticleIterator = _particles.getIterator();
			while (particle = iter.particle) {
				particle.destroy();
				factory.recycle(particle);
				
				iter.remove();
			}
		}
		
		/**
		 * Returns an array of particles for custom parameter manipulation. 
		 * Note that the returned array is merely a copy of the internal particle array, 
		 * so splicing particles out from this array does not remove the particles from simulation.
		 * @return
		 */
		public function get particles():ParticleCollection { return _particles; }
		
		/**
		 * Determines the collection used internally by the emitter. There are two options: linked-lists and arrays. 
		 * Linked-Lists are generally faster to iterate through and remove particles from, while arrays are faster at sorting. 
		 * By default, linked-lists are used. Switch to arrays if the particles need to be sorted.
		 * 
		 * <p>
		 * There are two possible values that can assigned to this property: <code>ParticleCollectionType.LINKED_LIST</code> and <code>ParticleCollectionType.ARRAY</code>.
		 * </p>
		 * @see idv.cjcat.stardust.common.particles.ParticleCollectionType
		 */
		public function get particleCollectionType():int {
			if (_particles is ParticleList) return ParticleCollectionType.LINKED_LIST;
			else if (_particles is ParticleArray) return ParticleCollectionType.ARRAY;
			return -1;
		}
		
		public function set particleCollectionType(value:int):void {
			var temp:ParticleCollection;
			switch (value) {
				case ParticleCollectionType.LINKED_LIST:
					if (this is Emitter2D) temp = new PooledParticleList(ParticleList.TWO_D);
					else if (this is Emitter3D) temp = new PooledParticleList(ParticleList.THREE_D);
					break;
				case ParticleCollectionType.ARRAY:
					temp = new ParticleArray();
					break;
			}
			var iter:ParticleIterator = _particles.getIterator();
			var p:Particle;
			while (p = iter.particle) {
				temp.add(p);
				iter.remove();
			}
			_particles = temp;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of particles
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_clock].concat(initializers).concat(actions);
		}
		
		override public function getXMLTagName():String {
			return "Emitter";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <emitters/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@active = active.toString();
			
			xml.@clock = _clock.name;
			
			if (actions.length) {
				xml.appendChild(<actions/>);
				for each (var action:Action in actions) {
					xml.actions.appendChild(action.getXMLTag());
				}
			}
			
			if (initializers.length) {
				xml.appendChild(<initializers/>);
				for each (var initializer:Initializer in initializers) {
					xml.initializers.appendChild(initializer.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			_actionCollection.clearActions();
			factory.clearInitializers();
			
			if (xml.@active.length()) active = (xml.@active == "true");
			if (xml.@clock.length()) clock = builder.getElementByName(xml.@clock) as Clock;
			
			var node:XML;
			for each (node in xml.actions.*) {
				addAction(builder.getElementByName(node.@name) as Action);
			}
			for each (node in xml.initializers.*) {
				addInitializer(builder.getElementByName(node.@name) as Initializer);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}