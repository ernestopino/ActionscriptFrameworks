package com.epinom.btob.ui
{
	import com.digitalsurgeons.loading.BulkLoader;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.ItemSocialVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.SharingVO;
	import com.epinom.btob.data.SocialVO;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	import com.epinom.btob.utils.XMLParser;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.Timer;
	
	public class SharingSectionController implements ISectionController
	{
		private static var _instance:SharingSectionController = null;
		private static var _allowInstantiation:Boolean;
		
		public static const SECTION_NAME:String = "sharing";
		public static const SECTION_CONTROLLER:String = "sharingSectionController";
		private static const YOUTUBE_VIDEO_ID:String = "qybUFnY7Y8w";
		private static const UPDATE_TIME_SOCIAL_COMPONENTS:uint = 10 * 1000;
		
		//public static const URL_XML_SHARING_CONFIGURATION:String = "config/sharing.xml";
		//public static const URL_XML_SHARING_CONFIGURATION:String = "/back/sharing.xml";
		public static const URL_XML_SHARING_CONFIGURATION:String = "http://btob.es/back/sharing.xml";
		
		
		private var _sectionVO:SectionVO;
		private var _activeBackgroundId:uint;
		private var _sectionMovie:MovieClip;
		private var _activeBackgroundImageContainer:Sprite;
		private var _backgroundImageContainerList:Array;
		private var _youtubeVideoPlayer:Object;
		private var _youtubeLoader:Loader;
		
		private var _configurationVO:SharingVO;		
		private var _activeFacebookAIndex:uint;
		private var _activeFacebookBIndex:uint;
		private var _activeBlogAIndex:uint;
		private var _activeBlogBIndex:uint;
		private var _activeTwitterAIndex:uint;
		private var _activeTwitterBIndex:uint;
		private var _timerSocialComponents:Timer;
		
		// Variables de control para animacion de transiciones entre secciones
		private var _actualBackgroundContainer_sp:Sprite;

		public function SharingSectionController()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SharingSectionController.getInstance() instead of new.");
			} else {	
				
				// Agregando cualquier dominio para temas de seguridad de Flash Player
				Security.allowInsecureDomain("*");
				Security.allowDomain("*");
				
				_sectionMovie = null;
				_activeBackgroundImageContainer = null;
				_backgroundImageContainerList = new Array();
				_activeFacebookAIndex = 0;	// Facebook indeces pares
				_activeFacebookBIndex = 1;	// Facebook indeces impares
				_activeBlogAIndex = 0;		// Blog indeces pares
				_activeBlogBIndex = 1;		// Blog indeces impares
				_activeTwitterAIndex = 0;	// Twitter indeces pares
				_activeTwitterBIndex = 1;	// Twitter indeces impares
				_timerSocialComponents = new Timer(UPDATE_TIME_SOCIAL_COMPONENTS);				
				_timerSocialComponents.addEventListener(TimerEvent.TIMER, onTimerSocialComponents);
				_actualBackgroundContainer_sp = null;
			}
		}
		
		public static function getInstance():SharingSectionController 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new SharingSectionController();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get sectionVO():SectionVO { return _sectionVO; }
		public function set sectionVO(value:SectionVO):void { _sectionVO = value; }	
		
		public function get sectionMovie():MovieClip { return _sectionMovie; }
		public function set sectionMovie(value:MovieClip):void {  
			_sectionMovie = value;
			_sectionMovie.addEventListener(TableDataManager.SECTION_EVENT, onSharingEventHandler, false, 0, true);
			_sectionMovie.addEventListener(TableDataManager.HELLO_WINDOW, onHelloClickHandler, false, 0, true);
		}
		
		public function activateSection(idClient:String = null, idCase:String = null):void 
		{
			// Hace visibles todas sus secciones de informacion
			sectionMovie.visible = true;
			for(var i:uint = 0; i < _backgroundImageContainerList.length; i++)
				(_backgroundImageContainerList[i] as Sprite).visible = true;
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Reiniciando youtube player
			var url:String = _configurationVO.youtubeVideoURL;			
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			_youtubeVideoPlayer.cueVideoById(videoID, 0);
			
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
			trace("SharingSectionController->addBackgroundImageContainer()");		
			backgroundImageContainer.name = "sharingBackgroundImageContainer_" + _backgroundImageContainerList.length;
			_backgroundImageContainerList.push(backgroundImageContainer);
		}
		
		public function updateSharingImageInfo():void 
		{
			trace("SharingSectionController->updateLikeImageInfo()");
			
			// Visualizando el primer background
			var backgroundImageContainer:Sprite = _backgroundImageContainerList[_activeBackgroundId] as Sprite;
			_activeBackgroundImageContainer = backgroundImageContainer;
			_activeBackgroundImageContainer.visible = true;
			
		}
		
		public function buildSection(vo:SectionVO, idClient:String = null, idCase:String = null):void
		{
			// Actualizando campos
			_sectionVO = vo;
			
			// Creando un nuevo loader para ejecutar cargas ordenadas por la clase HomeSectionController
			SiteManager.getInstance().bulkLoader = new BulkLoader(SECTION_NAME); 
			
			// Obteniendo loader (BUlkLoader)
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			
			// Adicionado fichero de configuracion (futuramente se actualizara con una llamada a un servicio real PHP)
			bulkLoader.add(new URLRequest(URL_XML_SHARING_CONFIGURATION), {id: URL_XML_SHARING_CONFIGURATION });					
			
			// Configurando listeners
			bulkLoader.addEventListener(BulkLoader.COMPLETE, loadDisplayObjects);
			bulkLoader.addEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);
			bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			bulkLoader.start();	
		}
		
		public function loadDisplayObjects(evt:Event):void
		{
			// Eliminando los listeners
			var bulkLoader:BulkLoader = BulkLoader.getLoader(SECTION_NAME);
			bulkLoader.removeEventListener(BulkLoader.COMPLETE, loadDisplayObjects);
			bulkLoader.removeEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);	
			bulkLoader.removeEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			
			// Recuperando objeto XML del loader (BulkLoader)
			var sharingXML:XML = bulkLoader.getXML(URL_XML_SHARING_CONFIGURATION);
			
			// Parseando configuracion XML a Objetos de Datos (VO)
			_configurationVO = XMLParser.parseSharingXML(sharingXML);
			
			trace(_sectionVO.urlSWF);
			trace(_sectionVO.urlImage);
			
			// Adicionando a la carga de ficheros externos el swf de la seccion y su correspondiente imagen de fondo
			bulkLoader.add(new URLRequest(_sectionVO.urlSWF), {id: _sectionVO.urlSWF });
			bulkLoader.add(new URLRequest(_sectionVO.urlImage), {id: _sectionVO.urlImage });
			
			// Configurando listeners
			bulkLoader.addEventListener(BulkLoader.COMPLETE, onBulkSectionLoadedHandler);
			bulkLoader.addEventListener(BulkLoader.PROGRESS, SiteManager.getInstance().onBulkElementProgressHandler);
			bulkLoader.addEventListener(BulkLoader.ERROR, SiteManager.getInstance().onErrorHandler);
			bulkLoader.start();	
		}
		
		public function onBulkSectionLoadedHandler(evt:Event):void
		{
			trace("SharingSectionController->onBulkSectionLoadedHandler()");
			
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
			
			// Adicionando la imagen al contenedor de imagen
			backgroundImageContainer_sp.addChild(img);	
			
			// Actualizando contenedor de imagen para animacion de transiciones
			_actualBackgroundContainer_sp = backgroundImageContainer_sp;
			
			// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
			this.addBackgroundImageContainer(backgroundImageContainer_sp);
			
			// Adicionando el contenedor de imagen al contenedor principal (backgroundImagesContainer_sp)
			SiteManager.getInstance().backgroundImageContainer.addChild(backgroundImageContainer_sp);
			
			// Recupero el swf cargado (Like)
			var sharing_mc:MovieClip = bulkLoader.getMovieClip(_sectionVO.urlSWF);
			trace(sharing_mc);
			
			// Actualizando estado de la carga de la seccion
			SiteManager.getInstance().updateStatusLoadedSection(_sectionVO.id, true);
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Pasandole el homeMovie (Movieclip) a la clase controladora
			this.sectionMovie = sharing_mc;
			
			// Cargando datos de las redes sociales en los componentes de las secciones
			this.loadComponentSocialData();
			
			// Cargando player de video de youtube
			this.loadYouTubeVideoPlayer();
			
			// Actualizando seccion actual
			SiteManager.getInstance().activeSection = sharing_mc;
			
			// Agregando SWF cargado al Movieclip que representa la seccion de contenidos					
			SiteManager.getInstance().addInfoToSectionPanel(sharing_mc);
			
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
		
		private function onHelloClickHandler(evt:Event):void
		{
			SiteManager.getInstance().showHelloWindow();	
		}
		
		private function onSharingEventHandler(evt:EventComplex):void 
		{
			trace("SharingSectionController->onLikeEventHandler()");
			trace(evt.data);
			
			// Si el objeto de datos contenido en el evento es de tipo DataEventObject, el evento se refiere a una accion de cambio de seccion
			if(evt.data is DataEventObject)
			{
				// Obteniendo DataEvenObject con los datos de la accion a realizar
				var dataEO:DataEventObject = evt.data as DataEventObject;
				
				// Segun los datos del evento recibido (origin, destination, subdestination, action, etc), se ejecuta una accion
				var sectionVO:SectionVO = null;		
				
				// Actualizando antiguo background para realizar animacion de transicion
				SiteManager.getInstance().setOldBackgroundContainer(_actualBackgroundContainer_sp);
				
				// Reproduciendo sonido, esta funcion reproduce el sonido en caso de que no haya sido detenido por el usuario
				SiteManager.getInstance().onSoundButtonClick(null, true);
				
				if(dataEO.origin != dataEO.destination) 
				{
					// Deteniendo el timer de actualizacion de componentes
					_timerSocialComponents.stop();
					
					// Deteniendo reproduccion de video youtube
					_youtubeVideoPlayer.stopVideo();
					
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
						
						default:
							throw new Error("Unknow action");					
					}
				}				
			}			
		}
		
		private function loadComponentSocialData():void
		{
			// Obteniendo componentes de las distintas redes sociales
			var facebook_mc:MovieClip = _sectionMovie.facebook_mc;
			var blog_mc:MovieClip = _sectionMovie.blog_mc;
			var twitter_mc:MovieClip = _sectionMovie.twitter_mc;
						
			// Obteniendo los dos primeros social items de las redes sociales
			var facebookItemSocialA:ItemSocialVO = _configurationVO.facebookItemList[_activeFacebookAIndex] as ItemSocialVO;
			var facebookItemSocialB:ItemSocialVO = _configurationVO.facebookItemList[_activeFacebookBIndex] as ItemSocialVO;			
			var blogItemSocialA:ItemSocialVO = _configurationVO.blogItemList[_activeBlogAIndex] as ItemSocialVO;
			var blogItemSocialB:ItemSocialVO = _configurationVO.blogItemList[_activeBlogBIndex] as ItemSocialVO;		
			var twitterItemSocialA:ItemSocialVO = _configurationVO.twitterItemList[_activeTwitterAIndex] as ItemSocialVO;
			var twitterItemSocialB:ItemSocialVO = _configurationVO.twitterItemList[_activeTwitterBIndex] as ItemSocialVO;	
	
			// Cargando datos en componentes
			if(facebookItemSocialA != null)
			{
				facebook_mc.urlItemA = facebookItemSocialA.url;
				facebook_mc.dateA_dtxt.text = facebookItemSocialA.date;
				facebook_mc.textA_dtxt.text = facebookItemSocialA.text;
			}
			
			if(facebookItemSocialB != null)
			{
				facebook_mc.urlItemB = facebookItemSocialB.url;
				facebook_mc.dateB_dtxt.text = facebookItemSocialB.date;
				facebook_mc.textB_dtxt.text = facebookItemSocialB.text;
			}
			
			if(blogItemSocialA != null)
			{
				blog_mc.urlItemA = blogItemSocialA.url;
				blog_mc.dateA_dtxt.text = blogItemSocialA.date;
				blog_mc.textA_dtxt.text = blogItemSocialA.text;
			}
			
			if(blogItemSocialB != null)
			{
				blog_mc.urlItemB = blogItemSocialB.url;
				blog_mc.dateB_dtxt.text = blogItemSocialB.date;
				blog_mc.textB_dtxt.text = blogItemSocialB.text;
			}
			
			if(twitterItemSocialA != null)
			{
				twitter_mc.urlItemA = twitterItemSocialA.url;
				twitter_mc.dateA_dtxt.text = twitterItemSocialA.date;
				twitter_mc.textA_dtxt.text = twitterItemSocialA.text;
			}
			
			if(twitterItemSocialB != null)
			{
				twitter_mc.urlItemB = twitterItemSocialB.url;
				twitter_mc.dateB_dtxt.text = twitterItemSocialB.date;
				twitter_mc.textB_dtxt.text = twitterItemSocialB.text;
			}
			
			// Iniciando el timer
			_timerSocialComponents.start();
		}	
		
		private function loadYouTubeVideoPlayer():void 
		{
			// Referencia a la API AS3 de YouTube: http://code.google.com/intl/es-ES/apis/youtube/flash_api_reference.html
			
			// This will hold the API player instance once it is initialized.
			_youtubeLoader = new Loader();
			_youtubeLoader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			_youtubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));					
		}
		
		private function onLoaderInit(event:Event):void 
		{
			// Obteniendo movieclip del componente YouTube
			var youtube_mc:MovieClip = _sectionMovie.youtube_mc;
			
			youtube_mc.videoPlayer.addChild(_youtubeLoader);
			_youtubeLoader.content.addEventListener("onReady", onPlayerReady);
			_youtubeLoader.content.addEventListener("onError", onPlayerError);
			_youtubeLoader.content.addEventListener("onStateChange", onPlayerStateChange);
			_youtubeLoader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onPlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			_youtubeVideoPlayer = _youtubeLoader.content;
			_youtubeVideoPlayer.setSize(215, 194);
			
			// Obteniendo movieclip del componente YouTube
			var youtube_mc:MovieClip = _sectionMovie.youtube_mc;
			
			// Invisivilizando video loader
			youtube_mc.videoLoader_mc.visible = false;
			
			// Cargar video segun ID de video youtube
			var url:String = _configurationVO.youtubeVideoURL;
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			_youtubeVideoPlayer.cueVideoById(videoID, 0);
		}
				
		private function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
			
			switch(Object(event).data)
			{
				case 0:		// Video detenido 
					SiteManager.getInstance().onSoundButtonClick(null, true);
					this.onPlayerReady(null);
					break;
				
				case 1: 	// Video reproduciendo
					SiteManager.getInstance().onSoundButtonClick(null, false);
					break;
								
			}
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
		
		private function onTimerSocialComponents(evt:TimerEvent):void
		{
			trace("SharingSectionController->onTimerSocialComponents()");
			
			// Obteniendo componentes de las distintas redes sociales
			var facebook_mc:MovieClip = _sectionMovie.facebook_mc;
			var blog_mc:MovieClip = _sectionMovie.blog_mc;
			var twitter_mc:MovieClip = _sectionMovie.twitter_mc;
			
			// Proximos elementos pares
			_activeFacebookAIndex += 2;
			_activeBlogAIndex += 2;
			_activeTwitterAIndex += 2;
			
			// Proximos elementos impares
			_activeFacebookBIndex += 2;
			_activeBlogBIndex += 2;
			_activeTwitterBIndex += 2;

			// Verificando si existe ese elemento, actualizando indices
			if(_configurationVO.facebookItemList[_activeFacebookAIndex] == null) {_activeFacebookAIndex = 0;}
			if(_configurationVO.facebookItemList[_activeFacebookBIndex] == null) {_activeFacebookBIndex = 1;}
						
			if(_configurationVO.blogItemList[_activeBlogAIndex] == null) {_activeBlogAIndex = 0;}
			if(_configurationVO.blogItemList[_activeBlogBIndex] == null) {_activeBlogBIndex = 1;}
			
			if(_configurationVO.twitterItemList[_activeTwitterAIndex] == null) {_activeTwitterAIndex = 0;}				
			if(_configurationVO.twitterItemList[_activeTwitterBIndex] == null) {_activeTwitterBIndex = 1;}
			
			// Obteniendo objetos de datos en indices pares e impares
			var facebookItemSocialA:ItemSocialVO = _configurationVO.facebookItemList[_activeFacebookAIndex] as ItemSocialVO;
			var facebookItemSocialB:ItemSocialVO = _configurationVO.facebookItemList[_activeFacebookBIndex] as ItemSocialVO;			
			var blogItemSocialA:ItemSocialVO = _configurationVO.blogItemList[_activeBlogAIndex] as ItemSocialVO;
			var blogItemSocialB:ItemSocialVO = _configurationVO.blogItemList[_activeBlogBIndex] as ItemSocialVO;		
			var twitterItemSocialA:ItemSocialVO = _configurationVO.twitterItemList[_activeTwitterAIndex] as ItemSocialVO;
			var twitterItemSocialB:ItemSocialVO = _configurationVO.twitterItemList[_activeTwitterBIndex] as ItemSocialVO;	
			
			// Cargando datos en componentes
			facebook_mc.urlItemA = facebookItemSocialA.url;
			facebook_mc.dateA_dtxt.text = facebookItemSocialA.date;
			facebook_mc.textA_dtxt.text = facebookItemSocialA.text;
			
			facebook_mc.urlItemB = facebookItemSocialB.url;
			facebook_mc.dateB_dtxt.text = facebookItemSocialB.date;
			facebook_mc.textB_dtxt.text = facebookItemSocialB.text;
			
			blog_mc.urlItemA = blogItemSocialA.url;
			blog_mc.dateA_dtxt.text = blogItemSocialA.date;
			blog_mc.textA_dtxt.text = blogItemSocialA.text;
			
			blog_mc.urlItemB = blogItemSocialB.url;
			blog_mc.dateB_dtxt.text = blogItemSocialB.date;
			blog_mc.textB_dtxt.text = blogItemSocialB.text;
			
			twitter_mc.urlItemA = twitterItemSocialA.url;
			twitter_mc.dateA_dtxt.text = twitterItemSocialA.date;
			twitter_mc.textA_dtxt.text = twitterItemSocialA.text;
			
			twitter_mc.urlItemB = twitterItemSocialB.url;
			twitter_mc.dateB_dtxt.text = twitterItemSocialB.date;
			twitter_mc.textB_dtxt.text = twitterItemSocialB.text;
		}			
	}
}