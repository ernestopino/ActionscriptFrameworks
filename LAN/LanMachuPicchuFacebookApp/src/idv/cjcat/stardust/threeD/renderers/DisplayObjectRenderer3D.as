package idv.cjcat.stardust.threeD.renderers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import idv.cjcat.stardust.common.events.EmitterEvent;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.threeD.cameras.Camera3D;
	import idv.cjcat.stardust.threeD.geom.Matrix3D;
	import idv.cjcat.stardust.threeD.geom.Vec3D;
	import idv.cjcat.stardust.threeD.geom.Vec3DPool;
	import idv.cjcat.stardust.threeD.geom.ZData;
	import idv.cjcat.stardust.threeD.geom.ZDataPool;
	import idv.cjcat.stardust.threeD.particles.Particle3D;
	
	/**
	 * This renderer adds display object particles to the target container's display list, 
	 * removes dead particles from the display list, 
	 * and updates the display object's x, y, rotation, scaleX, scaleY, and alpha properties, 
	 * applying 3D Z-sorting and optional perspective projection to the diplay objects.
	 */
	public class DisplayObjectRenderer3D extends Renderer {
		
		/**
		 * The target container.
		 */
		public var container:DisplayObjectContainer;
		/**
		 * Whether to change a display object's parent to the target container if the object already belongs to another parent.
		 */
		public var forceParentChange:Boolean;
		
		private var _camera:Camera3D;
		
		public function DisplayObjectRenderer3D(container:DisplayObjectContainer = null, camera:Camera3D = null) {
			this.container = container;
			this.camera = camera;
			forceParentChange = false;
		}
		
		public function get camera():Camera3D { return _camera; }
		public function set camera(value:Camera3D):void {
			if (!value) {
				value = new Camera3D();
				value.position.set(0, 0, -1000);
			}
			_camera = value;
		}
		
		override protected function particlesAdded(e:EmitterEvent):void {
			if (!container) return;
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				
				if (!displayObj) continue;
				
				if (!forceParentChange) {
					if (displayObj.parent != null) continue;
				}
				container.addChild(displayObj);
				
				iter.next();
			}
		}
		
		override protected function particlesRemoved(e:EmitterEvent):void {
			var particle:Particle3D;
			var iter:ParticleIterator = e.particles.getIterator();
			while (particle = Particle3D(iter.particle)) {
				var displayObj:DisplayObject = DisplayObject(particle.target);
				if (!displayObj) continue;
				DisplayObjectContainer(displayObj.parent).removeChild(displayObj);
				
				iter.next();
			}
		}
		
		private var _cameraMatrix:Matrix3D = new Matrix3D();
		private var _cameraDiff:Vec3D = new Vec3D();
		private var _zdList:Array = [];
		override protected function render(e:EmitterEvent):void {
			_cameraMatrix.identity();
			_cameraMatrix.rotateY(Math.atan2(-_camera.direction.x, _camera.direction.z));
			_cameraMatrix.rotateX(Math.atan2(_camera.direction.y, Math.sqrt(_camera.direction.x * _camera.direction.x + _camera.direction.z * _camera.direction.z)));
			
			_zdList.length = e.particles.size;
			var i:int;
			var iter:ParticleIterator = e.particles.getIterator();
			var particle:Particle3D;
			i = 0;
			
			while (particle = Particle3D(iter.particle)) {
				_cameraDiff.set(particle.x - _camera.position.x, particle.y - _camera.position.y, particle.z - _camera.position.z);
				_cameraMatrix.transformThisVec(_cameraDiff);
				
				particle.dictionary[ZData] =
				_zdList[i] = ZDataPool.get(DisplayObject(particle.target), particle, _cameraDiff.x, _cameraDiff.y, _cameraDiff.z);
				
				
				_cameraDiff.set(particle.vx, particle.vy, particle.vz);
				_cameraMatrix.transformThisVec(_cameraDiff);
				
				//screen velocity
				particle.screenVX = _cameraDiff.x;
				particle.screenVY = _cameraDiff.y;
				
				i++;
				iter.next();
			}
			_zdList.sort(zdSorter);
			
			for each (var zd:ZData in _zdList) {
				container.addChild(zd.displayObject);
				
				if (zd.cameraDiff.z < 0) {
					zd.displayObject.visible = false;
				} else {
					zd.displayObject.visible = true;
				}
				
				//calculate screen velocity
				if (_camera.usePerspective) {
					var factor:Number = _camera.zoom / ((zd.cameraDiff.z / _camera.focalLength) + 1);
					zd.particle.screenX = zd.cameraDiff.x * factor;
					zd.particle.screenY = zd.cameraDiff.y * factor;
					zd.particle.dictionary[DisplayObjectRenderer3D] = factor * zd.particle.initScale;
				} else {
					zd.particle.screenX = _camera.zoom * zd.cameraDiff.x;
					zd.particle.screenY = _camera.zoom * zd.cameraDiff.y;
					zd.particle.dictionary[DisplayObjectRenderer3D] = 1;
				}
				
				renderDisplayObject(zd.particle);
				ZDataPool.recycle(zd);
			}
		}
		
		private function zdSorter(zd1:ZData, zd2:ZData):Number {
			if (zd1.cameraDiff.z > zd2.cameraDiff.z) return -1;
			return 1;
		}
		
		private function renderDisplayObject(particle:Particle3D):void {
			var displayObj:DisplayObject = DisplayObject(particle.target);
			if (!displayObj) return;
			
			displayObj.x = particle.screenX;
			displayObj.y = particle.screenY;
			displayObj.rotation = particle.rotationZ;
			displayObj.scaleX = displayObj.scaleY = particle.scale * Number(particle.dictionary[DisplayObjectRenderer3D]);
			displayObj.alpha = particle.alpha;
		}
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getXMLTagName():String {
			return "DisplayObjectRenderer3D";
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@forceParentChange = forceParentChange;
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			if (xml.@forceParentChange.length()) forceParentChange = (xml.@forceParentChange == "true");
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}