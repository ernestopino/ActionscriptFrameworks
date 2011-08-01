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
	
	public class ExperiencesSectionMovie extends MovieClip
	{
		private static const BLOCK_COUNT:uint = 107;
		private static const CLIENT_BLOCK_COUNT:uint = 12;
		private static const VIEW_BY_CLIENT:String = "byClient";
		private static const VIEW_BY_SERVICE:String = "byService";
		private static const VIEW_BY_POPULARITY:String = "byPopularity";
		private static const ROTATE_ALL:String = "rotateAll";
		private static const SMO:String = "smo";
		private static const AUDIOVISUAL_PRODUCTION:String = "audiovisualProduction";
		private static const BRAND_ENTERTEINMENT:String = "brandEnterteinment";
		private static const INTERACTIVE_EXPERIENCES:String = "interactiveExperiences";
		private static const PLATFORMS:String = "platforms";
		private static const APPS:String = "apps";
		
		private var origin:String;	
		private var _clientBlockList:Array;
		private var _actualView:Object;
		
		private var _isRotateAllClientBlocks:Boolean;
		private var _isRotateAllServiesBlocks:Boolean;
		private var _isRotateAllPopularityBlocks:Boolean;
		
		public function ExperiencesSectionMovie()
		{
			trace("ExperiencesSectionMovie->ExperiencesSectionMovie()");		
			super();						
			
			this.origin = TableDataManager.SECTION_EXPERIENCES;		
			_clientBlockList = new Array();	
			
			// Rotacion de los bloques
			_isRotateAllClientBlocks = false;
			_isRotateAllServiesBlocks = false;
			_isRotateAllPopularityBlocks = false;
			
			// Configurando interfaz
			configSubmenu();
			
			// Invisibilizando movieclip servicios
			experiencesByService.visible = false;
			experiencesByPopularity.visible = false;
			
			// Configurando cuadricula
			configGrid();
			
			// Listando movieclips que representan los clientes
			configClientBlocks();
			
			// Configurando vista por servicios
			configServicesView();
			
			// Configurando vista por popularidad
			configPopularityView();
			
			// Configurando detectores de eventos
			configHandlers();
		}
		
		public function get clientBlockList():Array { return _clientBlockList; }
		
		private function configSubmenu():void
		{
			// Inicializando vista
			_actualView = new Object();
			_actualView.id = VIEW_BY_CLIENT;
			_actualView.mc = experiencesByClient;
			_actualView.submenuButtonMC = submenu_mc.byClient_mc;
			
			// Actualizando boton correspondiente a la vista inicial
			submenu_mc.byClient_mc.gotoAndStop("over");
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
		
		private function configClientBlocks():void
		{
			for(var i:uint = 0; i <= CLIENT_BLOCK_COUNT; i++) 
			{
				var clientBlock_mc:MovieClip = experiencesByClient["client_" + i] as MovieClip;
				clientBlock_mc.projects.viewAll_btn.addEventListener(MouseEvent.CLICK, dispatchEventClientViewAll);	
				clientBlock_mc.projects.visible = false;
				clientBlock_mc.client.rotate.addEventListener(MouseEvent.CLICK, rotateClientBlock);				
				_clientBlockList.push(clientBlock_mc);
			}
		}	
		
		public function dispatchEventClientViewAll(evt:MouseEvent):void
		{
			// Obteniendo ID del cliente
			var clientBlock_mc:MovieClip = (evt.target as SimpleButton).parent.parent as MovieClip;			
			var index:int = clientBlock_mc.name.indexOf("_"); 
			var idClient:int = int(clientBlock_mc.name.substr(index + 1, clientBlock_mc.name.length));
			
			// Declaracion de variables
			var destination:String = TableDataManager.SECTION_CLIENT;
			var subdestination:String = null;
			var action:String = TableDataManager.LOAD_CLIENT_SECTION;
			var type:String = LoaderManager.SWF_TYPE;

			// Creando objeto de datos para el evento
			var dataEventObject:DataEventObject = new DataEventObject(origin, destination, action, type);
			dataEventObject.idClient = idClient;
			trace(dataEventObject);
			
			// Creando evento complejo
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			dispatchEvent(actionEvent);							
		}
		
		private function rotateClientBlock(evt:MouseEvent):void 
		{
			// Declarando movieclip
			var clientBlock_mc:MovieClip = null;
			
			// Obteniendo movieclip que representa un cliente
			if(evt != null)
				clientBlock_mc = (evt.target as SimpleButton).parent.parent as MovieClip;
			
			// Eliminando detectores de eventos
			clientBlock_mc.client.rotate.removeEventListener(MouseEvent.CLICK, rotateClientBlock);
			
			// Invisibilizando movieclip logotipo del cliente
			clientBlock_mc.client.visible = false;
			
			// Cambiando de estado, mostrando casos del cliente
			clientBlock_mc.projects.visible = true;
			
			// Configurando detector de eventos
			clientBlock_mc.projects.back.addEventListener(MouseEvent.CLICK, backToClientBlock);
		}
		
		private function backToClientBlock(evt:MouseEvent):void
		{
			// Obteniendo movieclip que representa un cliente
			var clientBlock_mc:MovieClip = (evt.target as SimpleButton).parent.parent as MovieClip; 
			
			// Eliminando detectores de eventos
			clientBlock_mc.projects.back.removeEventListener(MouseEvent.CLICK, backToClientBlock);
			
			// Invisibilizando movieclip logotipo del cliente
			clientBlock_mc.projects.visible = false;
			
			// Cambiando de estado, mostrando casos del cliente
			clientBlock_mc.client.visible = true;
			
			// Configurando detector de eventos
			clientBlock_mc.client.rotate.addEventListener(MouseEvent.CLICK, rotateClientBlock);
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
			
			// SUBMENU
			
			// MouseOver Handler
			submenu_mc.byClient_mc.btn.addEventListener(MouseEvent.MOUSE_OVER, onSubmenuMouseOverHandler);
			submenu_mc.byService_mc.btn.addEventListener(MouseEvent.MOUSE_OVER, onSubmenuMouseOverHandler);
			submenu_mc.byPopularity_mc.btn.addEventListener(MouseEvent.MOUSE_OVER, onSubmenuMouseOverHandler);
			submenu_mc.rotateAll_mc.btn.addEventListener(MouseEvent.MOUSE_OVER, onSubmenuMouseOverHandler);
			
			// MouseOut Handler
			submenu_mc.byClient_mc.btn.addEventListener(MouseEvent.MOUSE_OUT, onSubmenuMouseOutHandler);
			submenu_mc.byService_mc.btn.addEventListener(MouseEvent.MOUSE_OUT, onSubmenuMouseOutHandler);
			submenu_mc.byPopularity_mc.btn.addEventListener(MouseEvent.MOUSE_OUT, onSubmenuMouseOutHandler);
			submenu_mc.rotateAll_mc.btn.addEventListener(MouseEvent.MOUSE_OUT, onSubmenuMouseOutHandler);
			
			// Click Handler
			submenu_mc.byClient_mc.btn.addEventListener(MouseEvent.CLICK, onSubmenuClickHandler);
			submenu_mc.byService_mc.btn.addEventListener(MouseEvent.CLICK, onSubmenuClickHandler);
			submenu_mc.byPopularity_mc.btn.addEventListener(MouseEvent.CLICK, onSubmenuClickHandler);
			submenu_mc.rotateAll_mc.btn.addEventListener(MouseEvent.CLICK, onSubmenuClickHandler);
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
			trace("ExperiencesSectionMovie->onMenuClickHandler()");	
			
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
		
		private function onSubmenuMouseOverHandler(evt:MouseEvent):void 
		{
			// Obteniendo movieclip contenedor del boton target
			var mcButtonContainer:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			// Obteniendo vista del boton mediante trabajo de cadena
			var submenuButtonView:String = mcButtonContainer.name.substr(0, mcButtonContainer.name.indexOf("_"));
			
			// Verificando vista actual
			if(submenuButtonView != _actualView.id)
				mcButtonContainer.gotoAndStop("over");
		}
		
		private function onSubmenuMouseOutHandler(evt:MouseEvent):void 
		{
			// Obteniendo movieclip contenedor del boton target
			var mcButtonContainer:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			// Obteniendo vista del boton mediante trabajo de cadena
			var submenuButtonView:String = mcButtonContainer.name.substr(0, mcButtonContainer.name.indexOf("_"));
			
			// Verificando vista actual
			if(submenuButtonView != _actualView.id)
				mcButtonContainer.gotoAndStop("out");
		}
		
		private function onSubmenuClickHandler(evt:MouseEvent):void 
		{
			// Obteniendo movieclip contenedor del boton target
			var mcButtonContainer:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			// Obteniendo vista del boton mediante trabajo de cadena
			var submenuButtonView:String = mcButtonContainer.name.substr(0, mcButtonContainer.name.indexOf("_"));
			trace(submenuButtonView);
			
			// Verificando vista actual
			if(submenuButtonView != _actualView.id) 
			{
				// Dejando fuera del cambio de vista la accion de rotar todos los elementos
				if(submenuButtonView != ROTATE_ALL) 
				{
					// Invisibilizando la vista anterior
					(_actualView.mc as MovieClip).visible = false;
					
					// Cambiando el estado del boton del submenu de la vista anterior
					(_actualView.submenuButtonMC as MovieClip).gotoAndStop("up");
					
					// Haciendo visible la vista correspondiente
					switch(submenuButtonView) 
					{
						case VIEW_BY_CLIENT:
							experiencesByClient.visible = true;
							_actualView.id = VIEW_BY_CLIENT;
							_actualView.mc = experiencesByClient;
							_actualView.submenuButtonMC = submenu_mc.byClient_mc; 
							submenu_mc.rotateAll_mc.visible = true;
							break;											
						
						case VIEW_BY_SERVICE:
							experiencesByService.visible = true;
							experiencesByService.cases.visible = true;
							_actualView.id = VIEW_BY_SERVICE;
							_actualView.mc = experiencesByService;
							_actualView.submenuButtonMC = submenu_mc.byService_mc; 	
							submenu_mc.rotateAll_mc.visible = true;
							break;
						
						case VIEW_BY_POPULARITY:
							experiencesByPopularity.visible = true;
							_actualView.id = VIEW_BY_POPULARITY;
							_actualView.mc = experiencesByPopularity;
							_actualView.submenuButtonMC = submenu_mc.byPopularity_mc; 
							submenu_mc.rotateAll_mc.visible = false;
							break;
						
						default:
							throw new Error("Tipo de vista desconocida (" + submenuButtonView + "), en la seccion EXPERIENCES");
					}
				}
				else // Rotando todos los elementos de la vista
				{
					// Verficando tipo de vista actual
					switch(_actualView.id)
					{
						case VIEW_BY_CLIENT:							
								this.rotateAllClientBlocks();
							break;											
						
						case VIEW_BY_SERVICE:
								this.rotateAllServicesBlocks();						
							break;
						
						default:
							throw new Error("Tipo de vista desconocida (" + _actualView.id + "), en la seccion EXPERIENCES");
					}
				}
			}
		}
		
		private function rotateAllClientBlocks():void
		{
			// Declarando movieclip de referencia al bloque
			var clientBlock_mc:MovieClip = null; 
			
			// Comprobando estado de la rotacion de los bloques
			if(!_isRotateAllClientBlocks)
			{
				// Recorriendo la vista de clientes y enviando eventos como si se hubiese clickado en cado uno de sus bloques
				for(var i:uint = 0; i <= CLIENT_BLOCK_COUNT; i++)
				{
					// Obteniendo bloque
					clientBlock_mc = experiencesByClient["client_" + i] as MovieClip;

					// Eliminando detectores de eventos
					clientBlock_mc.client.rotate.removeEventListener(MouseEvent.CLICK, rotateClientBlock);
					
					// Invisibilizando movieclip logotipo del cliente
					clientBlock_mc.client.visible = false;
					
					// Cambiando de estado, mostrando casos del cliente
					clientBlock_mc.projects.visible = true;
					
					// Configurando detector de eventos
					clientBlock_mc.projects.back.addEventListener(MouseEvent.CLICK, backToClientBlock);
				}
				
				// Actualizando variable de control de rotacion de los casos
				_isRotateAllClientBlocks = true;
			}
			else
			{
				// Recorriendo la vista de clientes y enviando eventos como si se hubiese clickado en cado uno de sus bloques
				for(var j:uint = 0; j <= CLIENT_BLOCK_COUNT; j++)
				{
					// Obteniendo bloque
					clientBlock_mc = experiencesByClient["client_" + j] as MovieClip;

					// Eliminando detectores de eventos
					clientBlock_mc.projects.back.removeEventListener(MouseEvent.CLICK, backToClientBlock);
					
					// Invisibilizando movieclip logotipo del cliente
					clientBlock_mc.projects.visible = false;
					
					// Cambiando de estado, mostrando casos del cliente
					clientBlock_mc.client.visible = true;
					
					// Configurando detector de eventos
					clientBlock_mc.client.rotate.addEventListener(MouseEvent.CLICK, rotateClientBlock);
				}
				
				// Actualizando variable de control de rotacion de los casos
				_isRotateAllClientBlocks = false;
			}
		}
		
		private function rotateAllServicesBlocks():void
		{			
			// Declarando movieclip de referencia al bloque
			var serviceBlock_mc:MovieClip = null; 
			
			// Comprobando estado de la rotacion de los bloques
			if(!_isRotateAllServiesBlocks)
			{
				// Recorriendo los bloques de la vista de servicios y configurando su visibilidad
				experiencesByService.services.smo.visible = false;						
				experiencesByService.services.audiovisualProduction.visible = false;
				experiencesByService.services.brandEnterteinment.visible = false;
				experiencesByService.services.interactivesExperiences.visible = false;
				experiencesByService.services.platforms.visible = false;
				experiencesByService.services.apps.visible = false;
				
				experiencesByService.cases.smo.visible = true;						
				experiencesByService.cases.audiovisualProduction.visible = true;
				experiencesByService.cases.brandEnterteinment.visible = true;
				experiencesByService.cases.interactivesExperiences.visible = true;
				experiencesByService.cases.platforms.visible = true;
				experiencesByService.cases.apps.visible = true;
				
				// Actualizando variable de control de rotacion de los casos
				_isRotateAllServiesBlocks = true;
			}
			else
			{
				// Recorriendo los bloques de la vista de servicios y configurando su visibilidad
				experiencesByService.services.smo.visible = true;						
				experiencesByService.services.audiovisualProduction.visible = true;
				experiencesByService.services.brandEnterteinment.visible = true;
				experiencesByService.services.interactivesExperiences.visible = true;
				experiencesByService.services.platforms.visible = true;
				experiencesByService.services.apps.visible = true;
				
				experiencesByService.cases.smo.visible = false;						
				experiencesByService.cases.audiovisualProduction.visible = false;
				experiencesByService.cases.brandEnterteinment.visible = false;
				experiencesByService.cases.interactivesExperiences.visible = false;
				experiencesByService.cases.platforms.visible = false;
				experiencesByService.cases.apps.visible = false;
				
				
				// Actualizando variable de control de rotacion de los casos
				_isRotateAllServiesBlocks = false;
			}
		}
		
		private function configServicesView():void			
		{
			// Click Handlers
			experiencesByService.services.smo.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			experiencesByService.services.audiovisualProduction.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			experiencesByService.services.brandEnterteinment.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			experiencesByService.services.interactivesExperiences.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			experiencesByService.services.platforms.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			experiencesByService.services.apps.service_btn.addEventListener(MouseEvent.CLICK, onServiceClickHandler);
			
			// Invisibilizando todos movieclips de los casos
			experiencesByService.cases.smo.visible = false;
			experiencesByService.cases.audiovisualProduction.visible = false;
			experiencesByService.cases.brandEnterteinment.visible = false;
			experiencesByService.cases.interactivesExperiences.visible = false;
			experiencesByService.cases.platforms.visible = false;
			experiencesByService.cases.apps.visible = false;	
			
			// Rotate Handlers
			experiencesByService.cases.smo.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
			experiencesByService.cases.audiovisualProduction.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
			experiencesByService.cases.brandEnterteinment.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
			experiencesByService.cases.interactivesExperiences.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
			experiencesByService.cases.platforms.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
			experiencesByService.cases.apps.title_btn.addEventListener(MouseEvent.CLICK, onRotateServiceClickHandler);
		}
		
		private function onServiceClickHandler(evt:MouseEvent):void
		{			
			// Obteniendo movieclip asociado al servicio
			var serviceMC:MovieClip =(evt.target as SimpleButton).parent as MovieClip;
			serviceMC.visible = false;			
			
			// Obteniendo id del servicio
			var serviceID:String = serviceMC.name;
			trace(serviceID);
			
			// Obteniendo moviclip con los casos por el servicio en cuestion
			var caseMC:MovieClip = experiencesByService.cases[serviceID] as MovieClip;
			trace(caseMC);
			trace(caseMC.name);
			
			// Mostrar los casos del servicio especificado
			caseMC.visible = true;						
		}
		
		private function onRotateServiceClickHandler(evt:MouseEvent):void
		{
			// Obteniendo movieclip que representa todos los servicios
			var services_mc:MovieClip = (evt.target as SimpleButton).parent.parent.parent as MovieClip; 
			
			// Obteniendo movieclip que representa el servicio clickado
			var serviceBlok_mc:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			// Eliminando detectores de eventos
			(evt.target as SimpleButton).removeEventListener(MouseEvent.CLICK, backToClientBlock);
			
			// Cambiando visibilidad de los componentes
			(services_mc.services[serviceBlok_mc.name] as MovieClip).visible = true;
			(services_mc.cases[serviceBlok_mc.name] as MovieClip).visible = false;					
			
			// Configurando detector de eventos
			(services_mc.services[serviceBlok_mc.name].service_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onServiceClickHandler);
		}
		
		private function configPopularityView():void			
		{
			
		}
	}
}