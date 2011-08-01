package com.epinom.btob.ui
{
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.LoaderManager;
	import com.epinom.btob.managers.TableDataManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class WeSectionMovie extends MovieClip
	{
		private static const BLOCK_COUNT:uint = 107;
		private static const OPEN_AREA:String = "open";
		private static const CLOSE_AREA:String = "close";
		
		private var origin:String;	
		private var statusArea:String;
		private var activeBlock:MovieClip;
		
		public function WeSectionMovie()
		{
			trace("WeSectionMovie->WeSectionMovie()");		
			super();						
			
			this.origin = TableDataManager.SECTION_WE;
			this.statusArea = CLOSE_AREA;
			this.activeBlock = null;
			
			// Configurando cuadricula
			configGrid();
			
			// Configurando detectores de eventos
			configHandlers();
		}
		
		private function configGrid():void 
		{
			for(var i:uint = 0; i <= BLOCK_COUNT; i++) {
				trace(i);
				var alphaValue:Number = Math.random();
				if(alphaValue > 0.5)
					alphaValue = alphaValue - 0.5;		
				(grid_mc["block_" + i] as MovieClip).alpha = alphaValue;		
			}
		}
		
		private function configHandlers():void
		{
			// BTOB LOGO
			btobLogo_mc.home_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);
			
			// HELLO 
			hello_mc.btn.addEventListener(MouseEvent.CLICK, onHelloClickHandler);
			
			// MENU
			
			// MouseOver Handler
			menu_mc.we_btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuMouseOverHandler);
			menu_mc.like_btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuMouseOverHandler);
			menu_mc.sharing_btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuMouseOverHandler);
			menu_mc.experiences_btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuMouseOverHandler);
			menu_mc.awards_btn.addEventListener(MouseEvent.MOUSE_OVER, onMenuMouseOverHandler);
			
			// MouseOut Handler
			menu_mc.we_btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuMouseOutHandler);
			menu_mc.like_btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuMouseOutHandler);
			menu_mc.sharing_btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuMouseOutHandler);
			menu_mc.experiences_btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuMouseOutHandler);
			menu_mc.awards_btn.addEventListener(MouseEvent.MOUSE_OUT, onMenuMouseOutHandler);
			
			// Click Handler
			menu_mc.we_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);
			menu_mc.like_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);
			menu_mc.sharing_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);
			menu_mc.experiences_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);
			menu_mc.awards_btn.addEventListener(MouseEvent.CLICK, onMenuClickHandler);

			// OFFICE AREA					
			
			// MouseOver
			salaJuntasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			administracionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			programacionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);	
			smoBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			kitchenBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			direccionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			thinkingRoomBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			analisisPlanificacionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			creatividadBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			audioVisualBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
			
			// MouseOut
			salaJuntasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			administracionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			programacionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);	
			smoBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			kitchenBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			direccionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			thinkingRoomBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			analisisPlanificacionBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			creatividadBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			audioVisualBlock_mc.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
			
			// Click Handler
			salaJuntasBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			administracionBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			entradaBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			cuentasBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			programacionBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);	
			smoBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			kitchenBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			direccionBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			thinkingRoomBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			analisisPlanificacionBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			creatividadBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
			audioVisualBlock_mc.closeView_btn.addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);			
		}
		
		public function onAreaMouseOverHandler(evt:MouseEvent):void 
		{
			var block_mc:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			block_mc.mc.gotoAndStop("over");
		}
		
		public function onAreaMouseOutHandler(evt:MouseEvent):void 
		{
			var block_mc:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			block_mc.mc.gotoAndStop("up");
		}
		
		public function onAreaMouseEventHandler(evt:MouseEvent):void 
		{
			activeBlock = (evt.target as SimpleButton).parent as MovieClip;						
			switch(statusArea) 
			{
				case CLOSE_AREA:
					trace("close -> open");
					addChild(activeBlock);		
					(activeBlock.closeView_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
					activeBlock.closeView_btn.removeEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
					activeBlock.closeView_btn.removeEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
					activeBlock.gotoAndStop("open");
					statusArea = OPEN_AREA;
					activeBlock.modalWindow_btn.useHandCursor = false;	
					activeBlock.modalWindow_btn.addEventListener(MouseEvent.CLICK, onAreaMouseOutHandler);
					(activeBlock.openView_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
					break;
				
				case OPEN_AREA:
					trace("open -> close");
					activeBlock.modalWindow_btn.useHandCursor = false;	
					activeBlock.modalWindow_btn.removeEventListener(MouseEvent.CLICK, onAreaMouseOutHandler);
					(activeBlock.openView_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
					activeBlock.gotoAndStop("close");
					statusArea = CLOSE_AREA;
					(activeBlock.closeView_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onAreaMouseEventHandler);
					activeBlock.closeView_btn.addEventListener(MouseEvent.MOUSE_OUT, onAreaMouseOutHandler);
					activeBlock.closeView_btn.addEventListener(MouseEvent.MOUSE_OVER, onAreaMouseOverHandler);
					break;
				
			}
		}
		
		private function onAreaOutHandler(evt:MouseEvent):void
		{
			trace("WeSectionMovie->onAreaOutHandler()");
		}
		
		private function onMenuMouseOverHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = menu_mc[id + "_mc"] as MovieClip;
			trace(mc.name);
			mc.gotoAndStop("over");
		}
		
		private function onMenuMouseOutHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = menu_mc[id + "_mc"] as MovieClip;
			trace(mc.name);
			mc.gotoAndStop("up");
		}
		
		private function onHelloClickHandler(evt:Event):void
		{
			trace("HomeSectionMovie->onHelloClickHandler()");	
			dispatchEvent(new Event(TableDataManager.HELLO_WINDOW));
		}
		
		private function onMenuClickHandler(evt:MouseEvent):void 
		{
			trace("WeSectionMovie->onMenuClickHandler()");	
			
			// Declaracion de variables
			var destination:String;
			var subdestination:String;
			var action:String;
			var type:String;
			
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));					
			switch(id)
			{			
				case HomeSectionController.SECTION_NAME:
					destination = TableDataManager.SECTION_HOME;
					subdestination = null;
					action = TableDataManager.LOAD_HOME_SECTION;
					type = LoaderManager.SWF_TYPE;					
					break;				
				case WeSectionController.SECTION_NAME:					
					destination = TableDataManager.SECTION_WE;
					subdestination = null;
					action = TableDataManager.LOAD_WE_SECTION;
					type = LoaderManager.SWF_TYPE;					
					break;
				case LikeSectionController.SECTION_NAME:
					destination = TableDataManager.SECTION_LIKE;
					subdestination = null;
					action = TableDataManager.LOAD_LIKE_SECTION;
					type = LoaderManager.SWF_TYPE;
					break;
				case SharingSectionController.SECTION_NAME:
					destination = TableDataManager.SECTION_SHARING;
					subdestination = null;
					action = TableDataManager.LOAD_SHARING_SECTION;
					type = LoaderManager.SWF_TYPE;
					break;
				case ExperiencesSectionController.SECTION_NAME:
					destination = TableDataManager.SECTION_EXPERIENCES;
					subdestination = null;
					action = TableDataManager.LOAD_EXPERIENCES_SECTION;
					type = LoaderManager.SWF_TYPE;
					break;
				case AwardsSectionController.SECTION_NAME:
					destination = TableDataManager.SECTION_AWARDS;
					subdestination = null;
					action = TableDataManager.LOAD_AWARDS_SECTION;
					type = LoaderManager.SWF_TYPE;
					break;
				default: 					
					throw new Error("ID de seccion desconocida: " + id);				
			}
			
			var dataEventObject:DataEventObject = new DataEventObject(origin, destination, action, type);
			trace(dataEventObject);
			
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			dispatchEvent(actionEvent);			
		}
	}
}