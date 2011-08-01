﻿package idv.cjcat.stardust.threeD.actions  {
	import flash.events.Event;
	import idv.cjcat.stardust.common.easing.EasingFunctionType;
	import idv.cjcat.stardust.common.easing.Linear;
	import idv.cjcat.stardust.common.emitters.Emitter;
	import idv.cjcat.stardust.common.math.Random;
	import idv.cjcat.stardust.common.math.StardustMath;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.actions.Action3D;
	import idv.cjcat.stardust.threeD.events.SnapshotRestore3DEvent;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	[Event(name = "stardustSnapshotRestore3DComplete" , type = "idv.cjcat.stardust.threeD.events.SnapshotRestore3DEvent")]
	
	/**
	 * Restores particle states to previously taken "snapshot" by the <code>Snapshot3D</code> class. 
	 * You can also specify the duration and easing curve for the restoration process.
	 * 
	 * @see idv.cjcat.stardust.threeD.actions.Snapshot3D
	 */
	public class SnapshotRestore3D extends Action3D {
		
		/**
		 * Flags determining whether the positions, rotations, or scales of particles are restored.
		 * @see idv.cjcat.stardust.threeD.actions.SnapshotRestore3DFlag
		 */
		public var flags:int;
		private var _duration:Random;
		private var _curve:Function;
		
		public function SnapshotRestore3D(duration:Random = null, flags:int = 1, curve:Function = null) {
			this.duration = duration;
			this.flags = flags;
			this.curve = curve;
		}
		
		private var _started:Boolean = false;
		private var _started2:Boolean = false;
		private var _counter:Number;
		private var _maxDuration:Number;
		public function start(e:Event = null):void {
			_started = true;
			_started2 = true;
			_counter = 0;
			_maxDuration = _duration.getRange()[1];
		}
		
		/**
		 * The duration of snapshot restoration for a particle.
		 */
		public function get duration():Random { return _duration; }
		public function set duration(value:Random):void {
			if (!value) value = new UniformRandom(0, 0);
			_duration = value;
		}
		private var _durationKey:Object = {};
		
		override public function preUpdate(emitter:Emitter, time:Number):void {
			_counter += time;
			_counter = StardustMath.clamp(_counter, 0, _maxDuration);
		}
		
		override public function update(emitter:Emitter, particle:Particle, time:Number):void {
			if (!_started) {
				skipThisAction = true;
				return;
			}
			
			var p3D:Particle3D = Particle3D(particle);
			if (!p3D.dictionary[Snapshot3D]) return;
			
			if (_started2) {
				p3D.dictionary[SnapshotRestore3D] = new SnapshotData3D(p3D);
				p3D.dictionary[_durationKey] = _duration.random();
			}
			var initData:SnapshotData3D = p3D.dictionary[SnapshotRestore3D] as SnapshotData3D;
			var finalData:SnapshotData3D = p3D.dictionary[Snapshot3D] as SnapshotData3D;
			var duration:Number = p3D.dictionary[_durationKey];
			var counter:Number = StardustMath.clamp(_counter, 0, duration);
			
			if (flags & SnapshotRestore3DFlag.POSITION) {
				p3D.x = curve.apply(null, [counter, initData.x, finalData.x - initData.x, duration]);
				p3D.y = curve.apply(null, [counter, initData.y, finalData.y - initData.y, duration]);
				p3D.z = curve.apply(null, [counter, initData.z, finalData.z - initData.z, duration]);
			}
			
			if (flags & SnapshotRestore3DFlag.ROTATION) {
				p3D.rotationX = curve.apply(null, [counter, initData.rotationX, finalData.rotationX - initData.rotationX, duration]);
				p3D.rotationY = curve.apply(null, [counter, initData.rotationY, finalData.rotationY - initData.rotationY, duration]);
				p3D.rotationZ = curve.apply(null, [counter, initData.rotationZ, finalData.rotationZ - initData.rotationZ, duration]);
			}
			
			if (flags & SnapshotRestore3DFlag.SCALE) {
				p3D.scale = curve.apply(null, [counter, initData.scale, finalData.scale - initData.scale, duration]);
			}
			
			p3D.vx = p3D.vy = p3D.vz = p3D.omegaX = p3D.omegaY = p3D.omegaZ = 0;
		}
		
		override public function postUpdate(emitter:Emitter, time:Number):void {
			if (_started2) _started2 = false;
			if (_started) {
				if (_counter >= _maxDuration) {
					_started = false;
					dispatchEvent(new SnapshotRestore3DEvent(SnapshotRestore3DEvent.COMPLETE));
				}
			}
		}
		
		/**
		 * The easing function for snapshot restoration.
		 */
		public function get curve():Function { return _curve; }
		public function set curve(value:Function):void {
			if (value == null) value = Linear.easeOut;
			_curve = value;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_duration];
		}
		
		override public function getXMLTagName():String {
			return "SnapshotRestore3D";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@duration = duration.name;
			xml.@flags = flags;
			xml.@curve = EasingFunctionType.functions[curve];
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@duration.length()) duration = builder.getElementByName(xml.@duration) as Random;
			if (xml.@flags.length()) flags = parseInt(xml.@flags);
			if (xml.@curve.length()) curve = EasingFunctionType.functions[xml.@curve.toString()];
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}