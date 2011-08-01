package idv.cjcat.stardust.common.particles {
	
	public interface InfoRecycler {
		function recycleInfo(particle:Particle):void;
		function needsRecycle():Boolean;
	}
}