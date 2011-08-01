package nl.michelvandersteege.transitions{

	import caurina.transitions.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.*;

	public class BitmapdataTransitions extends Sprite {
		
		private var _target:Sprite;
		private var _bmd:BitmapData;
		private var _bmp:Bitmap;
		private var _mat:Matrix;
		private var _tweenType:String;
		private var _dir:String;
		private var _bmpArray:Array = new Array();
		private var _holder:Sprite;
		private var _numHor:Number;
		private var _numVer:Number;
		private var _numTotal:Number;
		private var _c:Number;
		private var _r:Number;
		private var _del:Number;
		private var _tweenTime:Number;
		private var _counter:Number;

		public function BitmapdataTransitions():void {
			//look it is empty :O
		}
		
		private function removeBMP(){
			if(_bmpArray.length != 0){
				Tweener.removeAllTweens(); 
				for(var j:Number = 0; j<_bmpArray.length; j++){
					_holder.removeChild(_bmpArray[j]);
				}
				removeChild(_holder);
				_holder = null;
				if(_dir == "in"){
					_target.visible = true;
				}
				_bmpArray = [];
			}
		}
		
		private function checkLast(){
			_counter++;
			if(_counter == _numTotal){
				removeBMP();
			}
		}
		
		//a large function to pos the bmps
		//what i do here is check if it is an in or out animation and the pos and tween them
		private function posBMP(__dir:String,__pos:String,__bmp:Bitmap,__x:Number,__y:Number):void {
			if(__dir == "in"){
				if(__pos == "T"){
					__bmp.x = __x;
					Tweener.addTween(_bmp, {y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "R"){
					__bmp.y = __y;
					__bmp.x = (_target.x + _target.width)-__bmp.width;
					Tweener.addTween(_bmp, {x:__x, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "B"){
					__bmp.x = __x;
					__bmp.y = (_target.y + _target.height)-__bmp.height;
					Tweener.addTween(_bmp, {y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "L"){
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:__x, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "TL"){
					Tweener.addTween(_bmp, {x:__x, y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "TR"){
					__bmp.x = (_target.x + _target.width)-__bmp.width;
					__bmp.y = _target.y;
					Tweener.addTween(_bmp, {x:__x, y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "BL"){
					__bmp.x = _target.x;
					__bmp.y = (_target.y + _target.height)-__bmp.height;
					Tweener.addTween(_bmp, {x:__x, y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "BR"){
					__bmp.x = (_target.x + _target.width)-__bmp.width;
					__bmp.y = (_target.y + _target.height)-__bmp.height;
					Tweener.addTween(_bmp, {x:__x, y:__y, time:_tweenTime, transition:_tweenType, delay:_del});
				}else{
					__bmp.x = __x;
					__bmp.y = __y;
				}
			}else{
				if(__pos == "T"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {y:0, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "R"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:(_target.x + _target.width)-__bmp.width, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "B"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {y:(_target.y + _target.height)-__bmp.height, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "L"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:0, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "TL"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:0, y:0, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "TR"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:(_target.x + _target.width)-__bmp.width, y:0, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "BL"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:0, y:(_target.y + _target.height)-__bmp.height, time:_tweenTime, transition:_tweenType, delay:_del});
				}else if(__pos == "BR"){
					__bmp.x = __x;
					__bmp.y = __y;
					Tweener.addTween(_bmp, {x:(_target.x + _target.width)-__bmp.width, y:(_target.y + _target.height)-__bmp.height, time:_tweenTime, transition:_tweenType, delay:_del});
				}else{
					__bmp.x = __x;
					__bmp.y = __y;
				}

			}
		}
		
		//block
		public function block(__target:Sprite,
							  __dir:String = "in",
							  __width:Number = 25,
							  __height:Number = 25,
							  __position:String = "None",
							  __scale:Boolean = true,
							  __rotate:Boolean = false,
							  __alpha:Boolean = true,
							  __tweenTime:Number = 0.5,
							  __tweenDelay:String = "random:3",
							  __tweenType:String = "EaseOutBack"):void {
			removeBMP();
			//set the target
			_target = __target;
			
			//make the holder
			_holder = new Sprite();
			addChild(_holder);
			_holder.x = _target.x;
			_holder.y = _target.y;
			
			//set the vars
			_c = 0;
			_r = -1;
			_numHor = Math.ceil(__target.width/__width);
			_numVer = Math.ceil(__target.height/__height);
			_numTotal = _numHor*_numVer;
			_tweenTime = __tweenTime;
			_tweenType = __tweenType;
			_dir = __dir;
			_counter = 0;
			
			//make the effect with a for loop
			for (var i:Number = 0; i< _numTotal; i++) {
				//delay
				if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "random"){
					_del = Math.random()*Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "followUp"){
					_del = i/Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else{
					_del = 0;
				}
				//rows
				if(i % _numHor == 0){
					_c = 0;
					_r++;
				}
				//bitmapData
				_bmd = new BitmapData(__width, __height, true, 0);
				_mat = new Matrix();
				_mat.tx = -(_c)*__width;
				_mat.ty = -(_r)*__height;
				_bmd.draw(_target,_mat);
				//bitmap
				_bmp = new Bitmap(_bmd);
				_holder.addChild(_bmp);
				_bmpArray.push(_bmp);
				
				//pos the bmp
				posBMP(__dir,__position,_bmp,_c*__width,_r*__height);
				
				//scale, alpha and direction
				if(__dir == "in"){
					//scale
					if(__scale){
						_bmp.scaleX = _bmp.scaleY = 0;
						Tweener.addTween(_bmp, {scaleX:1, scaleY:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						_bmp.alpha = 0;
						Tweener.addTween(_bmp, {alpha:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}else{
					//scale
					if(__scale){
						Tweener.addTween(_bmp, {scaleX:0, scaleY:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						Tweener.addTween(_bmp, {alpha:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}
				//rotation
				if(__rotate){
					Tweener.addTween(_bmp, {rotation:360, time:_tweenTime, transition:_tweenType, delay:_del});
				}
				
				//fake tween to get the end
				Tweener.addTween(_bmp, {time:_tweenTime, transition:_tweenType, delay:_del, onComplete:checkLast});
				
				//rows
				_c++;
			}
			//make the target visible false
			_target.visible = true;
		}
		
		//horBar
		public function horBar(__target:MovieClip,
							  __dir:String = "in",
							  __size:Number = 25,
							  __position:String = "None",
							  __scale:Boolean = true,
							  __rotate:Boolean = false,
							  __alpha:Boolean = true,
							  __tweenTime:Number = 0.5,
							  __tweenDelay:String = "random:3",
							  __tweenType:String = "EaseOutBack"):void {
			removeBMP();
			//set the target
			_target = __target;
			
			//make the holder
			_holder = new Sprite();
			addChild(_holder);
			_holder.x = _target.x;
			_holder.y = _target.y;
			
			//set the vars
			_numTotal = Math.ceil(__target.height/__size);
			_tweenTime = __tweenTime;
			_tweenType = __tweenType;
			_dir = __dir;
			_counter = 0;
			
			//make the effect with a for loop
			for (var i:Number = 0; i< _numTotal; i++) {
				//delay
				if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "random"){
					_del = Math.random()*Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "followUp"){
					_del = i/Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else{
					_del = 0;
				}

				//bitmapData
				_bmd = new BitmapData(_target.width, __size, true, 0);
				_mat = new Matrix();
				_mat.ty = -(i)*__size;
				_bmd.draw(_target,_mat);
				//bitmap
				_bmp = new Bitmap(_bmd);
				_holder.addChild(_bmp);
				_bmpArray.push(_bmp);
				
				//pos the bmp
				posBMP(__dir,__position,_bmp,0,i*__size);
				
				//scale, alpha and direction
				if(__dir == "in"){
					//scale
					if(__scale){
						_bmp.scaleX = _bmp.scaleY = 0;
						Tweener.addTween(_bmp, {scaleX:1, scaleY:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						_bmp.alpha = 0;
						Tweener.addTween(_bmp, {alpha:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}else{
					//scale
					if(__scale){
						Tweener.addTween(_bmp, {scaleX:0, scaleY:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						Tweener.addTween(_bmp, {alpha:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}
				//rotation
				if(__rotate){
					Tweener.addTween(_bmp, {rotation:360, time:_tweenTime, transition:_tweenType, delay:_del});
				}
				
				//fake tween to get the end
				Tweener.addTween(_bmp, {time:_tweenTime, transition:_tweenType, delay:_del, onComplete:checkLast});
				
				//rows
				_c++;
			}
			//make the target visible false
			_target.visible = true;
		}
		
		//verBar
		public function verBar(__target:MovieClip,
							  __dir:String = "in",
							  __size:Number = 25,
							  __position:String = "None",
							  __scale:Boolean = true,
							  __rotate:Boolean = false,
							  __alpha:Boolean = true,
							  __tweenTime:Number = 0.5,
							  __tweenDelay:String = "random:3",
							  __tweenType:String = "EaseOutBack"):void {
			removeBMP();
			//set the target
			_target = __target;
			
			//make the holder
			_holder = new Sprite();
			addChild(_holder);
			_holder.x = _target.x;
			_holder.y = _target.y;
			
			//set the vars
			_numTotal = Math.ceil(__target.width/__size);
			_tweenTime = __tweenTime;
			_tweenType = __tweenType;
			_dir = __dir;
			_counter = 0;
			
			//make the effect with a for loop
			for (var i:Number = 0; i< _numTotal; i++) {
				//delay
				if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "random"){
					_del = Math.random()*Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else if(__tweenDelay.substring(0,__tweenDelay.indexOf(":")) == "followUp"){
					_del = i/Number(__tweenDelay.substr(__tweenDelay.indexOf(":")+1));
				}else{
					_del = 0;
				}

				//bitmapData
				_bmd = new BitmapData(__size, _target.height, true, 0);
				_mat = new Matrix();
				_mat.tx = -(i)*__size;
				_bmd.draw(_target,_mat);
				//bitmap
				_bmp = new Bitmap(_bmd);
				_holder.addChild(_bmp);
				_bmpArray.push(_bmp);
				
				//pos the bmp
				posBMP(__dir,__position,_bmp,i*__size,0);
				
				//scale, alpha and direction
				if(__dir == "in"){
					//scale
					if(__scale){
						_bmp.scaleX = _bmp.scaleY = 0;
						Tweener.addTween(_bmp, {scaleX:1, scaleY:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						_bmp.alpha = 0;
						Tweener.addTween(_bmp, {alpha:1, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}else{
					//scale
					if(__scale){
						Tweener.addTween(_bmp, {scaleX:0, scaleY:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
					//alpha
					if(__alpha){
						Tweener.addTween(_bmp, {alpha:0, time:_tweenTime, transition:_tweenType, delay:_del});
					}
				}
				//rotation
				if(__rotate){
					Tweener.addTween(_bmp, {rotation:360, time:_tweenTime, transition:_tweenType, delay:_del});
				}
				
				//fake tween to get the end
				Tweener.addTween(_bmp, {time:_tweenTime, transition:_tweenType, delay:_del, onComplete:checkLast});
				
				//rows
				_c++;
			}
			//make the target visible false
			_target.visible = true;
		}
		
	}
}