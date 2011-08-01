package com.epinom.lan.machupicchu.graphics
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DrawConstellation extends MovieClip
	{
		private var firstPoint:Boolean;
		private var lastPoint:Point;
		private var line:Sprite;
		
		public function DrawConstellation()
		{
			super();
			trace("DrawConstellation->DrawConstellation()");
			
			firstPoint = true;
			line = new Sprite();
			line.graphics.lineStyle(1, 0x7086C7, 1);
			sky.canvas.addChild(line);
			configHandlers();
		}
		
		private function configHandlers():void {
			trace("DrawConstellation->configHandlers()");
			sky.receptor.addEventListener(MouseEvent.CLICK, onUserClickHandler);
			restartButton.addEventListener(MouseEvent.CLICK, onRestartConstellationButtonClickHandler, false, 0, true);
		}
		
		private function onUserClickHandler(evt:MouseEvent):void 
		{
			var newPoint = new Point(sky.canvas.mouseX, sky.canvas.mouseY);
			var star:MovieClip = new Star();
			star.x = newPoint.x;
			star.y = newPoint.y;
			sky.canvas.addChild(star);
			
			// Creando linea entre el ultimo punto y el actual
			if(!firstPoint) {
				line.graphics.moveTo(lastPoint.x, lastPoint.y);
				line.graphics.lineTo(newPoint.x, newPoint.y);
				lastPoint = newPoint;
			} else { 
				firstPoint = false;
				lastPoint = newPoint;
			}
		}
		
		private function onRestartConstellationButtonClickHandler(evt:MouseEvent):void 
		{
			sky.canvas.removeChild(line);
			while((sky.canvas as MovieClip).numChildren) 
				(sky.canvas as MovieClip).removeChildAt(0); 
			
			line = new Sprite();
			line.graphics.lineStyle(1, 0x7086C7, 1);
			sky.canvas.addChild(line);
			firstPoint = true;
		}
	}
}