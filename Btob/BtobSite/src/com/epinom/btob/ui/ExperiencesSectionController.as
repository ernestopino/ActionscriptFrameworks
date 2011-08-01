package com.epinom.btob.ui
{
	import com.digitalsurgeons.loading.BulkLoader;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.CaseVO;
	import com.epinom.btob.data.ClientVO;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.ExperiencesVO;
	import com.epinom.btob.data.ItemGalleryVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.ServiceVO;
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
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import flashx.textLayout.formats.FormatValue;
	import flashx.undo.IUndoManager;
	
	public class ExperiencesSectionController implements ISectionController
	{
		private static var _instance:ExperiencesSectionController = null;
		private static var _allowInstantiation:Boolean;
		
		public static const SECTION_NAME:String = "experiences";
		public static const SECTION_CONTROLLER:String = "experiencesSectionController";		
		public static const CLIENT_CLICK_VIEW_ALL_EVENT:String = "clientClickViewAllEvent";
		public static const CASES_BY_CLIENT_COUNT:uint = 5;
		public static const CASES_BY_SERVICE_COUNT:uint = 20;
		public static const CASES_BY_POPULARITY_COUNT:uint = 12;
				
		//public static const URL_XML_EXPERIENCES_CONFIGURATION:String = "config/experiences.xml";
		//public static const URL_XML_EXPERIENCES_CONFIGURATION:String = "/back/experiences.xml";
		public static const URL_XML_EXPERIENCES_CONFIGURATION:String = "http://btob.es/back/experiences.xml";
		
		private var urlServerPath:String = "";
		
		private var _sectionVO:SectionVO;		
		private var _activeBackgroundId:uint;
		private var _sectionMovie:MovieClip;
		private var _activeBackgroundImageContainer:Sprite;
		private var _backgroundImageContainerList:Array;
		
		private var _configurationVO:ExperiencesVO;
		private var _clickedCaseVO:CaseVO;
		
		private var _smoService:ServiceVO;
		private var _audiovisualProductionService:ServiceVO;
		private var _brandEnterteinmentService:ServiceVO;
		private var _interactivesExperiencesService:ServiceVO;
		private var _platformsService:ServiceVO;
		private var _appsService:ServiceVO;
		
		private var _rateObjectList:Array;
		
		private var _tempGreatEvent:EventComplex;
		
		// Variables de control para animacion de transiciones entre secciones
		private var _actualBackgroundContainer_sp:Sprite;
		
		public function ExperiencesSectionController()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use ExperiencesSectionController.getInstance() instead of new.");
			} else {	
				trace("ExperiencesSectionController->ExperiencesSectionController()");
				
				_sectionMovie = null;
				_activeBackgroundImageContainer = null;
				_backgroundImageContainerList = new Array();
				_configurationVO = null;
				_tempGreatEvent = null;
				
				// Inicializando servicios
				_smoService = new ServiceVO(TableDataManager.SMO_SERVICE);
				_audiovisualProductionService = new ServiceVO(TableDataManager.AUDIOVISUAL_PRODUCTION_SERVICE);
				_brandEnterteinmentService = new ServiceVO(TableDataManager.BRAND_ENTERTEINMENT_SERVICE);
				_interactivesExperiencesService = new ServiceVO(TableDataManager.INTERACTIVES_EXPERIENCES_SERVICE);
				_platformsService = new ServiceVO(TableDataManager.PLATFORMS_SERVICE);
				_appsService = new ServiceVO(TableDataManager.APPS_SERVICE);
				
				// Inicializando lista de casos mas populares
				_rateObjectList = new Array();
				
				_actualBackgroundContainer_sp = null;
			}
		}
		
		public static function getInstance():ExperiencesSectionController 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new ExperiencesSectionController();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get configurationVO():ExperiencesVO { return _configurationVO; }
		
		public function get sectionVO():SectionVO { return _sectionVO; }
		public function set sectionVO(value:SectionVO):void { _sectionVO = value; }	
		
		public function get sectionMovie():MovieClip { return _sectionMovie; }
		public function set sectionMovie(value:MovieClip):void {  
			_sectionMovie = value;
			_sectionMovie.addEventListener(TableDataManager.SECTION_EVENT, onExperiencesEventHandler, false, 0, true);
			_sectionMovie.addEventListener(TableDataManager.HELLO_WINDOW, onHelloClickHandler, false, 0, true);
		}
		
		public function get smoService():ServiceVO { return _smoService; }
		public function set smoService(value:ServiceVO):void { _smoService = value; }
		
		public function get audiovisualProductionService():ServiceVO { return _audiovisualProductionService; }
		public function set audiovisualProductionService(value:ServiceVO):void { _audiovisualProductionService = value; }
		
		public function get brandEnterteinmentService():ServiceVO { return _brandEnterteinmentService; }
		public function set brandEnterteinmentService(value:ServiceVO):void { _brandEnterteinmentService = value; }
		
		public function get interactivesExperiencesService():ServiceVO { return _interactivesExperiencesService; }
		public function set interactivesExperiencesService(value:ServiceVO):void { _interactivesExperiencesService = value; }
		
		public function get platformsService():ServiceVO { return _platformsService; }
		public function set platformsService(value:ServiceVO):void { _platformsService = value; }
		
		public function get appsService():ServiceVO { return _appsService; }
		public function set appsService(value:ServiceVO):void { _appsService = value; }
		
		public function get rateObjectList():Array { return _rateObjectList; }
		public function set rateObjectList(value:Array):void { _rateObjectList = value; }
		
		public function activateSection(idClient:String = null, idCase:String = null):void 
		{
			// Hace visibles todas sus secciones de informacion
			sectionMovie.visible = true;
			for(var i:uint = 0; i < _backgroundImageContainerList.length; i++)
				(_backgroundImageContainerList[i] as Sprite).visible = true;
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			/* Codigo utilizado para tracear la posicion de los backgrounds es la lista de visualizacion 
			trace("\n Antes:");
			var sp:Sprite = null;
			for(var i:uint = 0; i < SiteManager.getInstance().backgroundImageContainer.numChildren; i++) 
			{
			sp = SiteManager.getInstance().backgroundImageContainer.getChildAt(i) as Sprite;
			trace("backgroundImageContainer elemento ( nivel " + i + " ) : "  + sp.name + " [ visible = " + sp.visible + "]");
			}
			*/
			
			/* Adicionando background al backgroundContainer principal (SiteManager).
			Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
			Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
			como consecuencia el elemento queda por enciama de los demas elementos
			*/
			var oldBackgroundContainer_sp:Sprite = SiteManager.getInstance().getOldBackgroundContainer();	
			oldBackgroundContainer_sp.visible = true;
			trace("oldBackgroundContainer_sp: " + oldBackgroundContainer_sp.name);
			
			// Reposicionando el elemento en la lista de visualizacion para que este por encima de los demas
			SiteManager.getInstance().backgroundImageContainer.addChild(oldBackgroundContainer_sp);
			
			// Transicion entre background de un destacado y el otro
			SiteManager.getInstance().playTransition(_actualBackgroundContainer_sp, oldBackgroundContainer_sp);
		}
		
		public function desactivateSection():void 
		{
			// Invisibiliza todas sus secciones de informacion 	
			sectionMovie.visible = false;
			for(var i:uint = 0; i < _backgroundImageContainerList.length; i++)
				(_backgroundImageContainerList[i] as Sprite).visible = false;
		}
		
		public function addBackgroundImageContainer(backgroundImageContainer:DisplayObject, idClient:int = -1):void
		{
			trace("ExperiencesSectionController->addBackgroundImageContainer()");		
			backgroundImageContainer.name = "experiecesBackgroundImageContainer_" + _backgroundImageContainerList.length;
			_backgroundImageContainerList.push(backgroundImageContainer);
		}
		
		public function updateExperiencesImageInfo():void 
		{
			trace("ExperiencesSectionController->updateExperiencesImageInfo()");
			
			// Visualizando el primer background
			var backgroundImageContainer:Sprite = _backgroundImageContainerList[_activeBackgroundId] as Sprite;
			_activeBackgroundImageContainer = backgroundImageContainer;
			_activeBackgroundImageContainer.visible = true;
			
		}
		
		public function loadExperiencesConfiguration(evt:EventComplex):void
		{
			// Asignando evento a variable temporal para cuando se termine la carga
			_tempGreatEvent = evt;
			
			// Si la configuracion no ha sido cargada con anterioridad
			if(_configurationVO == null)
			{
				// Creando un nuevo loader para ejecutar cargas ordenadas por la clase HomeSectionController
				if(BulkLoader.getLoader(SECTION_NAME) == null)
					SiteManager.getInstance().bulkLoader = new BulkLoader(SECTION_NAME); 
				
				// Obteniendo loader (BUlkLoader)
				var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
				
				// Adicionado fichero de configuracion (futuramente se actualizara con una llamada a un servicio real PHP)
				bulkLoader.add(new URLRequest(URL_XML_EXPERIENCES_CONFIGURATION), {id: URL_XML_EXPERIENCES_CONFIGURATION });
				
				// Configurando listeners
				bulkLoader.addEventListener(BulkLoader.COMPLETE, onLoadExperiencesConfiguration);
				bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
				bulkLoader.start();
			}
			else	// Si la configuracion ya se cargo anteriormente ejecutar directamente la accion
			{
				this.onLoadExperiencesConfiguration(_tempGreatEvent);
			}
		}
		
		private function onLoadExperiencesConfiguration(evt:Event):void
		{
			// Obteniendo loader
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			
			// Eliminando detectores de eventos			
			bulkLoader.removeEventListener(BulkLoader.COMPLETE, onLoadExperiencesConfiguration);
			bulkLoader.removeEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);			
			
			// Recuperando objeto XML del loader (BulkLoader)
			var experiencesXML:XML = bulkLoader.getXML(URL_XML_EXPERIENCES_CONFIGURATION);
			
			// Parseando configuracion XML a Objetos de Datos (VO)
			if(_configurationVO == null)
				_configurationVO = XMLParser.parseExperiencesXML(experiencesXML);

			// Cargando seccion cliente con el caso especificado
			this.onExperiencesEventHandler(_tempGreatEvent);		
		}
		
		public function buildSection(vo:SectionVO, idClient:String = null, idCase:String = null):void
		{
			// Actualizando campos
			_sectionVO = vo;
			
			// Verificando si esta activa la carga de imagenes desde el servidor 
			if(SiteManager.ACTIVE_SERVICE_SIDE)
				this.urlServerPath = TableDataManager.URL_PATH_SERVER;	
			
			// Si la configuracion no ha sido cargada con anterioridad
			if(_configurationVO == null)
			{
				// Creando un nuevo loader para ejecutar cargas ordenadas por la clase HomeSectionController
				if(BulkLoader.getLoader(SECTION_NAME) == null)
					SiteManager.getInstance().bulkLoader = new BulkLoader(SECTION_NAME); 
				
				// Obteniendo loader (BUlkLoader)
				var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
				
				// Adicionado fichero de configuracion (futuramente se actualizara con una llamada a un servicio real PHP)
				bulkLoader.add(new URLRequest(URL_XML_EXPERIENCES_CONFIGURATION), {id: URL_XML_EXPERIENCES_CONFIGURATION });
				
				// Configurando listeners
				bulkLoader.addEventListener(BulkLoader.COMPLETE, loadDisplayObjects);
				bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
				bulkLoader.start();	
			}
			else
			{
				this.loadDisplayObjects(null);
			}
		}
		
		public function loadDisplayObjects(evt:Event):void
		{
			trace("ExperiencesSectionController->loadDisplayObjects()");
			
			// Obteniendo loader
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);		
			
			// Parseando configuracion XML a Objetos de Datos (VO)
			if(_configurationVO == null) {
				// Recuperando objeto XML del loader (BulkLoader)
				var experiencesXML:XML = bulkLoader.getXML(URL_XML_EXPERIENCES_CONFIGURATION);
				_configurationVO = XMLParser.parseExperiencesXML(experiencesXML);
			}

			// Adicionando a la carga de ficheros externos el swf de la seccion y su correspondiente imagen de fondo
			bulkLoader.add(new URLRequest(_sectionVO.urlSWF), {id: _sectionVO.urlSWF });
			bulkLoader.add(new URLRequest(_sectionVO.urlImage), {id: _sectionVO.urlImage });
			
			// Recorriendo lista de clientes de la configuracion
			for(var i:uint = 0; i < _configurationVO.clientList.length; i++)
			{
				// Obteniendo cliente
				var clientVO:ClientVO = _configurationVO.clientList[i] as ClientVO;
				
				// Adicionando a la carga de ficheros externos los objetos visuales de los diferentes clientes
				bulkLoader.add(new URLRequest(this.urlServerPath + clientVO.urlLogo), {id: this.urlServerPath + clientVO.urlLogo});
			}
			
			// Ordenando la lista por mayor popularidad			
			_rateObjectList.sortOn("rating", Array.NUMERIC | Array.DESCENDING);
			
			// Recorriendo los primeros 12 casos (los mas populares)
			for(var j:uint = 0; j < CASES_BY_POPULARITY_COUNT; j++)
			{
				// Obteniendo caso
				var caseDataObject:Object = _rateObjectList[j] as Object;
				
				// Verificando que el caso exista
				if(caseDataObject != null)
				{									
					// Adicionando a la carga de ficheros externos el swf de la seccion y su correspondiente imagen de fondo
					trace("Cargando imagen miniatura: " + String(this.urlServerPath + caseDataObject.urlThumb));
					bulkLoader.add(new URLRequest(this.urlServerPath + caseDataObject.urlThumb), {id: this.urlServerPath + caseDataObject.urlThumb });								
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
			trace("ExperiencesSectionController->onBulkSectionLoadedHandler()");
			
			// Declarando variable contenedora de mensaje de error en caso de existir
			var errorMessage:String =  "ERROR [ExperiencesSectionController->onBulkSectionLoadedHandler()]:\n ";;
			
			// Eliminando los listeners
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			bulkLoader.removeEventListener(BulkLoader.COMPLETE, onBulkSectionLoadedHandler);
			bulkLoader.removeEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);	
			bulkLoader.removeEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			
			// Realizando animacion del objeto de loader visual
			SiteManager.getInstance().hideLoader();					
			
			// Inicializando contenedor
			var backgroundImageContainer_sp:Sprite = new Sprite();								
			
			// Recuperando imagen cargada por el gestor de descargas multiples
			var img:Bitmap = bulkLoader.getBitmap(_sectionVO.urlImage);
			
			try 
			{
				// Adicionando la imagen al contenedor de imagen
				backgroundImageContainer_sp.addChild(img);		
				
				// Actualizando contenedor de imagen para animacion de transiciones
				_actualBackgroundContainer_sp = backgroundImageContainer_sp;
			} 
			catch(error:Error) 
			{
				errorMessage += "Imagen inaccesible: " + _sectionVO.urlImage + "\n ";
				errorMessage += error.message;
				SiteManager.getInstance().showErrorWindow(errorMessage);
			}
									
			// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
			this.addBackgroundImageContainer(backgroundImageContainer_sp);
			
			// Adicionando el contenedor de imagen al contenedor principal (backgroundImagesContainer_sp)
			SiteManager.getInstance().backgroundImageContainer.addChild(backgroundImageContainer_sp);
			
			// Recupero el swf cargado (Like)
			var experiences_mc:MovieClip = bulkLoader.getMovieClip(_sectionVO.urlSWF);
			trace(experiences_mc);		
			
			// Comprobrando errores de carga
			if(experiences_mc == null)
			{
				errorMessage += "Seccion inaccesible: " + _sectionVO.urlSWF + "\n ";
				SiteManager.getInstance().showErrorWindow(errorMessage);
			}
			
			// Actualizando estado de la carga de la seccion
			SiteManager.getInstance().updateStatusLoadedSection(_sectionVO.id, true);
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Pasandole el homeMovie (Movieclip) a la clase controladora
			this.sectionMovie = experiences_mc;
			
			// Actualizando componentes de la subseccion de popularidad (es necesario configurarlo desde aqui para que se puedan agregar las miniaturas de los casos a la descarga)
			this.updateByPopularitySubsection();
			
			// Actualizando componentes de la subseccion de servicios
			this.updateByServiceSubsection();					
			
			// Actualizando interfaz de la seccion
			this.updateInterfaceSection(); 
			
			// Actualizando seccion actual
			SiteManager.getInstance().activeSection = experiences_mc;					
			
			// Configurando visualizacion de la seccion
			this.updateExperiencesImageInfo();
			
			// Agregando SWF cargado al Movieclip que representa la seccion de contenidos					
			SiteManager.getInstance().addInfoToSectionPanel(experiences_mc);
			
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
		
		private function updateByPopularitySubsection():void
		{
			trace("ExperiencesSectionController->updateByPopularitySubsection()");
			
			// Eliminando los listeners
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			
			// Recorriendo los primeros 12 casos (los mas populares)
			for(var i:uint = 0; i < CASES_BY_POPULARITY_COUNT; i++)
			{
				// Obteniendo caso
				var caseDataObject:Object = _rateObjectList[i] as Object;
				
				// Verificando que el caso exista
				if(caseDataObject != null)
				{
					// Actualizando campos del bloque de popularidad
					this.sectionMovie.experiencesByPopularity["rate_" + i].rate_dtxt.text = i + 1;
					this.sectionMovie.experiencesByPopularity["rate_" + i].client_dtxt.text = caseDataObject.clientName;
					this.sectionMovie.experiencesByPopularity["rate_" + i].case_dtxt.text = caseDataObject.caseName;
					
					// Recuperando imagen cargada por el gestor de descargas multiples					
					var img:Bitmap = bulkLoader.getBitmap(this.urlServerPath + caseDataObject.urlThumb);					
					
					// Asignando ministura al objeto de datos de la lista de casos populares
					caseDataObject.thumb = img;
															
					try 
					{
						// Actualizando imagen en cada caso
						(this.sectionMovie.experiencesByPopularity["rate_" + i].imageContainer as MovieClip).addChild(caseDataObject.thumb as Bitmap);
						
						// Adicionando detector de eventos
						(this.sectionMovie.experiencesByPopularity["rate_" + i].rate_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onByPopulatiryCaseClickHandler);
						
						// Asociando objeto de datos al movieclip que representa cada caso popular
						(this.sectionMovie.experiencesByPopularity["rate_" + i] as MovieClip).rateObject = caseDataObject;
						
					} catch(error:Error) 
					{
						var msg:String = "ERROR [ExperiencesSectionController->updateByPopularitySubsection()]:\n ";
						msg += "Imagen inaccesible: " + caseDataObject.urlThumb + "\n ";
						msg += error.message;
						//SiteManager.getInstance().showErrorWindow(msg);
					}	
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.smo["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.smo["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.smo["tag_" + i] as MovieClip).visible = false;
				}
			}
		}
		
		private function onByPopulatiryCaseClickHandler(evt:MouseEvent):void
		{
			trace((evt.target.parent as MovieClip).name);
			
			// Obteniendo movieclip representante del caso popular
			var rateMC:MovieClip = (evt.target as SimpleButton).parent as MovieClip;
			
			// Obteniendo objeto de datos (caso popular), asociado al movieclip e cuestion
			var caseDataObject:Object = rateMC.rateObject as Object;
			
			// Declaracion de variables
			var destination:String = TableDataManager.SECTION_CLIENT;
			var subdestination:String = null;
			var action:String = TableDataManager.LOAD_CLIENT_SECTION;
			var type:String = LoaderManager.SWF_TYPE;
			
			// Creando objeto de datos para el evento
			var dataEventObject:DataEventObject = new DataEventObject(TableDataManager.SECTION_EXPERIENCES, destination, action, type);
			dataEventObject.idClient = caseDataObject.clientID;
			dataEventObject.idCase = caseDataObject.caseID;
			trace(dataEventObject);
			
			// Creando evento complejo
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			this.onExperiencesEventHandler(actionEvent);					
		}
		
		private function updateByServiceSubsection():void
		{
			// Asignando listas de datos a los diferentes movieclip de servicios en ExperiencesSectionMovie (pelicula externa), para poder acceder a los datos de cliente y caso cuando se haga click en cada caso de un servicio
			this.sectionMovie.experiencesByService.cases.smo.serviceVO = _smoService;
			this.sectionMovie.experiencesByService.cases.audiovisualProduction.serviceVO = _audiovisualProductionService;
			this.sectionMovie.experiencesByService.cases.brandEnterteinment.serviceVO = _brandEnterteinmentService;
			this.sectionMovie.experiencesByService.cases.interactivesExperiences.serviceVO = _interactivesExperiencesService;
			this.sectionMovie.experiencesByService.cases.platforms.serviceVO = _platformsService;
			this.sectionMovie.experiencesByService.cases.apps.serviceVO = _appsService;	
			
			// Actualizando casos por cada uno de los servicios
			for(var i:uint = 0; i < CASES_BY_SERVICE_COUNT; i++)
			{
				// SMO
				
				// Obteniendo caso
				var smoDataObject:Object = _smoService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(smoDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.smo["item_" + i].text = smoDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.smo["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.smo["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.smo["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.smo["tag_" + i] as MovieClip).visible = false;
				}	
				
				// AUDIOVISUAL
				
				// Obteniendo caso
				var audiovisualDataObject:Object = _audiovisualProductionService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(audiovisualDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.audiovisualProduction["item_" + i].text = audiovisualDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.audiovisualProduction["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.audiovisualProduction["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.audiovisualProduction["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.audiovisualProduction["tag_" + i] as MovieClip).visible = false;
				}	
				
				// BRAND ENTERTEINMENT
				
				// Obteniendo caso
				var brandDataObject:Object = _brandEnterteinmentService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(brandDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.brandEnterteinment["item_" + i].text = brandDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.brandEnterteinment["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.brandEnterteinment["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.brandEnterteinment["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.brandEnterteinment["tag_" + i] as MovieClip).visible = false;
				}	
				
				// INTERACTIVE EXPERIENCES
				
				// Obteniendo caso
				var interactivesDataObject:Object = _interactivesExperiencesService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(interactivesDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.interactivesExperiences["item_" + i].text = interactivesDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.interactivesExperiences["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.interactivesExperiences["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.interactivesExperiences["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.interactivesExperiences["tag_" + i] as MovieClip).visible = false;
				}	
				
				// PLATFORMS
				
				// Obteniendo caso
				var platformsDataObject:Object = _platformsService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(platformsDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.platforms["item_" + i].text = platformsDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.platforms["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.platforms["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.platforms["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.platforms["tag_" + i] as MovieClip).visible = false;
				}	
				
				// APPS
				
				// Obteniendo caso
				var appsDataObject:Object = _appsService.caseList[i] as Object;
				
				// Verificando que el caso exista
				if(appsDataObject != null)
				{
					// Asignando nombre de caso a campo de texto dinamico en la pelicula
					this.sectionMovie.experiencesByService.cases.apps["item_" + i].text = appsDataObject.caseName;
					
					// Adicionando manejador de evento para la interaccion con un caso
					(this.sectionMovie.experiencesByService.cases.apps["btn_" + i] as SimpleButton).addEventListener(MouseEvent.CLICK, onByServicesCaseClickHandler);
				}								
				else
				{
					// Invisibilizando componentes innecesarios					
					this.sectionMovie.experiencesByService.cases.apps["item_" + i].visible = false;
					(this.sectionMovie.experiencesByService.cases.apps["btn_" + i] as SimpleButton).visible = false;
					(this.sectionMovie.experiencesByService.cases.apps["tag_" + i] as MovieClip).visible = false;
				}	
			}
		}
		
		private function onByServicesCaseClickHandler(evt:MouseEvent):void
		{
			trace("ExperiencesSectionController->onByServicesCaseClickHandler()");
			trace((evt.target as SimpleButton).name);
			
			// Obteniendo ID del caso clickado
			var caseIndex:uint = uint((evt.target as SimpleButton).name.substr((evt.target as SimpleButton).name.indexOf("_") + 1));
			trace("Indice del caso en la lista del servicio: " + caseIndex);
			
			// Obteniendo serviceVO asociado al elemento clickado
			var serviceVO:ServiceVO = ((evt.target as SimpleButton).parent as MovieClip).serviceVO as ServiceVO;
			
			// Obteniendo ID de caso e ID de cliente para poder mostrar la ventana modal con los datos correspondiente al caso clickado
			var caseID:uint = uint((serviceVO.caseList[caseIndex] as Object).caseID);
			var clientID:uint = uint((serviceVO.caseList[caseIndex] as Object).clientID);
			var caseName:String = String((serviceVO.caseList[caseIndex] as Object).caseName);
			trace("Case ID: " + caseID);
			trace("Client ID: " + clientID);
			trace("Case name: " + caseName);
			
			// Declaracion de variables
			var destination:String = TableDataManager.SECTION_CLIENT;
			var subdestination:String = null;
			var action:String = TableDataManager.LOAD_CLIENT_SECTION;
			var type:String = LoaderManager.SWF_TYPE;
			
			// Inicializando objetos de datos 
			var findedClientVO:ClientVO = null; 
			var findedCaseVO:CaseVO = null;
			
			// Obeteniendo objetos de datos
			findedClientVO = _configurationVO.clientList[uint(clientID)] as ClientVO;
			findedCaseVO = findedClientVO.caseList[uint(caseID)] as CaseVO;
			
			// Creando objeto de datos para el evento
			var dataEventObject:DataEventObject = new DataEventObject(TableDataManager.SECTION_EXPERIENCES, destination, action, type);
			dataEventObject.idClient = findedClientVO.ref;
			dataEventObject.idCase = findedCaseVO.ref;
			trace(dataEventObject);
			
			// Creando evento complejo
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			this.onExperiencesEventHandler(actionEvent);	
		}
		
		private function updateInterfaceSection():void
		{
			trace("ExperiencesSectionController->updateInterfaceSection()");
			
			// Obteniendo loader
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			
			// Recorriendo lista de clientes de la configuracion
			for(var i:uint = 0; i < _configurationVO.clientList.length; i++)
			{
				// Obteniendo cliente
				var clientVO:ClientVO = _configurationVO.clientList[i] as ClientVO;
				
				// Obteniendo objetos visuales del cliente en cuestion
				trace("urlLogo = " + this.urlServerPath + clientVO.urlLogo);
				var logo:MovieClip = bulkLoader.getMovieClip(this.urlServerPath + clientVO.urlLogo);							
				
				// Adicionando imagen a los bloques que representan los clientes que se encuentran en el escenario
				var clientBlock_mc:MovieClip = _sectionMovie.clientBlockList[i] as MovieClip;
								
				try 
				{
					// Adicionando logo al contenedor de imagen
					clientBlock_mc.client.img.addChild(logo);
					trace(clientBlock_mc.projects.clientName_dtxt);
					clientBlock_mc.projects.clientName_dtxt.text = clientVO.name;
				} 
				catch(error:Error) 
				{
					var msg:String = "ERROR [ExperiencesSectionController->updateInterfaceSection()]:\n ";
					msg += "Imagen inaccesible: " + this.urlServerPath + clientVO.urlLogo + "\n ";
					msg += error.message;
					SiteManager.getInstance().showErrorWindow(msg);
				}
				
				// Si el cliente no tiene casos invisibilizar el boton de "ver todos"
				if(clientVO.caseList.length == 0)
					clientBlock_mc.projects.viewAll_btn.visible = false;
				
				// Recorriendo la lista de casos de cada cliente
				for(var j:uint = 0; j < CASES_BY_CLIENT_COUNT; j++)
				{
					// Obteniendo caso
					var caseVO:CaseVO = clientVO.caseList[j] as CaseVO;
					
					// Verificando que el caso exista
					if(caseVO != null)
					{
						// Asignando nombre de caso a campo de texto dinamico en la pelicula
						clientBlock_mc.projects["itemLabel_" + caseVO.id].text = caseVO.name;
						
						// Adicionando manejador de evento para la interaccion con un caso
						// TODO: Cuando se activa la carga de la ventana modal haciendo click en un caso comienza a fallar funcionalidades anteriores (ver por que?)
						(clientBlock_mc.projects["itemButton_" + caseVO.id] as SimpleButton).addEventListener(MouseEvent.CLICK, onCaseClickHandler);
					}
					else
					{
						// Invisibilizando componentes innecesarios
						clientBlock_mc.projects["itemBlock_" + j].visible = false;
						clientBlock_mc.projects["itemLabel_" + j].visible = false;
						(clientBlock_mc.projects["itemButton_" + j] as SimpleButton).visible = false;
					}
				}
			}
		}
		
		private function onCaseClickHandler(evt:MouseEvent):void
		{
			// Obteniendo id del caso
			var caseID:String = (evt.target as SimpleButton).name.substr((evt.target as SimpleButton).name.indexOf("_") + 1);
			trace("CASE ID: " + caseID);
			
			// Obteniendo id del cliente
			var client:MovieClip = (evt.target as SimpleButton).parent.parent as MovieClip;
			var clientID:String = client.name.substr(client.name.indexOf("_") + 1);
			trace("CLIENT ID: " + clientID);
			
			// Declaracion de variables
			var destination:String = TableDataManager.SECTION_CLIENT;
			var subdestination:String = null;
			var action:String = TableDataManager.LOAD_CLIENT_SECTION;
			var type:String = LoaderManager.SWF_TYPE;
			
			// Inicializando objetos de datos 
			var findedClientVO:ClientVO = null; 
			var findedCaseVO:CaseVO = null;
			
			// Obeteniendo objetos de datos
			findedClientVO = _configurationVO.clientList[uint(clientID)] as ClientVO;
			findedCaseVO = findedClientVO.caseList[uint(caseID)] as CaseVO;
			
			// Creando objeto de datos para el evento
			var dataEventObject:DataEventObject = new DataEventObject(TableDataManager.SECTION_EXPERIENCES, destination, action, type);
			dataEventObject.idClient = findedClientVO.ref;
			dataEventObject.idCase = findedCaseVO.ref;
			trace(dataEventObject);
			
			// Creando evento complejo
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			this.onExperiencesEventHandler(actionEvent);						
		}		
		
		private function onHelloClickHandler(evt:Event):void
		{
			SiteManager.getInstance().showHelloWindow();	
		}
		
		public function onExperiencesEventHandler(evt:EventComplex):void 
		{
			trace("ExperiencesSectionController->onExperiencesEventHandler()");
			trace(evt.data);
			
			// Si el objeto de datos contenido en el evento es de tipo DataEventObject, el evento se refiere a una accion de cambio de seccion
			if(evt.data is DataEventObject)
			{
				// Obteniendo DataEvenObject con los datos de la accion a realizar
				var dataEO:DataEventObject = evt.data as DataEventObject;
				if(dataEO.idCase == undefined)
					dataEO.idCase = null;
				
				// Segun los datos del evento recibido (origin, destination, subdestination, action, etc), se ejecuta una accion
				var sectionVO:SectionVO = null;		
				
				// Actualizando antiguo background para realizar animacion de transicion
				if(_actualBackgroundContainer_sp != null)
					SiteManager.getInstance().setOldBackgroundContainer(_actualBackgroundContainer_sp);
				
				// Reproduciendo sonido, esta funcion reproduce el sonido en caso de que no haya sido detenido por el usuario
				SiteManager.getInstance().onSoundButtonClick(null, true);
				
				if(dataEO.origin != dataEO.destination) 
				{
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
						
						case TableDataManager.LOAD_AWARDS_SECTION:
							
							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(AwardsSectionController.SECTION_NAME);
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  {
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(AwardsSectionController.getInstance());
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								AwardsSectionController.getInstance().buildSection(sectionVO);															
							}
							
							break;
						
						case TableDataManager.LOAD_CLIENT_SECTION:													

							// Obteniendo objeto de datos 
							sectionVO = BtobDataModel.getInstance().settings.getSectionByName(ClientSectionController.SECTION_NAME);
							
							// Verificando si 
							trace(typeof(dataEO.idClient));
							if(typeof(dataEO.idClient) == "number")
							{
								// Inicializando objetos de datos 
								var findedClientVO:ClientVO = null; 
								var findedCaseVO:CaseVO = null;
								
								// Obeteniendo objetos de datos
								findedClientVO = _configurationVO.clientList[uint(dataEO.idClient)] as ClientVO;
								
								// Creando objeto de datos para el evento
								dataEO.idClient = findedClientVO.ref;
								dataEO.idCase = null;
							}							
	
							
							// Si el controlador de referencia del evento no esta definido
							if(dataEO.controller == null || dataEO.controller == undefined)
							{
								// Actualizando el BackController de la clase principal para poder volver desde la seccion cliente a la seccion anterior
								SiteManager.getInstance().updateBackSectionController(this);
							}
							else	// Si el controlador fue definido asignarselo 
							{
								// Actualizando el BackController de la clase principal para poder volver desde la seccion cliente a la seccion anterior
								SiteManager.getInstance().updateBackSectionController(dataEO.controller);
							}
							
							// Si la seccion ha sido cargada anteriormente
							if(SiteManager.getInstance().isSectionLoaded(sectionVO.id))  
							{															
								// Se muestra la seccion sin hacer ningun tipo de precarga
								SiteManager.getInstance().showSection(ClientSectionController.getInstance(), dataEO.idClient, dataEO.idCase);
							} else // Si la seccion NO ha sido cargada con anterioridad
							{
								// Mostrando el loader 
								SiteManager.getInstance().showLoader();
								
								// Cargando y construyendo seccion
								ClientSectionController.getInstance().buildSection(sectionVO, dataEO.idClient, dataEO.idCase);	
							}
							
							break;												
						
						default:
							throw new Error("Unknow action");					
					}
				}				
			}			
		}
		
		
		// FUNCIONES DE BUSQUEDAS
		
		public function findClientByReference(ref:String):ClientVO
		{
			trace("ExperiencesSectionController->findClientByReference()");
			trace("Referencia de cliente para la busqueda: " + ref);
			
			// Inicializando variable de respuesta
			var clientVO:ClientVO = null;
			
			// Recorriendo lista de clientes
			for(var i:uint = 0; i < _configurationVO.clientList.length; i++) {
				if((_configurationVO.clientList[i] as ClientVO).ref == ref) {
					clientVO = _configurationVO.clientList[i] as ClientVO;
					break;
				}
			}
			
			trace("Cliente encontrado: " + clientVO);
			return clientVO;
		}
		
		public function findCaseByReference(client: ClientVO, ref:String):CaseVO
		{
			trace("ExperiencesSectionController->findCaseByReference()");
			trace("Referencia del caso para la busqueda: " + ref);
			
			// Inicializando variable de respuesta
			var caseVO:CaseVO = null;
			
			// Recorriendo lista de clientes
			for(var i:uint = 0; i < client.caseList.length; i++) {				
				if((client.caseList[i] as CaseVO).ref == ref) {
					caseVO = client.caseList[i] as CaseVO;
					break;
				}
			}
			
			trace("Caso encontrado: " + caseVO);
			return caseVO;
		}
		
	}
}