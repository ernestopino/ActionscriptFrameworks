package com.epinom.btob.ui
{
	import caurina.transitions.Tweener;
	
	import com.digitalsurgeons.loading.BulkLoader;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.CaseVO;
	import com.epinom.btob.data.ClientVO;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.ExperiencesVO;
	import com.epinom.btob.data.ItemGalleryVO;
	import com.epinom.btob.data.ItemSocialVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.SocialVO;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.LoaderManager;
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	import com.epinom.btob.utils.XMLParser;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class ClientSectionController implements ISectionController
	{
		private static var _instance:ClientSectionController = null;
		private static var _allowInstantiation:Boolean;
		
		public static const SECTION_NAME:String = "client";
		public static const SECTION_CONTROLLER:String = "clientSectionController";
		public static const TEMPLATES_COUNT:uint = 5;
		public static const IMAGE_TYPE:String = "image";
		public static const VIDEO_TYPE:String = "video";
		private static const UPDATE_TIME_SOCIAL_TOOLTIPS:uint = 10 * 1000;
		
		private var urlServerPath:String = "";
		
		private var _sectionVO:SectionVO;	
		private var _activeBackgroundId:uint;
		private var _activeLogoId:uint;
		private var _sectionMovie:MovieClip;
		private var _activeBackgroundImageContainer:Sprite;
		private var _activeLogoImageContainer:Sprite;
		private var _backgroundImageContainerList:Array;
		private var _logoImageContainerList:Array;
		private var _clientLogo_mc:MovieClip;
		
		private var _clientVOList:Array;
		private var _activeClient:ClientVO;
		private var _activeClientSubdestinationID:int;
		private var _activeTemplate:MovieClip;
		
		private var _activeTooltipAIndex:uint;
		private var _activeTooltipBIndex:uint;
		private var _activeTooltipCIndex:uint;
		private var _activeTooltipDIndex:uint;
		private var _timerSocialTooltips:Timer;
		
		// Variables de control para animacion de transiciones entre secciones
		private var _actualBackgroundContainer_sp:Sprite;
		
		public function ClientSectionController()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use ClientSectionController.getInstance() instead of new.");
			} else {				
				_sectionMovie = null;
				_activeBackgroundImageContainer = null;
				_backgroundImageContainerList = new Array();
				_activeLogoImageContainer = null;
				_logoImageContainerList = new Array();
				_clientVOList = new Array();
				_activeTemplate = null;
				_activeClientSubdestinationID = -1;
				
				_activeTooltipAIndex = 0;	
				_activeTooltipBIndex = 1;	
				_activeTooltipCIndex = 2;		
				_activeTooltipDIndex = 3;		
				_timerSocialTooltips = new Timer(UPDATE_TIME_SOCIAL_TOOLTIPS);	
				_timerSocialTooltips.addEventListener(TimerEvent.TIMER, onTimerSocialTooltips);
				
				_actualBackgroundContainer_sp = null;
			}
		}
		
		public static function getInstance():ClientSectionController 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new ClientSectionController();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get sectionVO():SectionVO { return _sectionVO; }
		public function set sectionVO(value:SectionVO):void { _sectionVO = value; }	
		
		public function get sectionMovie():MovieClip { return _sectionMovie; }
		public function set sectionMovie(value:MovieClip):void {  
			_sectionMovie = value;
			_sectionMovie.addEventListener(TableDataManager.SECTION_EVENT, onClientEventHandler, false, 0, true);
			
		}
		
		public function get activeClientSubdestinationID():int { return _activeClientSubdestinationID; }
		
		private function showTemplate(type:uint):void 
		{
			// Obteniendo plantilla segun tipo
			var template:MovieClip = _sectionMovie["template" + type + "Elements_mc"] as MovieClip;
			
			// Actualizando componentes de la interfaz
			this.updateInterfaceSection(template);	
			template.visible = true;
			
			// Actualizando plantilla actual
			_activeTemplate = template;
		}
		
		private function hideActiveTemplate():void {			
			_activeTemplate.visible = false;
		}
		
		public function activateSection(idClient:String = null, idCase:String = null):void
		{
			// Carga los datos de la seccion cliente segun el ID del cliente
			this.loadClientData(idClient, idCase);	
			
			/* Codigo utilizado para tracear la posicion de los backgrounds es la lista de visualizacion 
			trace("\n Antes:");
			var sp:Sprite = null;
			for(var i:uint = 0; i < SiteManager.getInstance().backgroundImageContainer.numChildren; i++) 
			{
			sp = SiteManager.getInstance().backgroundImageContainer.getChildAt(i) as Sprite;
			trace("backgroundImageContainer elemento ( nivel " + i + " ) : "  + sp.name + " [ visible = " + sp.visible + "]");
			}
			*/			
		}
		
		public function desactivateSection():void
		{
			// Invisibiliza todas sus secciones de informacion 	
			_sectionMovie.visible = false;
			for(var i:uint = 0; i < _backgroundImageContainerList.length; i++) {
				if((_backgroundImageContainerList[i] as Sprite) != null)
					(_backgroundImageContainerList[i] as Sprite).visible = false;
			}	
			for(var j:uint = 0; j < _logoImageContainerList.length; j++) {
				if((_logoImageContainerList[j] as Sprite) != null)
					(_logoImageContainerList[j] as Sprite).visible = false;
			}
		}
		
		public function addBackgroundImageContainer(backgroundImageContainer:DisplayObject, idClient:int = -1):void
		{
			trace("ClientSectionController->addBackgroundImageContainer()");		
			backgroundImageContainer.name = "clientBackgroundImageContainer_" + _backgroundImageContainerList.length;
			
			// Se almacenan los backgrounds en correspondencia con el cliente
			if(idClient != -1)
				_backgroundImageContainerList[idClient] = backgroundImageContainer;
			else
				_backgroundImageContainerList.push(backgroundImageContainer);
		}
		
		public function addLogoImageContainer(logoImageContainer:DisplayObject, idClient:int = -1):void
		{
			trace("ClientSectionController->addLogoImageContainer()");		
			logoImageContainer.name = "logoImageContainer_" + _logoImageContainerList.length;
			
			// Se almacenan los logos en correspondencia con el cliente
			if(idClient != -1)
				_logoImageContainerList[idClient] = logoImageContainer;
			else
				_logoImageContainerList.push(logoImageContainer);
		}
		
		public function updateClientImageInfo():void 
		{
			trace("ClientSectionController->updateClientImageInfo()");
			
			// Visualizando el background del cliente
			var backgroundImageContainer:Sprite = _backgroundImageContainerList[_activeBackgroundId] as Sprite;
			_activeBackgroundImageContainer = backgroundImageContainer;
			_activeBackgroundImageContainer.visible = true;
			
			// Visualizando el logo del cliente
			var logoImageContainer:Sprite = _logoImageContainerList[_activeLogoId] as Sprite;
			_activeLogoImageContainer = logoImageContainer;
			_activeLogoImageContainer.visible = true;
		}
		
		public function loadClientData(idClient:String = null, idCase:String = null):void
		{
			trace("ClientSectionController->loadClientData()");			
			
			// Obteniendo cliente 
			var clientVO:ClientVO = ExperiencesSectionController.getInstance().findClientByReference(idClient);
			
			// Verificando si existe el cliente
			if(clientVO == null)
				SiteManager.getInstance().showErrorWindow("No existe ningun cliente con ID: " + idClient);
			
			// Actualizando variables
			_activeClient = clientVO;
			
			
			// Obteniendo caso
			var findedCaseVO:CaseVO = null;
			if(idCase != null)
			{
				// Actualizando variables
				findedCaseVO = ExperiencesSectionController.getInstance().findCaseByReference(clientVO, idCase);
				trace(findedCaseVO);
				
				// Verficando que existe el caso en dicho cliente
				if(findedCaseVO == null)
					SiteManager.getInstance().showErrorWindow("No existe ningun caso con ID: " + idClient + "en cliente con ID: " + idClient);
				
				// Actualizando variables
				_activeClientSubdestinationID = findedCaseVO.id;
			}
			else
			{
				// Actualizando variables
				_activeClientSubdestinationID = -1;
			}			
			
			// Cargar cliente si NO ha sido cargado con anterioridad
			if(_clientVOList[clientVO.id] == null)
			{
				// Guardando cliente en la lista en la posicion correspondiente con su ID
				_clientVOList[clientVO.id] = _activeClient;
			
				// Obteniendo loader (BUlkLoader)
				var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
				
				// Adicionando objetos a la precarga
				bulkLoader.add(new URLRequest(this.urlServerPath + _activeClient.urlClient), {id: this.urlServerPath + _activeClient.urlClient });
				bulkLoader.add(new URLRequest(this.urlServerPath + _activeClient.urlImage), {id: this.urlServerPath + _activeClient.urlImage });
				
				// Recorriendo lista de casos del cliente
				for(var i:uint = 0; i < _activeClient.caseList.length; i++)
				{
					// Obteniendo caso
					var clientCase:CaseVO = _activeClient.caseList[i] as CaseVO;
					
					// Adicionando imagen miniatura del caso a la lista de descargas
					bulkLoader.add(new URLRequest(this.urlServerPath + clientCase.urlThumb), {id: this.urlServerPath + clientCase.urlThumb });
					
					// Recorriendo galleria de cada caso
					for(var j:uint = 0; j < clientCase.gallery.length; j++)
					{
						// Obteniendo elemento de la galeria
						var itemGallery:ItemGalleryVO = clientCase.gallery[j] as ItemGalleryVO;
						
						// Si el elemento de la galeria es de tipo imagen cargo la image, si es de tipo video no hace falta cargarlo pues lo hace el player de youtube embebido
						if(itemGallery.type == IMAGE_TYPE)
						{
							// Adicionando imagenes (thumb & image) del elemento de la galeria
							bulkLoader.add(new URLRequest(this.urlServerPath + itemGallery.thumb), {id: this.urlServerPath + itemGallery.thumb });
							bulkLoader.add(new URLRequest(this.urlServerPath + itemGallery.url), {id: this.urlServerPath + itemGallery.url });
						}									
					}
				}				
				
				// Mostrando el loader 
				SiteManager.getInstance().showLoader();
				
				// Configurando listeners
				bulkLoader.addEventListener(BulkLoader.COMPLETE, onClientDataLoadedHandler);
				bulkLoader.addEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);
				bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
				bulkLoader.start();	
			}
			else	// Si ha sido cargado con anterioridad, mostar su interfaz sin cargar sus datos
			{
				// Realizando animacion del objeto de loader visual
				SiteManager.getInstance().hideLoader();	
				
				// Actualizando contenedor de imagen para animacion de transiciones
				_actualBackgroundContainer_sp = _backgroundImageContainerList[_activeClient.id] as Sprite;
				
				// Visualizando background del cliente en cuestion
				(_backgroundImageContainerList[_activeClient.id] as Sprite).visible = true;							
				
				// Actualizando controlador de seccion activo en la clase principal
				SiteManager.getInstance().updateSectionController(this);
				
				// Actualizando interfaz de la seccion
				this.hideActiveTemplate();
				this.showTemplate(_activeClient.caseList.length);
				
				// Visualizando logo del cliente en cuestion
				var clientLogo_mc:MovieClip = _sectionMovie.clientLogo_mc as MovieClip;
				var logoImageContainer:Sprite = _logoImageContainerList[_activeClient.id] as Sprite;
				logoImageContainer.visible = true;
				
				// Actualizando logo activo
				_activeLogoImageContainer = logoImageContainer;
				
				// Cargando datos de las redes sociales en los componentes de las secciones
				loadTooltipsSocialData();
				
				// Hace visibles todas sus secciones de informacion
				_sectionMovie.visible = true;
				
				// Actualizando seccion actual
				SiteManager.getInstance().activeSection = _sectionMovie;
				
				// Si hay se ha enviado algun caso para mostrar
				if(_activeClientSubdestinationID != -1)
				{					
					//  Obteniendo identificados de caso
					var caseID:uint = _activeClientSubdestinationID;
					
					trace("Mostrar caso con ID: " + caseID);
					
					// Obteniendo objeto de datos del caso segun el ID del caso			
					var caseVO:CaseVO = _activeClient.caseList[caseID] as CaseVO;
					
					// Mostrando ventana modal con los detalles del caso
					SiteManager.getInstance().showModalWindow(findedCaseVO);
				}
				
				// Verificando si la transicion entre background no ha sido cancelada
				if(! HomeSectionController.getInstance().isTransitionCanceled)
				{
					/* Adicionando background al backgroundContainer principal (SiteManager).
					Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
					Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
					como consecuencia el elemento queda por enciama de los demas elementos
					*/
					var oldBackgroundContainer_sp:Sprite = SiteManager.getInstance().getOldBackgroundContainer();	
					oldBackgroundContainer_sp.visible = true;
					SiteManager.getInstance().backgroundImageContainer.addChild(oldBackgroundContainer_sp);
					
					// Transicion entre background de un destacado y el otro
					SiteManager.getInstance().playTransition(_actualBackgroundContainer_sp, oldBackgroundContainer_sp);
				}
			}
		}
		
		public function onClientDataLoadedHandler(evt:Event):void
		{
			trace("ClientSectionController->onClientDataLoadedHandler()");
			
			// Eliminando los listeners
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			bulkLoader.removeEventListener(BulkLoader.COMPLETE, onClientDataLoadedHandler);
			bulkLoader.removeEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);
			bulkLoader.removeEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			
			// Realizando animacion del objeto de loader visual
			SiteManager.getInstance().hideLoader();			
			
			// Inicializando contenedor
			var backgroundImageContainer_sp:Sprite = new Sprite();
			
			// Recuperando imagen cargada por el gestor de descargas multiples
			var img:Bitmap = bulkLoader.getBitmap(this.urlServerPath + _activeClient.urlImage);
			trace("Imagen de la seccion cliente: " + img);
			
			// Adicionando la imagen al contenedor de imagen
			backgroundImageContainer_sp.addChild(img);	
			
			// Actualizando contenedor de imagen para animacion de transiciones
			_actualBackgroundContainer_sp = backgroundImageContainer_sp;
			
			// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
			this.addBackgroundImageContainer(backgroundImageContainer_sp, _activeClient.id);
			
			// Visualizando background del cliente en cuestion
			(_backgroundImageContainerList[_activeClient.id] as Sprite).visible = true;
			
			// Adicionando el contenedor de imagen al contenedor principal (backgroundImagesContainer_sp)
			SiteManager.getInstance().backgroundImageContainer.addChild(backgroundImageContainer_sp);
		
			// Inicializando contenedor del logo
			var logoImageContainer_sp:Sprite = new Sprite();
			
			// Recuperando logo del cliente
			var logo:Bitmap = bulkLoader.getBitmap(this.urlServerPath + _activeClient.urlClient);
			trace("Logo de la seccion cliente: " + logo);
			
			// Adicionando la logo al contenedor de imagen
			logoImageContainer_sp.addChild(logo);	
			
			// Adicionando contenedor de imagen con el logo del cliente
			this.addLogoImageContainer(logoImageContainer_sp, _activeClient.id);
			
			// Adicionando logo del cliente a container
			(_sectionMovie.clientLogo_mc as MovieClip).addChild(logoImageContainer_sp);
			
			// Actualizando logoContainer activo
			_activeLogoImageContainer = logoImageContainer_sp;			
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// TODO: Actualizar interfaz de la seccion
			this.hideActiveTemplate();
			this.showTemplate(_activeClient.caseList.length);
			
			// Cargando datos de las redes sociales en los componentes de las secciones
			loadTooltipsSocialData();
			
			// Hace visibles todas sus secciones de informacion
			_sectionMovie.visible = true;
			
			// Actualizando seccion actual
			SiteManager.getInstance().activeSection = _sectionMovie;	
			
			// Si hay se ha enviado algun caso para mostrar
			if(_activeClientSubdestinationID != -1)
			{
				//  Obteniendo identificados de caso
				var caseID:uint = _activeClientSubdestinationID;
				
				trace("Mostrar caso con ID: " + caseID);
				
				// Obteniendo objeto de datos del caso segun el ID del caso			
				var caseVO:CaseVO = _activeClient.caseList[caseID] as CaseVO;
				
				// Mostrando ventana modal con los detalles del caso
				SiteManager.getInstance().showModalWindow(caseVO);
			}
			
			// Verificando si la transicion entre background no ha sido cancelada
			if(! HomeSectionController.getInstance().isTransitionCanceled)
			{
				/* Adicionando background al backgroundContainer principal (SiteManager).
				Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
				Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
				como consecuencia el elemento queda por enciama de los demas elementos
				*/
				var oldBackgroundContainer_sp:Sprite = SiteManager.getInstance().getOldBackgroundContainer();	
				oldBackgroundContainer_sp.visible = true;
				SiteManager.getInstance().backgroundImageContainer.addChild(oldBackgroundContainer_sp);
				
				// Transicion entre background de un destacado y el otro
				SiteManager.getInstance().playTransition(_actualBackgroundContainer_sp, oldBackgroundContainer_sp);
			}
		}
		
		public function buildSection(vo:SectionVO, idClient:String = null, idCase:String = null):void
		{
			// Actualizando campos
			_sectionVO = vo;
			
			// Obteniendo cliente 
			var clientVO:ClientVO = ExperiencesSectionController.getInstance().findClientByReference(idClient);
			
			// Verificando si existe el cliente
			if(clientVO == null)
				SiteManager.getInstance().showErrorWindow("No existe ningun cliente con ID: " + idClient);
			
			// Actualizando variables
			_activeClient = clientVO;
			_clientVOList[clientVO.id] = _activeClient;
			
			// Obteniendo caso
			var caseVO:CaseVO = null;
			if(idCase != null)
			{
				// Actualizando variables
				caseVO = ExperiencesSectionController.getInstance().findCaseByReference(clientVO, idCase);
				
				// Verficando que existe el caso en dicho cliente
				if(caseVO == null)
					SiteManager.getInstance().showErrorWindow("No existe ningun caso con ID: " + idClient + "en cliente con ID: " + idClient);
				
				// Actualizando variables
				_activeClientSubdestinationID = caseVO.id;
			}
			else
			{
				// Actualizando variables
				_activeClientSubdestinationID = -1;
			}
							
			// Creando un nuevo loader para ejecutar cargas
			SiteManager.getInstance().bulkLoader = new BulkLoader(SECTION_NAME); 
			
			// Obteniendo loader (BUlkLoader)
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);					
			
			// Verificando si esta activa la carga de imagenes desde el servidor 
			if(SiteManager.ACTIVE_SERVICE_SIDE)
				this.urlServerPath = TableDataManager.URL_PATH_SERVER;	
			
			// Adicionando objetos a la precarga
			bulkLoader.add(new URLRequest(_sectionVO.urlSWF), {id: _sectionVO.urlSWF });
			bulkLoader.add(new URLRequest(this.urlServerPath + _activeClient.urlClient), {id: this.urlServerPath + _activeClient.urlClient });
			bulkLoader.add(new URLRequest(this.urlServerPath + _activeClient.urlImage), {id: this.urlServerPath + _activeClient.urlImage });
			
			// Recorriendo lista de casos del cliente
			for(var i:uint = 0; i < _activeClient.caseList.length; i++)
			{
				// Obteniendo caso
				var clientCase:CaseVO = _activeClient.caseList[i] as CaseVO;
				
				// Adicionando imagen miniatura del caso a la lista de descargas
				bulkLoader.add(new URLRequest(this.urlServerPath + clientCase.urlThumb), {id: this.urlServerPath + clientCase.urlThumb });
				
				// Recorriendo galleria de cada caso
				for(var j:uint = 0; j < clientCase.gallery.length; j++)
				{
					// Obteniendo elemento de la galeria
					var itemGallery:ItemGalleryVO = clientCase.gallery[j] as ItemGalleryVO;
					
					// Si el elemento de la galeria es de tipo imagen cargo la image, si es de tipo video no hace falta cargarlo pues lo hace el player de youtube embebido
					if(itemGallery.type == IMAGE_TYPE)
					{
						// Adicionando imagenes (thumb & image) del elemento de la galeria
						bulkLoader.add(new URLRequest(this.urlServerPath + itemGallery.thumb), {id: this.urlServerPath + itemGallery.thumb });
						bulkLoader.add(new URLRequest(this.urlServerPath + itemGallery.url), {id: this.urlServerPath + itemGallery.url });
					}									
				}
			}
			
			// Configurando listeners
			bulkLoader.addEventListener(BulkLoader.COMPLETE, onBulkSectionLoadedHandler);
			bulkLoader.addEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);
			bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			bulkLoader.start();	
		}
		
		public function onBulkSectionLoadedHandler(evt:Event):void
		{
			trace("ClientSectionController->onBulkSectionLoadedHandler()");
			
			// Eliminando los listeners
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			bulkLoader.removeEventListener(BulkLoader.COMPLETE, onBulkSectionLoadedHandler);
			bulkLoader.removeEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);	
			bulkLoader.removeEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			
			// Realizando animacion del objeto de loader visual
			SiteManager.getInstance().hideLoader();
			
			// Inicializando contenedor de background
			var backgroundImageContainer_sp:Sprite = new Sprite();			
			
			// Recuperando background del cliente
			var img:Bitmap = bulkLoader.getBitmap(this.urlServerPath + _activeClient.urlImage);
			trace("Imagen de la seccion cliente: " + img);
						
			// Adicionando la imagen al contenedor de imagen
			backgroundImageContainer_sp.addChild(img);	
			
			// Actualizando contenedor de imagen para animacion de transiciones
			_actualBackgroundContainer_sp = backgroundImageContainer_sp;
			
			// Adicionando contenedor de imagen con el background del cliente
			this.addBackgroundImageContainer(backgroundImageContainer_sp, _activeClient.id);
			
			// Adicionando el contenedor de imagen al contenedor principal (backgroundImagesContainer_sp)
			SiteManager.getInstance().backgroundImageContainer.addChild(backgroundImageContainer_sp);
			
			// Inicializando contenedor del logo
			var logoImageContainer_sp:Sprite = new Sprite();
			
			// Recuperando logo del cliente
			var logo:Bitmap = bulkLoader.getBitmap(this.urlServerPath + _activeClient.urlClient);
			trace("Logo de la seccion cliente: " + logo);
			
			// Adicionando la logo al contenedor de imagen
			logoImageContainer_sp.addChild(logo);	
			
			// Adicionando contenedor de imagen con el logo del cliente
			this.addLogoImageContainer(logoImageContainer_sp, _activeClient.id);
			
			// Recupero el swf cargado (Like)
			var client_mc:MovieClip = bulkLoader.getMovieClip(_sectionVO.urlSWF);
			trace(client_mc);
			
			// Actualizando estado de la carga de la seccion
			SiteManager.getInstance().updateStatusLoadedSection(_sectionVO.id, true);
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Pasandole el homeMovie (Movieclip) a la clase controladora
			this.sectionMovie = client_mc;
			
			// Adicionando logo del cliente a container
			_clientLogo_mc = _sectionMovie.clientLogo_mc as MovieClip;
			_clientLogo_mc.addChild(logoImageContainer_sp);
			
			// Actualizando logoContainer activo
			_activeLogoImageContainer = logoImageContainer_sp;

			// Actualizar interfaz de la seccion
			this.showTemplate(_activeClient.caseList.length);
			
			// Cargando datos de las redes sociales en los componentes de las secciones
			loadTooltipsSocialData();

			// Actualizando seccion actual
			SiteManager.getInstance().activeSection = client_mc;
			
			// Agregando SWF cargado al Movieclip que representa la seccion de contenidos					
			SiteManager.getInstance().addInfoToSectionPanel(client_mc);	
			
			// Si hay se ha enviado algun caso para mostrar
			if(_activeClientSubdestinationID != -1)
			{
				//  Obteniendo identificados de caso
				var caseID:uint = _activeClientSubdestinationID;
				
				trace("Mostrar caso con ID: " + caseID);
				
				// Obteniendo objeto de datos del caso segun el ID del caso			
				var caseVO:CaseVO = _activeClient.caseList[caseID] as CaseVO;
				
				// Mostrando ventana modal con los detalles del caso
				SiteManager.getInstance().showModalWindow(caseVO);
			}
			
			// Verificando si la transicion entre background no ha sido cancelada
			if(! HomeSectionController.getInstance().isTransitionCanceled)
			{
				/* Adicionando background al backgroundContainer principal (SiteManager).
				Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
				Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
				como consecuencia el elemento queda por enciama de los demas elementos
				*/
				var oldBackgroundContainer_sp:Sprite = SiteManager.getInstance().getOldBackgroundContainer();	
				oldBackgroundContainer_sp.visible = true;
				SiteManager.getInstance().backgroundImageContainer.addChild(oldBackgroundContainer_sp);
				
				// Transicion entre background de un destacado y el otro
				SiteManager.getInstance().playTransition(_actualBackgroundContainer_sp, oldBackgroundContainer_sp);
			}
		}		
		
		public function updateInterfaceSection(template:MovieClip):void
		{
			// Obteniendo loader
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			
			// Recorriendo lista de casos del cliente
			for(var i:uint = 0; i < _activeClient.caseList.length; i++)
			{
				// Obteniendo caso
				var caseVO:CaseVO = _activeClient.caseList[i] as CaseVO;
				
				// Obteniendo objetos visuales del cliente en cuestion
				var img:Bitmap = bulkLoader.getBitmap(this.urlServerPath + caseVO.urlThumb);
				
				// Recorriendo galleria de cada caso
				for(var j:uint = 0; j < caseVO.gallery.length; j++)
				{
					// Obteniendo elemento de la galeria
					var itemGallery:ItemGalleryVO = caseVO.gallery[j] as ItemGalleryVO;
					
					// Si el elemento de la galeria es de tipo imagen cargo la imagen, si es de tipo video no hace falta cargarlo pues lo hace el player de youtube embebido
					if(itemGallery.type == IMAGE_TYPE)
					{
						// Obteniendo objetos visuales del cliente en cuestion
						var thumb:Bitmap = bulkLoader.getBitmap(this.urlServerPath + itemGallery.thumb);
						var image:Bitmap = bulkLoader.getBitmap(this.urlServerPath + itemGallery.url);
						
						// Creando contenedores para las imagenes cargadas
						var thumbContainer:Sprite = new Sprite();
						var mediaContainer:Sprite = new Sprite();
						
						// Adjuntando imagenes a los contenedores correspondientes
						thumbContainer.addChild(thumb);
						mediaContainer.addChild(image);
						
						// Guardando referencias a los contenedores en el objeto de datos correspondiente a este elemento
						itemGallery.thumbContainer = thumbContainer;
						itemGallery.mediaContainer = mediaContainer;
					}									
				}
				
				// Adicionando imagen a los bloques que representan los casos que se encuentran en el escenario
				template["item_" + caseVO.id].mediaContainer.addChild(img);
				template["item_" + caseVO.id].textContainer.title_dtxt.text = caseVO.title;
				template["item_" + caseVO.id].textContainer.description_dtxt.text = caseVO.summary;				
				
				// Asignando al movieclip del caseView un identificador de caso para cuando se haga click en su boton correspondiente, en handler, poder saber de que caso se trata
				(template["item_" + caseVO.id].textContainer.caseView as MovieClip).caseID = caseVO.id;
				
				// Activando detectores de eventos para el boton del caseView para cada uno de los casos del cliente activo
				(template["item_" + caseVO.id].textContainer.caseView.caseView_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onCaseViewClickHandler);				
			}
		}
		
		private function onCaseViewClickHandler(evt:MouseEvent):void
		{
			// Obteniendo movieclip del caso en que se ha clickado, contiene una propiedad asignada dinamicamente (caseID) para saber a que caso corresponde
			var caseView:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			//  Obteniendo identificados de caso
			var caseID:uint = caseView.caseID;
			
			trace("Se ha clickado en el caso con ID: " + caseID);
			
			// Obteniendo objeto de datos del caso segun el ID del caso			
			var caseVO:CaseVO = _activeClient.caseList[caseID] as CaseVO;
			
			// Mostrando ventana modal con los detalles del caso
			SiteManager.getInstance().showModalWindow(caseVO);
		}

		private function onClientEventHandler(evt:EventComplex):void 
		{
			trace("ClientSectionController->onClientEventHandler()");
			trace(evt.data);
			
			// Eliminando imagenes de los contenedores de cada item del template activo
			this.clearActiveTemplateData();
			
			// Si el objeto de datos contenido en el evento es de tipo DataEventObject, el evento se refiere a una accion de cambio de seccion
			if(evt.data is DataEventObject)
			{
				// Obteniendo DataEvenObject con los datos de la accion a realizar
				var dataEO:DataEventObject = evt.data as DataEventObject;
				
				// Segun los datos del evento recibido (origin, destination, subdestination, action, etc), se ejecuta una accion
				var sectionVO:SectionVO = null;	
				
				// Reiniciando variable que controla el caso a mostrar en el cliente activo
				_activeClientSubdestinationID = -1;
				
				// Reproduciendo sonido, esta funcion reproduce el sonido en caso de que no haya sido detenido por el usuario
				SiteManager.getInstance().onSoundButtonClick(null, true);
				
				if(dataEO.origin != dataEO.destination) 
				{
					// Deteniendo el timer de actualizacion de componentes
					_timerSocialTooltips.stop();
					
					// Actualizando antiguo background para realizar animacion de transicion
					SiteManager.getInstance().setOldBackgroundContainer(_actualBackgroundContainer_sp);
					
					switch(dataEO.action)
					{
						case TableDataManager.LOAD_HOME_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(HomeSectionController.SECTION_NAME);
							
							// La seccion HOME siempre es la primera que se carga por lo tanto no es necesario preguntar si ha sido cargada anteriormente
							SiteManager.getInstance().showSection(HomeSectionController.getInstance());
							
							break;
						
						case TableDataManager.LOAD_WE_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(WeSectionController.SECTION_NAME);
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  {
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(WeSectionController.getInstance());
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								WeSectionController.getInstance().buildSection(sectionVO);															
							}
							
							break;
						
						case TableDataManager.LOAD_LIKE_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(LikeSectionController.SECTION_NAME);
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  {
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(LikeSectionController.getInstance());
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								LikeSectionController.getInstance().buildSection(sectionVO);															
							}
							
							break;
						
						case TableDataManager.LOAD_SHARING_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(SharingSectionController.SECTION_NAME);
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  {
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(SharingSectionController.getInstance());
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								SharingSectionController.getInstance().buildSection(sectionVO);															
							}
							
							break;
						
						case TableDataManager.LOAD_EXPERIENCES_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(ExperiencesSectionController.SECTION_NAME);
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  {
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(ExperiencesSectionController.getInstance());
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								ExperiencesSectionController.getInstance().buildSection(sectionVO);															
							}
							
							break;			
						
						default:
							throw new Error("Unknow action");					
					}
				}				
			}
		}
		
		public function backToSectionBeforeModalWindow():void
		{
			trace("ClientSectionController->backToSectionBeforeModalWindow()");
			
			// Configurando variables
			var destination:String = SiteManager.getInstance().getBackSectionController().sectionVO.name;
			var subdestination:String = null;
			var type:String = LoaderManager.SWF_TYPE;;		
			var action:String;
			
			// Deteniendo el timer de actualizacion de componentes
			_timerSocialTooltips.stop();					
			
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
			
			var dataEventObject:DataEventObject = new DataEventObject(SECTION_NAME, destination, action, type);
			trace(dataEventObject);
			
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			this.onClientEventHandler(actionEvent);
		}
		
		public function loadTooltipsSocialData():void
		{
			trace("ClientSectionController->loadTooltipsSocialData()");
			
			// Obteniendo referencias a los tooltips
			var tooltipA_mc:MovieClip = _sectionMovie.tooltipA_mc;
			var tooltipB_mc:MovieClip = _sectionMovie.tooltipB_mc;
			var tooltipC_mc:MovieClip = _sectionMovie.tooltipC_mc;
			var tooltipD_mc:MovieClip = _sectionMovie.tooltipD_mc;
			
			// Escalando tooltips
			tooltipA_mc.scaleX = 0;
			tooltipA_mc.scaleY = 0;
			tooltipB_mc.scaleX = 0;
			tooltipB_mc.scaleY = 0;
			tooltipC_mc.scaleX = 0;
			tooltipC_mc.scaleY = 0;
			tooltipD_mc.scaleX = 0;
			tooltipD_mc.scaleY = 0;			
			
			// Animacion de los tooltips
			var tooltip_mc:MovieClip = null;
			var letters:Array = new Array("A", "B", "C", "D");			
			for(var i:uint = 0; i < letters.length; i++)
			{
				tooltip_mc = _sectionMovie["tooltip" + letters[i] + "_mc"] as MovieClip;
				Tweener.addTween(tooltip_mc, {scaleX:1, time:0.5, transition:"easeOutCubic"});
				Tweener.addTween(tooltip_mc, {scaleY:1, time:0.5, transition:"easeOutCubic"});
			}
			
			// Visibilizando tooltips al inicio de la seccion
			tooltipA_mc.visible = true;
			tooltipB_mc.visible = true;
			tooltipC_mc.visible = true;
			tooltipD_mc.visible = true;
			
			// Obteniendo los dos primeros social items de las redes sociales
			var socialItemA:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipAIndex] as SocialVO;
			var socialItemB:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipBIndex] as SocialVO;
			var socialItemC:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipCIndex] as SocialVO;
			var socialItemD:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipDIndex] as SocialVO;
			
			// Cargando datos en componentes
			if(socialItemA != null)
			{
				tooltipA_mc.text_dtxt.htmlText = socialItemA.text;
				(tooltipA_mc.image as MovieClip).gotoAndStop(socialItemA.name);
			} else {
				tooltipA_mc.visible = false;
			}

			if(socialItemB != null)
			{
				tooltipB_mc.text_dtxt.htmlText = socialItemB.text;
				(tooltipB_mc.image as MovieClip).gotoAndStop(socialItemB.name);
			} else {
				tooltipB_mc.visible = false;
			}
						
			if(socialItemC != null)
			{
				tooltipC_mc.text_dtxt.htmlText = socialItemC.text;
				(tooltipC_mc.image as MovieClip).gotoAndStop(socialItemC.name);
			} else {
				tooltipC_mc.visible = false;
			}
						
			if(socialItemD != null)
			{
				tooltipD_mc.text_dtxt.htmlText = socialItemD.text;
				(tooltipD_mc.image as MovieClip).gotoAndStop(socialItemD.name);
			} else {
				tooltipD_mc.visible = false;
			}
						
			// Iniciando timer
			_timerSocialTooltips.start();			
		}
		
		public function onTimerSocialTooltips(evt:TimerEvent):void
		{
			trace("ClientSectionController->onTimerSocialTooltips()");
			
			// Obteniendo referencias a los tooltips
			var tooltipA_mc:MovieClip = _sectionMovie.tooltipA_mc;
			var tooltipB_mc:MovieClip = _sectionMovie.tooltipB_mc;
			var tooltipC_mc:MovieClip = _sectionMovie.tooltipC_mc;
			var tooltipD_mc:MovieClip = _sectionMovie.tooltipD_mc;
			
			// Escalando tooltips
			tooltipA_mc.scaleX = 0;
			tooltipA_mc.scaleY = 0;
			tooltipB_mc.scaleX = 0;
			tooltipB_mc.scaleY = 0;
			tooltipC_mc.scaleX = 0;
			tooltipC_mc.scaleY = 0;
			tooltipD_mc.scaleX = 0;
			tooltipD_mc.scaleY = 0;			
			
			// Animacion de los tooltips
			var tooltip_mc:MovieClip = null;
			var letters:Array = new Array("A", "B", "C", "D");			
			for(var i:uint = 0; i < letters.length; i++)
			{
				tooltip_mc = _sectionMovie["tooltip" + letters[i] + "_mc"] as MovieClip;
				Tweener.addTween(tooltip_mc, {scaleX:1, time:0.5, transition:"easeOutCubic"});
				Tweener.addTween(tooltip_mc, {scaleY:1, time:0.5, transition:"easeOutCubic"});
			}
			
			// Actualizando indices para proximos elementos
			_activeTooltipAIndex += 4;
			_activeTooltipBIndex += 4;
			_activeTooltipCIndex += 4;
			_activeTooltipDIndex += 4;
			
			// Verificando si existe ese elemento, actualizando indices
			if((ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipAIndex] == null) {_activeTooltipAIndex = 0;}
			if((ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipBIndex] == null) {_activeTooltipBIndex = 1;}
			if((ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipCIndex] == null) {_activeTooltipCIndex = 2;}
			if((ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipDIndex] == null) {_activeTooltipDIndex = 3;}
			
			// Obteniendo objetos de datos en los indices actualizados
			var socialItemA:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipAIndex] as SocialVO;
			var socialItemB:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipBIndex] as SocialVO;
			var socialItemC:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipCIndex] as SocialVO;
			var socialItemD:SocialVO = (ExperiencesSectionController.getInstance().configurationVO.clientList[_activeClient.id] as ClientVO).socialList[_activeTooltipDIndex] as SocialVO;
			
			// Cargando datos en componentes
			if(socialItemA != null)
			{
				tooltipA_mc.text_dtxt.htmlText = socialItemA.text;
				(tooltipA_mc.image as MovieClip).gotoAndStop(socialItemA.name);
			} else {
				tooltipA_mc.visible = false;
			} 
			
			if(socialItemB != null)
			{
				tooltipB_mc.text_dtxt.htmlText = socialItemB.text;
				(tooltipB_mc.image as MovieClip).gotoAndStop(socialItemB.name);
			} else {
				tooltipB_mc.visible = false;
			}
			
			if(socialItemC != null)
			{
				tooltipC_mc.text_dtxt.htmlText = socialItemC.text;
				(tooltipC_mc.image as MovieClip).gotoAndStop(socialItemC.name);
			} else {
				tooltipC_mc.visible = false;
			}
			
			if(socialItemD != null)
			{
				tooltipD_mc.text_dtxt.htmlText = socialItemD.text;
				(tooltipD_mc.image as MovieClip).gotoAndStop(socialItemD.name);
			} else {
				tooltipD_mc.visible = false;
			}
		}
		
		public function clearActiveTemplateData():void
		{
			trace("ClientSectionController->clearActiveTemplateData()");
			
			// Eliminando imagenes de los contenedores
			for(var i:uint = 0; i < _activeTemplate.numChildren; i++)
				for(var j:uint = 0; ((_activeTemplate["item_" + i] as MovieClip).mediaContainer as MovieClip).numChildren; j++) {
					((_activeTemplate["item_" + i] as MovieClip).mediaContainer as MovieClip).removeChildAt(j);
					((_activeTemplate["item_" + i] as MovieClip).textContainer as MovieClip).title_dtxt.text = "";
					((_activeTemplate["item_" + i] as MovieClip).textContainer as MovieClip).description_dtxt.text = "";
				}
			
			//
		}
		
	}
}