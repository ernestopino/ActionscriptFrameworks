package com.epinom.btob.data
{	
	public class ComponentVO
	{
		private var _type:String;		
		private var _className:String;
		private var _instanceName:String;
		private var _visible:Boolean;
		private var _hashId:String;
		private var _url:String;
		private var _changeSize:Boolean;
		private var _percentageWidth:Number;
		private var _percentageHeight:Number;
		private var _changePositionX:Boolean;
		private var _changePositionY:Boolean;
		private var _percentageX:Number;
		private var _percentageY:Number;
		private var _centralReference:Boolean;
		private var _elementOrder:int;
		private var _yPosition:Number;
		private var _percentagePadding:Boolean;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		
		public function ComponentVO() {}				
		
		public function get type():String {return _type; }
		public function set type(value:String):void { _type = value; }
		
		public function get className():String { return _className; }
		public function set className(value:String):void { _className = value; }
		
		public function get instanceName():String { return _instanceName; }
		public function set instanceName(value:String):void { _instanceName = value; }
		
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
		
		public function get hashId():String { return _hashId; }
		public function set hashId(value:String):void { _hashId = value; }
		
		public function get url():String { return _url; }
		public function set url(value:String):void { _url = value; }
		
		public function get changeSize():Boolean { return _changeSize; }
		public function set changeSize(value:Boolean):void { _changeSize = value; }
		
		public function get percentageWidth():Number { return _percentageWidth; }
		public function set percentageWidth(value:Number):void { _percentageWidth = value; }
		
		public function get percentageHeight():Number { return _percentageHeight; }
		public function set percentageHeight(value:Number):void { _percentageHeight = value; }
		
		public function get changePositionX():Boolean { return _changePositionX; }
		public function set changePositionX(value:Boolean):void { _changePositionX = value; }
		
		public function get changePositionY():Boolean { return _changePositionY; }
		public function set changePositionY(value:Boolean):void { _changePositionY = value; }
		
		public function get percentageX():Number { return _percentageX; }
		public function set percentageX(value:Number):void { _percentageX = value; }
		
		public function get percentageY():Number { return _percentageY; }
		public function set percentageY(value:Number):void { _percentageY = value; }
		
		public function get centralReference():Boolean { return _centralReference; }
		public function set centralReference(value:Boolean):void { _centralReference = value; }
		
		public function get elementOrder():int { return _elementOrder; }
		public function set elementOrder(value:int):void { _elementOrder = value; }
		
		public function get yPosition():Number { return _yPosition; }
		public function set yPosition(value:Number):void { _yPosition = value; }
		
		public function get percentagePadding():Boolean { return _percentagePadding }
		public function set percentagePadding(value:Boolean):void { _percentagePadding = value; }
		
		public function get paddingTop():Number { return _paddingTop; }
		public function set paddingTop(value:Number):void { _paddingTop = value; }
		
		public function get paddingBottom():Number { return _paddingBottom; }
		public function set paddingBottom(value:Number):void { _paddingBottom = value; }
		
		public function get paddingLeft():Number { return _paddingLeft; }
		public function set paddingLeft(value:Number):void { _paddingLeft = value; }
		
		public function get paddingRight():Number { return _paddingRight; }
		public function set paddingRight(value:Number):void { _paddingRight = value; }
	}
}