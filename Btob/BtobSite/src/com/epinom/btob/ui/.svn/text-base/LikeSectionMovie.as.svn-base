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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class LikeSectionMovie extends MovieClip
	{
		private static const BLOCK_COUNT:uint = 107;
		private static const COLOR_BLOCK_COUNT:uint = 14;
		private static const SERVICES_COUNT:uint = 5;
		
		private var _origin:String;	
		private var _colorsBlockList:Array;
		private var _colorTags:Array;
		private var _idBlockList:Array;
		private var _colorSequenceList:Array;
		private var _colorAnswerList:Array;
		private var _correctAnswerList:Array;
		private var _servicesMovieList:Array;
		private var _activeIndexService:uint;
		private var _activeMovieService:MovieClip;
		
		public function LikeSectionMovie()
		{
			trace("LikeSectionMovie->LikeSectionMovie()");	
			super();						
			
			dialogMessage_mc.visible = false;
			_origin = LikeSectionController.SECTION_NAME;	
			_colorSequenceList = new Array();
			_colorAnswerList = new Array();
			_correctAnswerList = new Array;			
			_activeIndexService = 0;
			_activeMovieService = null;
			
			// Configurando cuadricula
			configGrid();
			
			// Configurando servicios (movieclips)
			configServices();
			
			// Configurando cuadros de colores
			configColorsBlock();
			
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
		
		private function configColorsBlock():void 
		{
			// Inicializando lista de bloques de colores
			_colorsBlockList = new Array();
			
			for(var i:uint = 0; i <= COLOR_BLOCK_COUNT; i++) 
			{	
				var colorBlock_mc:MovieClip = this["colorBlock_" + i] as MovieClip;
				colorBlock_mc.btn.enabled = false;	
				colorBlock_mc.btn.useHandCursor = false;		
				colorBlock_mc.visible = false;
				colorBlock_mc.colorTag = "";				
				_colorsBlockList.push(colorBlock_mc);
			}
			
			trace("Color block count: " + _colorsBlockList.length);
		}
		
		private function configServices():void
		{
			// Inicializando lista de servicios (movieclips)
			_servicesMovieList = new Array();

			// Adicionando movieclips
			for(var i:uint = 0; i <=  SERVICES_COUNT; i++) {
				var service_mc:MovieClip = this["service_" + i] as MovieClip;
				service_mc.visible = false;
				service_mc.addEventListener(MouseEvent.CLICK, nextService);
				_servicesMovieList.push(service_mc);
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

			// GO
			go_mc.btn.addEventListener(MouseEvent.CLICK, startGame);					
		}	
		
		private function nextService(evt:Event):void
		{
			trace("LikeSectionMovie->nextService()");
			
			// Invisibilizando servicio actual
			visualizeService(_activeIndexService, false);
			
			// Actualizando indice activo
			_activeIndexService = (_activeIndexService + 1) % _servicesMovieList.length;
			
			// Visibilizando servicio actual
			visualizeService(_activeIndexService, true);
		}
		
		private function startGame(evt:MouseEvent):void 
		{		
			trace("LikeSectionMovie->startGame()");
			
			// Reiniciando las listas
			_colorTags = new Array("blue", "yellow", "green", "red");
			_idBlockList = new Array(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14);
			
			// Invisibilizando goButton
			go_mc.btn.removeEventListener(MouseEvent.CLICK, startGame);			
			go_mc.btn.enabled = false;
			go_mc.visible = false;
			
			// Declarando timer
			var timer:Timer = new Timer(1*1000, 4);
			timer.addEventListener(TimerEvent.TIMER, showColors);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, intervalShowColor);
			timer.start();	
		}
		
		private function showColors(evt:TimerEvent):void
		{
			trace("LikeSectionMovie->showColors()");
			
			// Obteniendo un indice aleatorio para configurar movieclip
			var index:uint = uint(SiteManager.randomNumber(0, 14));
			
			// Extrayendo indice de la lista 
			var id:uint = _idBlockList.splice(index, 1);
			
			// Obteniendo movieclip con ese identificador
			var colorBlock_mc = this["colorBlock_" + id] as MovieClip;
			
			// Construyendo secuencia de cuadros de colores
			_colorSequenceList.push(colorBlock_mc);
			
			// Extrayendo etiqueta de color de la lista
			var colorTag:String = _colorTags.shift();
			
			// Visualizando movieclip
			colorBlock_mc.gotoAndStop(colorTag);
			colorBlock_mc.btn.enabled = false;	
			colorBlock_mc.btn.useHandCursor = false;		
			colorBlock_mc.visible = true;
			colorBlock_mc.colorTag = colorTag;

			trace("id: " + id);
			trace("colorBlock_mc: " + colorBlock_mc);
			trace("colorTag: " + colorTag);
			trace("colorSequence: " + _colorSequenceList.toString());
		}
		
		private function intervalShowColor(evt:Event):void
		{
			trace("LikeSectionMovie->intervalShowColor()");
			
			// Declarando timer
			var timer:Timer = new Timer(2*1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideColors);
			timer.start();
		}
		
		private function hideColors(evt:Event):void
		{
			trace("LikeSectionMovie->hideColors()");
			
			// Recorriendo lista de cuadros de colores
			for(var i:uint = 0; i < _colorsBlockList.length; i++) 
			{
				// Obteniendo bloque de color
				var colorBlock_mc:MovieClip = _colorsBlockList[i] as MovieClip;
				
				// Cambiando propiedades del cuadro de color
				colorBlock_mc.gotoAndStop("transparent");
				colorBlock_mc.btn.enabled = true;
				colorBlock_mc.btn.useHandCursor = false;	
				colorBlock_mc.btn.addEventListener(MouseEvent.CLICK, matchAnswers);
				colorBlock_mc.visible = true;
			}
		}
		
		private function matchAnswers(evt:MouseEvent):void 
		{
			trace("LikeSectionMovie->matchAnswers()");
			
			// Obteniendo bloque de color clickado
			var userColorBlock_mc:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			var appColorBlock_mc:MovieClip = _colorSequenceList[0] as MovieClip;
			
			// Comparando movieclips
			if(userColorBlock_mc.name == appColorBlock_mc.name)
			{
				trace("La respuesta coincide !!!");
				
				// Eliminar movieclip de la secuencia
				var colorBlock_mc:MovieClip = _colorSequenceList.shift();
				_colorAnswerList.push(colorBlock_mc);
				
				// Visualizar movieclip con el color mostrado inicialmente
				trace("colorTag: " + colorBlock_mc.colorTag);
				colorBlock_mc.gotoAndStop(colorBlock_mc.colorTag);
				colorBlock_mc.btn.enabled = false;
				colorBlock_mc.btn.useHandCursor = false;	
				colorBlock_mc.btn.removeEventListener(MouseEvent.CLICK, matchAnswers);
				colorBlock_mc.visible = true;
				
				// Adicionando movieclip a la lista de respuestas correctas 
				_correctAnswerList.push(colorBlock_mc);
				
				if(_colorSequenceList.length == 0) {
					var timer:Timer = new Timer(2*1000, 1);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, showServices);
					timer.start();
				}
					
			}
			else
			{
				// Mostrande mensaje con opciones 
				dialogMessage_mc.visible = true;
				
				// Configurando listeners de botones
				dialogMessage_mc.verServicios_btn.addEventListener(MouseEvent.CLICK, showServices);
				dialogMessage_mc.volverIntentarlo_btn.addEventListener(MouseEvent.CLICK, tryAgain);
				
				// Reiniciando cuadros de colores
				configColorsBlock();
			}
		}
		
		private function showServices(evt:Event):void
		{
			trace("LikeSectionMovie->showServices()");
			
			// Invisibilizando dialog
			dialogMessage_mc.visible = false;
			
			// Invisibilizar todos los cuadros de colores
			for(var i:uint = 0; i < _correctAnswerList.length; i++) 
			{
				// Obteniendo movieclip del cuadro de color de las respuestas correctas
				var mc:MovieClip = _correctAnswerList[i] as MovieClip;
				
				// Cambiando propiedades del cuadro de color de las respuestas correctas
				mc.gotoAndStop("transparent");
				mc.btn.enabled = false;
				mc.btn.useHandCursor = false;	
				mc.btn.removeEventListener(MouseEvent.CLICK, matchAnswers);
				mc.visible = false;
			}
			
			// Mostrar movieclip del servicio
			visualizeService(0, true);
		}
		
		public function visualizeService(index:uint, visibility:Boolean):void 
		{	
			trace("LikeSectionMovie->visualizeService()");
			var mc:MovieClip = _servicesMovieList[index] as MovieClip;
			mc.visible = visibility;			
			_activeMovieService = mc;			
		}
		
		private function tryAgain(evt:Event):void
		{
			trace("LikeSectionMovie->tryAgain()");
			
			// Invisibilizando mensaje con opciones
			dialogMessage_mc.visible = false;
			
			// Reiniciando listas
			_colorSequenceList = new Array();
			_colorAnswerList = new Array();
			_correctAnswerList = new Array;	
			
			// Reiniciando variables de elementos activos
			_activeIndexService = 0;
			_activeMovieService = null;
			
			// Actualizando boton GO
			go_mc.btn.addEventListener(MouseEvent.CLICK, startGame);			
			go_mc.btn.enabled = true;
			go_mc.visible = true;
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
			trace("LikeSectionMovie->onMenuClickHandler()");	
			
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
			
			var dataEventObject:DataEventObject = new DataEventObject(_origin, destination, action, type);
			trace(dataEventObject);
			
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			dispatchEvent(actionEvent);			
		}
	}
}