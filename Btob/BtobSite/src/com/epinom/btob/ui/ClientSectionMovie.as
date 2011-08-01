package com.epinom.btob.ui {
	
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

	public class ClientSectionMovie extends MovieClip 
	{
		private static const BLOCK_COUNT:uint = 107;
		private static const TEMPLATES_COUNT:uint = 5;
		private var origin:String;	
		
		public function ClientSectionMovie() 
		{
			trace("ClientSectionMovie->ClientSectionMovie()");		
			super();						 
			
			this.origin = TableDataManager.SECTION_CLIENT;		
			
			// Configurando cuadricula
			configGrid();
			
			// COnfigurando interface
			configInterface();
			
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
		
		private function configInterface():void
		{
			// Invisibilizando templates
			for(var i:uint = 1; i <= TEMPLATES_COUNT; i++)
			{
				var template:MovieClip = this["template" + i + "Elements_mc"] as MovieClip;
				template.visible = false;
			}
		}
		
		private function configHandlers():void
		{
			// Click Handler
			backClientSection_btn.addEventListener(MouseEvent.CLICK, onBackClickHandler);			
		}
		
		private function onBackClickHandler(evt:MouseEvent):void 
		{
			trace("ClientSectionMovie->onBackClickHandler()");

			// Configurando variables
			var destination:String = SiteManager.getInstance().getBackSectionController().sectionVO.name;
			var subdestination:String = null;
			var type:String = LoaderManager.SWF_TYPE;;		
			var action:String;
			
			switch(destination)
			{
				case TableDataManager.SECTION_HOME:
					action = TableDataManager.LOAD_HOME_SECTION;
					break;
				
				case TableDataManager.SECTION_WE:
					action = TableDataManager.LOAD_WE_SECTION;
					break;
				
				case TableDataManager.SECTION_LIKE:
					action = TableDataManager.LOAD_LIKE_SECTION;
					break;
				
				case TableDataManager.SECTION_SHARING:
					action = TableDataManager.LOAD_SHARING_SECTION;
					break;
				
				case TableDataManager.SECTION_EXPERIENCES:
					action = TableDataManager.LOAD_EXPERIENCES_SECTION;
					break;

				default:
					throw new Error("Unknow action");
			}

			var dataEventObject:DataEventObject = new DataEventObject(origin, destination, action, type);
			trace(dataEventObject);
			
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			dispatchEvent(actionEvent);	
		}
		
		
	}
}
