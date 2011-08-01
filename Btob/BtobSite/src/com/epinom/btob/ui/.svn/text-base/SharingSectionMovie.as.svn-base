package com.epinom.btob.ui
{
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.LoaderManager;
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class SharingSectionMovie extends MovieClip
	{
		private static const BLOCK_COUNT:uint = 107;
		private var origin:String;	
		
		public function SharingSectionMovie()
		{
			trace("SharingSectionMovie->SharingSectionMovie()");		
			super();						
			
			this.origin = TableDataManager.SECTION_SHARING;			
			
			// Configurando cuadricula
			configGrid();
			
			// Configurando detectores de eventos
			configHandlers();
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
			
			// SOCIAL
			
			// Click Handler
			linkedin_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			linkedin_mc.go_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			facebook_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			youtube_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			blog_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			twitter_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			buzz_mc.link_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			buzz_mc.go_btn.addEventListener(MouseEvent.CLICK, onSocialClickHandler);
			
			// Click social items
			facebook_mc.itemA_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
			facebook_mc.itemB_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
			blog_mc.itemA_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
			blog_mc.itemB_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
			twitter_mc.itemA_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
			twitter_mc.itemB_btn.addEventListener(MouseEvent.CLICK, onSocialItemsClickHandler);
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
			trace("SharingSectionMovie->onMenuClickHandler()");	
			
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
		
		private function onSocialClickHandler(evt:MouseEvent):void
		{
			trace("SharingSectionMovie->onSocialClickHandler()");	
			
			// Obteniendo el identificador
			var socialID:String = (evt.target as SimpleButton).parent.name.substr(0, (evt.target as SimpleButton).parent.name.indexOf("_"));
			trace(socialID);
			
			var url:String;
			switch(socialID)
			{
				case "facebook":
					url = "http://www.facebook.com/btobfans?ref=ts";
					break;
				
				case "youtube":
					url = "http://www.youtube.com/user/btobTube";
					break;
				
				case "twitter":
					url = "http://twitter.com/btob_words";
					break;
				
				case "blog":
					url = "http://blog.btob.es/";
					break;
				
				case "linkedin":
					url = "http://www.linkedin.com/company/1309534";
					break;
				
				case "buzz":
					url = "https://www.google.com/profiles/btobmk";
					break;
				
				default:
					throw new Error("SocialID desconocido: " + socialID);
			}
			
			navigateToURL(new URLRequest(url));
		}
		
		private function onSocialItemsClickHandler(evt:MouseEvent):void
		{
			trace("SharingSectionMovie->onSocialItemsClickHandler()");	
			
			
			// Obteniendo el identificador
			var itemID:String = (evt.target as SimpleButton).name.substr(0, (evt.target as SimpleButton).name.indexOf("_"));
			trace(itemID);
			
			var url:String = "";
			switch(itemID)
			{
				case "itemA":
					url = ((evt.target as SimpleButton).parent as MovieClip).urlItemA;
					break;
				
				case "itemB":
					url = ((evt.target as SimpleButton).parent as MovieClip).urlItemB;
					break;
				
				default:
					throw new Error("Elemento desconodico: " + itemID);
			}
			
			navigateToURL(new URLRequest(url));
		}
	}
}