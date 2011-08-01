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
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class HomeSectionMovie extends MovieClip
	{			
		private static const BLOCK_COUNT:uint = 107;		
		private var origin:String;		
		
		public function HomeSectionMovie() 
		{
			trace("HomeSectionMovie->HomeSectionMovie()");			
			super();						
			
			this.origin = TableDataManager.SECTION_HOME;
			homeViewer_mc.visualLoader_mc.visible = false;
			
			// Configurando cuadricula
			configGrid();

			// Configurando detectores de eventos
			configHandlers();
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
			
			// IMAGE VIEWER
						
			// MouseOver Handler
			homeViewer_mc.prev_btn.addEventListener(MouseEvent.MOUSE_OVER, onImageViewerMouseOverHandler);
			homeViewer_mc.next_btn.addEventListener(MouseEvent.MOUSE_OVER, onImageViewerMouseOverHandler);
			
			// MouseOut Handler
			homeViewer_mc.prev_btn.addEventListener(MouseEvent.MOUSE_OUT, onImageViewerMouseOutHandler);
			homeViewer_mc.next_btn.addEventListener(MouseEvent.MOUSE_OUT, onImageViewerMouseOutHandler);
			
			// Click Handler
			homeViewer_mc.prev_btn.addEventListener(MouseEvent.CLICK, onImageViewerClickHandler);
			homeViewer_mc.next_btn.addEventListener(MouseEvent.CLICK, onImageViewerClickHandler);
			
			// LINKS DESTACADOS
			
			// Click Handler
			homeViewer_mc.case_btn.addEventListener(MouseEvent.CLICK, onGreatButtonClickHandler);
			homeViewer_mc.post_btn.addEventListener(MouseEvent.CLICK, onGreatButtonClickHandler);				
		}
		
		private function configGrid():void 
		{
			for(var i:uint = 0; i <= BLOCK_COUNT; i++) {
				var alphaValue:Number = Math.random();
				if(alphaValue > 0.5)
					alphaValue = alphaValue - 0.5;		
				(grid_mc["block_" + i] as MovieClip).alpha = alphaValue;		
			}
		}
		
		private function onMenuMouseOverHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = menu_mc[id + "_mc"] as MovieClip;
			mc.gotoAndStop("over");
		}
		
		private function onMenuMouseOutHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = menu_mc[id + "_mc"] as MovieClip;
			mc.gotoAndStop("up");
		}
		
		private function onHelloClickHandler(evt:Event):void
		{
			trace("HomeSectionMovie->onHelloClickHandler()");	
			dispatchEvent(new Event(TableDataManager.HELLO_WINDOW));
		}
		
		private function onMenuClickHandler(evt:MouseEvent):void 
		{
			trace("HomeSectionMovie->onMenuClickHandler()");			
			
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
		
		private function onImageViewerMouseOverHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = homeViewer_mc[id + "_mc"] as MovieClip;
			mc.gotoAndStop("over");
		}
		
		private function onImageViewerMouseOutHandler(evt:MouseEvent):void 
		{
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			var mc:MovieClip = homeViewer_mc[id + "_mc"] as MovieClip;
			mc.gotoAndStop("up");
		}
		
		private function onImageViewerClickHandler(evt:MouseEvent):void 
		{
			trace("HomeSectionMovie->onImageViewerClickHandler()");
			
			// Declaracion de variables
			var destination:String;
			var subdestination:String;
			var action:String;
			var type:String;	
			
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			switch(id)
			{
				case "next":
					destination = TableDataManager.SECTION_HOME;
					subdestination = TableDataManager.HOME_VIEWER;
					action = TableDataManager.LOAD_NEXT_GREAT;
					type = LoaderManager.SWF_TYPE;		
					break;
				
				case "prev":
					destination = TableDataManager.SECTION_HOME;
					subdestination = TableDataManager.HOME_VIEWER;
					action = TableDataManager.LOAD_PREV_GREAT;
					type = LoaderManager.SWF_TYPE;
					break;
				
				default:
					throw new Error("Unknow navigation button");
			}
			
			var dataEventObject:DataEventObject = new DataEventObject(origin, destination, action, type, subdestination);
			trace(dataEventObject);
			
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			dispatchEvent(actionEvent);	
		}			
		
		private function onGreatButtonClickHandler(evt:MouseEvent):void
		{
			trace("HomeSectionMovie->onGreatButtonClickHandler()");		
			
			var instanceName:String = (evt.target as SimpleButton).name;
			var id:String = instanceName.substr(0, instanceName.indexOf("_"));
			switch(id)
			{
				case "case":
					trace("Case button cliked");
					dispatchEvent(new Event(TableDataManager.SHOW_CLIENT_DETAILS));
					break;
				
				case "post":
					trace("Post button cliked");
					dispatchEvent(new Event(TableDataManager.VIEW_CASE_IN_BLOG));
					break;
				
				default:
					throw new Error("Boton de link de destacados desconocido: " + id);
			}	
		}
	}
}

