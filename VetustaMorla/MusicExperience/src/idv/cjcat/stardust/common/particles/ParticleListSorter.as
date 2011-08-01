package idv.cjcat.stardust.common.particles {
	
	internal class ParticleListSorter {
		
		private static var _instance:ParticleListSorter;
		public static function getInstane():ParticleListSorter {
			if (!_instance) _instance = new ParticleListSorter();
			return _instance;
		}
		
		public function ParticleListSorter() {
			
		}
		
		public function sort(particles:ParticleList):void {
			
		}
	}
}