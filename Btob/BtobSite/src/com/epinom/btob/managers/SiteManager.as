/**
* ...
* SiteManager, versión AS3
* Lleva el control de toda la aplicacion, incluyendo el manejo de todas las clases que la integran y los datos relacionados.
* Utiliza un patron Singleton, con el objetivo de que solo pueda existir una unica instancia de la clase.
* 
* @author Ernesto Pino Martínez
* @date 10/09/2010
*/

package com.epinom.btob.managers
{	
	/**
	 * @import
	 */	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import com.digitalsurgeons.loading.BulkLoader;
	import com.digitalsurgeons.loading.BulkProgressEvent;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.CaseVO;
	import com.epinom.btob.data.ComponentVO;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.GreatVO;
	import com.epinom.btob.data.ItemGalleryVO;
	import com.epinom.btob.data.LinkVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.SocialVO;
	import com.epinom.btob.data.SoundVO;
	import com.epinom.btob.data.YouTubeObject;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.events.XMLServiceEvent;
	import com.epinom.btob.objects.InterfaceObject;
	import com.epinom.btob.services.XMLFileService;
	import com.epinom.btob.ui.BtobComponent;
	import com.epinom.btob.ui.ClientSectionController;
	import com.epinom.btob.ui.ExperiencesSectionController;
	import com.epinom.btob.ui.HomeSectionController;
	import com.epinom.btob.ui.HomeSectionMovie;
	import com.epinom.btob.ui.ISectionController;
	import com.epinom.btob.ui.LikeSectionController;
	import com.epinom.btob.ui.SharingSectionController;
	import com.epinom.btob.ui.WeSectionController;
	import com.epinom.btob.utils.ContactFormAttachment;
	import com.epinom.btob.utils.StringUtils;
	import com.epinom.btob.utils.XMLParser;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.sampler.pauseSampling;
	import flash.system.Security;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.EastAsianJustifier;
	import flash.utils.getDefinitionByName;
	
	import flashx.textLayout.formats.FormatValue;
	
	import nl.michelvandersteege.transitions.BitmapdataTransitions;


	public class SiteManager
	{
		/**
		 * @property
		 * Instancia de la clase SiteManager, se instancia una unica vez (Singleton)
		 */
		private static var _instance:SiteManager = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean;
		
		/**
		 * @property
		 * Referencia al escenario de la pelicula principal
		 */
		private var _stage:Stage;
		
		/**
		 * @property
		 * Servicio para la carga de ficheros XML externos
		 */
		private var _xmlService:XMLFileService;
		
		/**
		 * @property
		 * Loader que gestiona multiples descargas 
		 */
		private var _bulkLoader:BulkLoader;
		
		/**
		 * @property
		 * Objetos que representan las secciones 
		 */
		private var _homeSectionController:HomeSectionController;
		private var _weSectionController:WeSectionController;
		private var _likeSectionController:LikeSectionController;
		private var _sharingSectionController:SharingSectionController;
		private var _experiencesSectionController:ExperiencesSectionController;
		private var _clientSectionController:ClientSectionController;
		
		/**
		 * @property
		 * Estados de la carga de secciones 
		 */
		private var _statusLoadedSectionList:Array;
		
		/**
		 * @property
		 * Variables que se utilizaran como referencias de objetos visuales
		 */						
		private var loader_mc:MovieClip;
		private var loader_io:InterfaceObject;
		private var bgImage_mc:MovieClip;
		private var bgImage_io:InterfaceObject;
		private var sectionPanel_mc:MovieClip;
		private var sectionPanel_io:InterfaceObject;
		private var bottomPanel_mc:MovieClip;
		private var bottomPanel_io:InterfaceObject;
		private var infoPanel_mc:MovieClip;
		private var infoPanel_io:InterfaceObject;
		private var modalPanel_mc:MovieClip;
		private var modalPanel_io:InterfaceObject;
		private var modalWindow_mc:MovieClip;
		private var modalWindow_io:InterfaceObject;
		private var helloWindow_mc:MovieClip;
		private var helloWindow_io:InterfaceObject;
		private var errorWindow_mc:MovieClip;
		private var errorWindow_io:InterfaceObject;
		private var manager_mc:MovieClip;
		
		private var backgroundImagesContainer_sp:Sprite;
		private var greatImagesContainer_io:InterfaceObject;
		private var activeSection_mc:MovieClip;
		private var activeSectionController:ISectionController;
		private var backSectionController:ISectionController;
		private var sectionControllerList:Array;	
		private var activeBackground_sp:Sprite;
		
		/**
		 * @property
		 * Constantes
		 */	
		public static const SECTION_MANAGER:String = "manager";
		public static const SECTION_HOME:String = "home";
		public static const SECTION_WE:String = "we";
		public static const SECTION_LIKE:String = "like";
		public static const SECTION_SHARING:String = "sharing";
		public static const SECTION_EXPERIENCES:String = "experiences";
		public static const COMPONENT_GRID_HASH:String = "grid";
		public static const COMPONENT_LOADER_HASH:String = "loader";
		public static const COMPONENT_BACKGROUND_IMAGE_HASH:String = "bgImage";
		public static const COMPONENT_SECTION_PANEL_HASH:String = "sectionPanel";
		public static const COMPONENT_BOTTOM_PANEL_HASH:String = "bottomPanel";
		public static const COMPONENT_INFO_PANEL_HASH:String = "infoPanel";
		public static const COMPONENT_MODAL_PANEL_HASH:String = "modalPanel";
		public static const COMPONENT_MODAL_WINDOW_HASH:String = "modalWindow";
		public static const COMPONENT_LINK_BUTTON_HASH:String = "linkButton";
		public static const COMPONENT_HELLO_WINDOW_HASH:String = "helloWindow";
		public static const COMPONENT_ERROR_WINDOW_HASH:String = "errorWindow";
		private static const URL_SETTINGS_APP:String = "config/settings.xml";	
		
		//public static const ACTIVE_SERVICE_SIDE:Boolean = false; 
		//private static const URL_GREATS:String = "config/greats.xml";
		//private static const URL_VOTE_CASE_PHP_SERVICE:String = "http://btob.es/back/workVote";
		
		//public static const ACTIVE_SERVICE_SIDE:Boolean = false; 
		//private static const URL_GREATS:String = "/back/greats.xml";
		//private static const URL_VOTE_CASE_PHP_SERVICE:String = "/back/workVote";
		
		public static const ACTIVE_SERVICE_SIDE:Boolean = true; 
		private static const URL_GREATS:String = "http://btob.es/back/greats.xml";
		private static const URL_VOTE_CASE_PHP_SERVICE:String = "http://btob.es/back/workVote";
		
		public static const TOOLTIP_A:String = "tooltipA";
		public static const TOOLTIP_B:String = "tooltipB";
		public static const NEXT:String = "next";
		public static const PREV:String = "prev";		
		private static const PADDING_TEXT:Number = 3;
		private static const PADDING_BUTTON:Number = 10;
		
		// Transiciones
		private static const BLOCK_COUNT:uint = 107;	
		private var gridTransition_mc:MovieClip;
		private var gridTransition_io:InterfaceObject;
		private var maskGridOn_mc:MovieClip;
		private var maskGridOn_io:InterfaceObject;
		private var maskGridOff_mc:MovieClip;
		private var maskGridOff_io:InterfaceObject;	
		private var GridMask:Class;
		private var oldBackgroundContainer_sp:Sprite;
		private var bitmapdataTransitions:BitmapdataTransitions;
		
		// Navegacion de ventana modal
		private var activeCaseVOModalWindow:CaseVO;
		private var indexItem0ModalWindowNavigation:uint;
		private var indexItem1ModalWindowNavigation:uint;
		private var indexItem2ModalWindowNavigation:uint;
		private var isAddedHandlersToModalWindowNavigationButtons:Boolean;
		
		// Youtube Player (Ventana Modal)
		private var _youtubeObjectList:Array;	// [Object]: youtubeVideoPlayer, youtubeLoader, youtubeContainer
		private var _mainYoutubeVideoPlayer:Object;
		private var _mainYoutubeLoader:Loader;
		private var _mainYoutubeURL:String;
		
		// Variables para controlar sonido
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _isSoundPlaying:Boolean;
		private var _isUserSoundOff:Boolean;
		private var _sound_mc:MovieClip;
		
		private var urlServerPath:String;
		
		/**
		 * @constructor
		 * Constructor de la clase SiteManager
		 * 		 
		 * @param 	stage 	Referencia al escenario de la pelicula principal	 
		 */
		public function SiteManager(stage:Stage)
		{		
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SiteManager.getInstance() instead of new.");
			} else {				
				trace("SiteManager->SiteManager()");
				trace("*** ACTIVE_SERVICE_SIDE = ***" + ACTIVE_SERVICE_SIDE);
				
				// Agregando cualquier dominio para temas de seguridad de Flash Player
				Security.allowInsecureDomain("*");
				Security.allowDomain("*");
				
				// Inicializando propiedades
				_stage = stage;
				_xmlService = new XMLFileService(); 
				_bulkLoader = new BulkLoader("BtobLoader");	
				_bulkLoader.logLevel = BulkLoader.LOG_INFO;	
				sectionControllerList = new Array();
				
				// Controladores de secciones
				_homeSectionController = HomeSectionController.getInstance();
				_weSectionController = WeSectionController.getInstance();
				_likeSectionController = LikeSectionController.getInstance();	
				_sharingSectionController = SharingSectionController.getInstance();
				_experiencesSectionController = ExperiencesSectionController.getInstance();
				_clientSectionController = ClientSectionController.getInstance();
				activeSectionController = null;
				backSectionController = null;
				activeBackground_sp = null;
				
				/* Estados de carga de las diferentes secciones
					<section id ="0" name="manager" urlSWF="manager.swf" urlImage=""/>
					<section id ="1" name="home" urlSWF="sections/home.swf" urlImage=""/>
					<section id ="2" name="we" urlSWF="sections/we.swf" urlImage="imgs/we.jpg"/>
					<section id ="3" name="like" urlSWF="sections/like.swf" urlImage="imgs/like.jpg"/>
					<section id ="4" name="sharing" urlSWF="sections/sharing.swf" urlImage="imgs/sharing.jpg"/>
					<section id ="5" name="experiences" urlSWF="sections/experiences.swf" urlImage="imgs/experiences.jpg"/>
					<section id ="6" name="client" urlSWF="sections/client.swf" urlImage=""/>
					<section id ="7" name="awards" urlSWF="sections/awards.swf" urlImage="imgs/awards.jpg"/>
				*/
				_statusLoadedSectionList = new Array(false, false, false, false, false, false, false, false);
				
				// Inicializando variables para control de la ventana modal
				this.activeCaseVOModalWindow = null;
				this.indexItem0ModalWindowNavigation = 0;
				this.indexItem1ModalWindowNavigation = 1;
				this.indexItem2ModalWindowNavigation = 2;
				this.isAddedHandlersToModalWindowNavigationButtons = false;							
				
				// Inicializando lista de objetos con tres elementos, uno por cada uno de los elementos de navegacion de la ventana modal
				_youtubeObjectList = new Array(3);
				
				// Adicionando elementos a la lista correspondiente (objetos de tipo YouTubeObject, contenedor de datos)
				_youtubeObjectList[0] = new YouTubeObject(0, new Loader());
				_youtubeObjectList[1] = new YouTubeObject(1, new Loader());
				_youtubeObjectList[2] = new YouTubeObject(2, new Loader());
				
				// Transicion entre secciones
				oldBackgroundContainer_sp = null;
				
				
				// Inicializacion de las variables que controlan el sonido
				_sound = new Sound();
				_soundChannel = new SoundChannel();
				_isSoundPlaying = false;
				_isUserSoundOff = false;
				
				// Transition section
				bitmapdataTransitions = new BitmapdataTransitions();
				
				// Inicializando movieclip manager
				this.manager_mc = null;
				
				// Verificando si esta activa la carga de imagenes desde el servidor 
				this.urlServerPath = "";
				if(SiteManager.ACTIVE_SERVICE_SIDE)
					this.urlServerPath = TableDataManager.URL_PATH_SERVER;
				
				// Iniciando applicacion
				init();							
			}						
		}
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase SiteManager
		 * 
		 * @return	instancia	Unica instancia de la clase SiteManager 	
		 */
		public static function getInstance(stage:Stage = null):SiteManager 
		{
			if (_instance == null && stage != null) 
			{
				_allowInstantiation = true;
				_instance = new SiteManager(stage);
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * @method
		 * Devuelve la referencia al escenario
		 * 
		 * @return	stage	Referencia al escenario
		 */
		public function getStageReference():Stage {
			return _stage;
		}
		
		public function get bulkLoader():BulkLoader {
			return _bulkLoader;
		}
		
		public function set bulkLoader(value:BulkLoader):void {
			_bulkLoader = value;
		}
		
		public function get activeSection():MovieClip {
			return activeSection_mc;
		}
		
		public function set activeSection(value:MovieClip):void {
			if(activeSection != value)
				activeSection_mc.visible = false;
			activeSection_mc = value;
		}
		
		public function get backgroundImageContainer():Sprite {
			return backgroundImagesContainer_sp;
		}
		
		public function get isSoundPlaying():Boolean { return _isSoundPlaying; }
		public function set isSoundPlaying(value:Boolean):void { _isSoundPlaying = value; }
		
		public function get isUserSoundOff():Boolean { return _isUserSoundOff; }
		public function set isUserSoundOff(value:Boolean):void { _isUserSoundOff = value; }
		
		public function addInfoToSectionPanel(mc:MovieClip):void 
		{
			// Adiionando elemento al panel de informacion
			sectionPanel_mc.infoSectionPanel_mc.addChild(mc);
			
			/*
			var bitmapdataTransitions:BitmapdataTransitions = new BitmapdataTransitions();			
			bitmapdataTransitions.verBar(mc,"in",5,"L",false,false,true,0.5,"followUp:60","linear");
			sectionPanel_mc.infoSectionPanel_mc.addChild(bitmapdataTransitions);
			*/
		}
		
		private function addSectionControllerToList(sectionController:ISectionController):void {
			sectionControllerList[sectionController.sectionVO.id] = sectionController;
		}
		
		public function getBackSectionController():ISectionController {
			return backSectionController;
		}
		
		public function getActiveBackground():Sprite {
			return activeBackground_sp;
		}
		
		public function setActiveBackground(value:Sprite):void{
			activeBackground_sp = value;
		}
		
		/**
		 * @method
		 * Actualiza el estado de las secciones cargadas
		 * 
		 * @param	index	Posicion de la seccion en la lista
		 * @param	value	Estado de carga (true, false)
		 */
		public function updateStatusLoadedSection(index:uint, value:Boolean):void {
			_statusLoadedSectionList[index] = value;
		}
		
		/**
		 * @method
		 * Devuele true o false, en dependencia del estado de carga de una seccion segun su indice en la lista
		 * 
		 * @param	index		Posicion de la seccion en la lista
		 * @return 	Boolean		Si la seccion ha sido cargada con anterioridad devuelve true, en caso contrario falso	
		 */
		public function isSectionLoaded(index:uint):Boolean {
			return _statusLoadedSectionList[index];
		}
		
		public function getOldBackgroundContainer():Sprite {
			//this.showErrorWindow("getOldBackgroundContainer() name: " + this.oldBackgroundContainer_sp.name);
			return this.oldBackgroundContainer_sp;
		}
		
		public function setOldBackgroundContainer(value:Sprite):void {
			this.oldBackgroundContainer_sp = value;
			//this.showErrorWindow("setOldBackgroundContainer() name: " + this.oldBackgroundContainer_sp.name);
		}
		
		/**
		 * @method
		 * Muestra una seccion que ha sido cargada anteriormente
		 * 
		 * @param	index		Posicion de la seccion en la lista		 
		 */
		public function showSection(sectionController:ISectionController, idClient:String = null, idCase:String = null):void 
		{	
			trace("SiteManager->showSection()");	
			trace("Secciones cargadas: " + _statusLoadedSectionList);
			
			// Haciendo visible la seccion correspondiente
			sectionController.activateSection(idClient, idCase);
		}
		
		/**
		 * @method
		 * Actualiza el controlador de seccion activo
		 * 
		 * @param	sectionController	Nuevo controlador de seccion		 
		 */
		public function updateSectionController(sectionController:ISectionController):void 
		{
			if(activeSectionController != null)
				activeSectionController.desactivateSection();
			activeSectionController = sectionController; 
		}
		
		/**
		 * @method
		 * Actualiza el controlador para volver desde la seccion cliente
		 * 
		 * @param	sectionController	Controlador anterior		 
		 */
		public function updateBackSectionController(sectionController:ISectionController):void  {
			backSectionController = sectionController;
		}
		
		/**
		 * @method 
		 * Inicializa la configuracion y la ejecucion de la aplicacion		 
		 */
		public function init():void 
		{
			// Estableciendo URL del fichero de configuracion
			BtobDataModel.getInstance().settings.settingsXMLLocation = URL_SETTINGS_APP; 
			
			// Activando detectores de eventos para el servicio de carga de ficheros XML externos
			_xmlService.addEventListener(XMLServiceEvent.XML_LOADED, onXMLSettingsLoadedHandler);
			_xmlService.addEventListener(XMLServiceEvent.XML_ERROR, onXMLSettingsErrorHandler);
			
			// Cargando fichero de configuracion externo
			_xmlService.loadXMLFile(BtobDataModel.getInstance().settings.settingsXMLLocation);
		}
		
		public function showLoader():void 
		{			
			// Reiniciando barra de precarga del loader
			modalPanel_mc.visible = true;				
			loader_mc.bar_mc.gotoAndStop(0);			
			
			// Realizando animacion del objeto de loading visual
			loader_mc.x = _stage.stageWidth / 2;
			loader_mc.y = _stage.stageHeight / 2;					
			loader_mc.alpha = 0;	
			Tweener.addTween(loader_mc, {alpha:1, time:1, transition:"easeOutCubic"});
			Tweener.addTween(loader_mc, { x:loader_mc.x, y:loader_mc.y - 40, time:1, transition:"easeOutCubic"});	
		}
				
		public function hideLoader():void 
		{
			// Realizando animacion del objeto de loader visual			
			Tweener.addTween(loader_mc, {alpha:0, time:1, transition:"easeOutCubic"});
			Tweener.addTween(loader_mc, {x:loader_mc.x, y:loader_mc.y + 40, time:1, transition:"easeOutCubic"} );
			modalPanel_mc.visible = false;			
		}		
		
		/**
		 * @method
		 * Funcion que se ejecuta una vez finalizada la carga del fichero de configuracion externo (XML) 
		 * 
		 * @param	evt		Evento que lanza la clase XMLFileService
		 */
		private function onXMLSettingsLoadedHandler(evt:XMLServiceEvent):void
		{
			trace("SiteManager->onXMLSettingsLoadedHandler()");	
			
			// Desactivando detectores de eventos para el servicio de carga de ficheros XML externos
			_xmlService.removeEventListener(XMLServiceEvent.XML_LOADED, onXMLSettingsLoadedHandler);
			_xmlService.removeEventListener(XMLServiceEvent.XML_ERROR, onXMLSettingsErrorHandler);
			
			// Parseando fichero XML de configuracion
			BtobDataModel.getInstance().settings = XMLParser.parseSettingsXML(_xmlService.data, BtobDataModel.getInstance().settings);

			// Configurando StageManage
			StageManager.getInstance().config(BtobDataModel.getInstance().settings.resolution.width, BtobDataModel.getInstance().settings.resolution.height);
			
			// LOADING 
			/* 
				Existe una relacion entre el className del fichero de configuracion principal para un objeto COMPONENT
			   	y el LinkageName de la biblioteca del fichero FLA.
			
				En este caso el objeto visual se encuantra en la biblioteca del fichero "main.fla" y tiene un LinkageName = BtobLoaderMC.
				A traves de identificador podemos recuperar el objeto desde la biblioteca y visualizarlo en pantalla.			
			*/
			
			// Creando un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var loaderVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_LOADER_HASH);
			var BtobLoader:Class = getDefinitionByName(loaderVO.className) as Class;
			
			// Creando objeto de tipo BtobLoader
			loader_mc = new BtobLoader();
			loader_mc.name = loaderVO.instanceName;
			
			// Creo un objeto de tipo InterfaceObject
			loader_io = new InterfaceObject(loader_mc,
											loaderVO.className,
											loaderVO.instanceName,
											loaderVO.hashId,
											loaderVO.changeSize,
											loaderVO.percentageWidth,
											loaderVO.percentageHeight,
											loaderVO.changePositionX,
											loaderVO.changePositionY,
											loaderVO.percentageX,
											loaderVO.percentageY);																				
			
			// Actualizando modelo de datos
			var loaderComponent:BtobComponent = new BtobComponent(loaderVO, loader_io, loader_mc);
			BtobDataModel.getInstance().componentList.push(loaderComponent);	
			
			// Cargando XML externo con la configuracion de los destacados
			/* Esta accion se cambiara a futuro por peticion a un servicio PHP que devuelve el XML con los datos */
			
			// Activando detectores de eventos para el servicio de carga de ficheros XML externos
			_xmlService.addEventListener(XMLServiceEvent.XML_LOADED, onXMLGreatsLoadedHandler);
			_xmlService.addEventListener(XMLServiceEvent.XML_ERROR, onErrorHandler);
			
			// Cargando fichero de configuracion externo
			_xmlService.loadXMLFile(URL_GREATS);
		}
		
		private function onXMLGreatsLoadedHandler(evt:XMLServiceEvent):void
		{
			trace("SiteManager->onXMLGreatsLoadedHandler()");	
			
			// Desactivando detectores de eventos para el servicio de carga de ficheros XML externos
			_xmlService.removeEventListener(XMLServiceEvent.XML_LOADED, onXMLGreatsLoadedHandler);
			_xmlService.removeEventListener(XMLServiceEvent.XML_ERROR, onErrorHandler);
			
			// Parseando fichero XML de configuracion
			BtobDataModel.getInstance().settings.greatVOList = XMLParser.parseGreatXML(_xmlService.data);				
			
			// Adicionando imagenes de destacados a la cola de descargas
			for(var i:uint = 0; i < BtobDataModel.getInstance().settings.greatVOList.length; i++)
			{
				var greatVO:GreatVO = BtobDataModel.getInstance().settings.greatVOList[i] as GreatVO;
				_bulkLoader.add(new URLRequest(this.urlServerPath + greatVO.urlImage), {id: this.urlServerPath + greatVO.urlImage });
				
				if(greatVO.typeThumb == TableDataManager.IMAGE_TYPE)
					_bulkLoader.add(new URLRequest(this.urlServerPath + greatVO.urlThumb), {id: this.urlServerPath + greatVO.urlThumb });
			}	
			
			// Adicionando manager (swf) a la cola de descargas
			var managerVO:SectionVO = BtobDataModel.getInstance().settings.getSectionByName(SECTION_MANAGER);
			_bulkLoader.add(new URLRequest(managerVO.urlSWF), {id: SECTION_MANAGER});
						
			// Adicionando home (swf) a la cola de descargas
			var homeVO:SectionVO = BtobDataModel.getInstance().settings.getSectionByName(SECTION_HOME);
			_bulkLoader.add(new URLRequest(homeVO.urlSWF), {id: SECTION_HOME});
			
			// Configurando listeners
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
			_bulkLoader.addEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);
			_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorHandler);
			_bulkLoader.start();
			
			// Agregando objeto al escenario
			var loaderVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_LOADER_HASH);
			StageManager.getInstance().addObject(loaderVO.hashId, loader_io, loaderVO.visible);
			
			// Realizando animacion del objeto de loading visual
			loader_mc.x = _stage.stageWidth / 2;
			loader_mc.y = _stage.stageHeight / 2;
			loader_mc.alpha = 0;	
			Tweener.addTween(loader_mc, {alpha:1, time:1, transition:"easeOutCubic"});
			Tweener.addTween(loader_mc, { x:loader_mc.x, y:loader_mc.y - 40, time:1, transition:"easeOutCubic"});		
		}
		
		private function onBulkElementLoadedHandler(evt:Event):void 
		{
			trace("SiteManager->onBulkElementLoadedHandler()");
			
			// Desactivando detectores de eventos
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);	
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorHandler);
			
			// Realizando animacion del objeto de loader visual
			Tweener.addTween(loader_mc, {alpha:0, time:1, transition:"easeOutCubic"});
			Tweener.addTween(loader_mc, {x:loader_mc.x, y:loader_mc.y + 40, time:1, transition:"easeOutCubic"} );					
			
			// Nivel 0 (mas profundo): La imagen del primer destacado
			
			// Creando objeto de datos referente greatImagesContainer
			var greatImagesContainerVO:ComponentVO = new ComponentVO();
			greatImagesContainerVO.type = "Sprite";
			greatImagesContainerVO.className = "GreatImagesContainerSP";
			greatImagesContainerVO.instanceName = "backgroundImagesContainer_sp";
			greatImagesContainerVO.visible = true;
			greatImagesContainerVO.hashId = "greatImagesContainer";
			greatImagesContainerVO.url = "";
			greatImagesContainerVO.changeSize = true;
			greatImagesContainerVO.percentageWidth = 100;
			greatImagesContainerVO.percentageHeight = 100;
			greatImagesContainerVO.changePositionX = false;
			greatImagesContainerVO.changePositionY = false;
			greatImagesContainerVO.percentageX = 0;
			greatImagesContainerVO.percentageY = 0;
			greatImagesContainerVO.centralReference = false;
			greatImagesContainerVO.elementOrder = -1;
			greatImagesContainerVO.yPosition = -1;
			greatImagesContainerVO.percentagePadding = false;
			greatImagesContainerVO.paddingTop = -1;
			greatImagesContainerVO.paddingBottom = -1;
			greatImagesContainerVO.paddingLeft = -1;
			greatImagesContainerVO.paddingRight = -1;
			
			// Creando sprite contenedor (greatImagesContainer), donde se iran cargando los sprites que a su vez contienen las imagenes de los destacados
			backgroundImagesContainer_sp = new Sprite();	   
			backgroundImagesContainer_sp.name = greatImagesContainerVO.instanceName;
			
			// Creando un sprite contenedor para cada una de las imagenes de los destacados
			for(var i:uint = 0; i < BtobDataModel.getInstance().settings.greatVOList.length; i++)
			{
				// Inicializando contenedor
				var backgroundImageContainer_sp:Sprite = new Sprite();
				
				// Recuperando objeto de datos
				var greatVO:GreatVO = BtobDataModel.getInstance().settings.greatVOList[i] as GreatVO;

				// Configurando contenedor de la imagen
				backgroundImageContainer_sp.visible = false;				
				
				// Recuperando imagen cargada por el gestor de descargas multiples
				var img:Bitmap = _bulkLoader.getBitmap(this.urlServerPath + greatVO.urlImage);
				
				// Adicionando la imagen al contenedor de imagen
				backgroundImageContainer_sp.addChild(img);	
				
				// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
				_homeSectionController.addBackgroundImageContainer(backgroundImageContainer_sp);
				
				// Adicionando el contenedor de imagen al contenedor principal (backgroundImagesContainer_sp)
				backgroundImagesContainer_sp.addChild(backgroundImageContainer_sp);
			}
			
			// BACKGROUND IMAGE CONTAINER					
			
			// Creando un objeto de tipo InterfaceObject
			greatImagesContainer_io = new InterfaceObject(backgroundImagesContainer_sp, 
			greatImagesContainerVO.className,
			greatImagesContainerVO.instanceName,
			greatImagesContainerVO.hashId,
			greatImagesContainerVO.changeSize,
			greatImagesContainerVO.percentageWidth,
			greatImagesContainerVO.percentageHeight,
			greatImagesContainerVO.changePositionX,
			greatImagesContainerVO.changePositionY,
			greatImagesContainerVO.percentageX,
			greatImagesContainerVO.percentageY);	
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(greatImagesContainerVO.hashId, greatImagesContainer_io, greatImagesContainerVO.visible); 
			
			// Actualizando modelo de datos
			var greatImagesContainer:BtobComponent = new BtobComponent(greatImagesContainerVO, greatImagesContainer_io, backgroundImagesContainer_sp);
			BtobDataModel.getInstance().componentList.push(greatImagesContainer);

			// Construyendo interfaz, se le pasa el mismo evento que recibe para poder acceder al loaderInfo 
			buildInterface();
		}
		
		public function buildInterface():void
		{
			// Recupero el swf cargado (MANAGER)
			manager_mc = _bulkLoader.getMovieClip(SECTION_MANAGER);
			var managerVO:SectionVO = BtobDataModel.getInstance().settings.getSectionByName(SECTION_MANAGER);
			updateStatusLoadedSection(managerVO.id, true);
						
			// TRANSITION GRID
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var gridTransitionVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_GRID_HASH);					
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var GridTransition:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(gridTransitionVO.className) as Class;
			GridMask = manager_mc.loaderInfo.applicationDomain.getDefinition(gridTransitionVO.className) as Class;
			
			// Creo un objetos de tipo GridTransition
			gridTransition_mc = new GridTransition();		
			
			// Configurando bloques de la malla (visible = false)
			this.configGridTransition(); 
			
			// Creo objetos de tipo InterfaceObject
			gridTransition_io = new InterfaceObject(gridTransition_mc,
													gridTransitionVO.className,
													gridTransitionVO.instanceName,
													gridTransitionVO.hashId,
													gridTransitionVO.changeSize,
													gridTransitionVO.percentageWidth,
													gridTransitionVO.percentageHeight,
													gridTransitionVO.changePositionX,
													gridTransitionVO.changePositionY,
													gridTransitionVO.percentageX,
													gridTransitionVO.percentageY);		
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(gridTransitionVO.hashId, gridTransition_io, gridTransitionVO.visible);			
		
			// Actualizando modelo de datos
			var gridTransitionComponent:BtobComponent = new BtobComponent(gridTransitionVO, gridTransition_io, gridTransition_mc);
			BtobDataModel.getInstance().componentList.push(gridTransitionComponent);				
	
			// SECTION PANEL
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var sectionPanelVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_SECTION_PANEL_HASH);					
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var SectionPanel:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(sectionPanelVO.className) as Class;
			
			// Creo un objeto de tipo SectionPanel
			sectionPanel_mc = new SectionPanel();
			sectionPanel_mc.name = sectionPanelVO.instanceName;			
			
			// Creo un objeto de tipo InterfaceObject
			sectionPanel_io = new InterfaceObject(sectionPanel_mc,
												sectionPanelVO.className,
												sectionPanelVO.instanceName,
												sectionPanelVO.hashId,
												sectionPanelVO.changeSize,
												sectionPanelVO.percentageWidth,
												sectionPanelVO.percentageHeight,
												sectionPanelVO.changePositionX,
												sectionPanelVO.changePositionY,
												sectionPanelVO.percentageX,
												sectionPanelVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(sectionPanelVO.hashId, sectionPanel_io, sectionPanelVO.visible);					
			
			// Actualizando modelo de datos
			var sectionPanelComponent:BtobComponent = new BtobComponent(sectionPanelVO, sectionPanel_io, sectionPanel_mc);
			BtobDataModel.getInstance().componentList.push(sectionPanelComponent);		
			
			// BOTTOM PANEL
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var bottomPanelVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_BOTTOM_PANEL_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var BottomPanel:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(bottomPanelVO.className) as Class;
			
			// Creo un objeto de tipo BottomPanel
			bottomPanel_mc = new BottomPanel();
			bottomPanel_mc.name = bottomPanelVO.instanceName;			
			
			// Creo un objeto de tipo InterfaceObject
			bottomPanel_io = new InterfaceObject(bottomPanel_mc,
											bottomPanelVO.className,
											bottomPanelVO.instanceName,
											bottomPanelVO.hashId,
											bottomPanelVO.changeSize,
											bottomPanelVO.percentageWidth,
											bottomPanelVO.percentageHeight,
											bottomPanelVO.changePositionX,
											bottomPanelVO.changePositionY,
											bottomPanelVO.percentageX,
											bottomPanelVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(bottomPanelVO.hashId, bottomPanel_io, bottomPanelVO.visible);
			
			// Actualizando modelo de datos
			var bottomPanelComponent:BtobComponent = new BtobComponent(bottomPanelVO, bottomPanel_io, bottomPanel_mc);
			BtobDataModel.getInstance().componentList.push(bottomPanelComponent);			
			
			// INFO PANEL
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var infoPanelVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_INFO_PANEL_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var InfoPanel:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(infoPanelVO.className) as Class;
			
			// Creo un objeto de tipo InfoPanel
			infoPanel_mc = new InfoPanel();
			infoPanel_mc.name = infoPanelVO.instanceName;	
			
			// Configurando detectores de eventos de los botones de las redes sociales de Btob
			(infoPanel_mc.facebook_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);
			(infoPanel_mc.youtube_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);
			(infoPanel_mc.twitter_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);
			(infoPanel_mc.blog_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);			
			(infoPanel_mc.mailTo_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);
			(infoPanel_mc.googleMap_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onInfoPanelSocialButtonClick);
			
			// Sonido
			_sound_mc = infoPanel_mc.sound_mc as MovieClip;
			(infoPanel_mc.sound_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onSoundButtonClick);
			
			// Creo un objeto de tipo InterfaceObject
			infoPanel_io = new InterfaceObject(infoPanel_mc,
				infoPanelVO.className,
				infoPanelVO.instanceName,
				infoPanelVO.hashId,
				infoPanelVO.changeSize,
				infoPanelVO.percentageWidth,
				infoPanelVO.percentageHeight,
				infoPanelVO.changePositionX,
				infoPanelVO.changePositionY,
				infoPanelVO.percentageX,
				infoPanelVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(infoPanelVO.hashId, infoPanel_io, infoPanelVO.visible);
			
			// Actualizando modelo de datos
			var infoPanelComponent:BtobComponent = new BtobComponent(infoPanelVO, infoPanel_io, infoPanel_mc);
			BtobDataModel.getInstance().componentList.push(infoPanelComponent);
			
			// SOUND
	
			// Recuperando primer sonido de la lista
			var soundVO:SoundVO = BtobDataModel.getInstance().settings.soundList[0] as SoundVO;
			
			// Creando peticion URL para la carga del sonido
			var soundURLRequest:URLRequest = new URLRequest(soundVO.url);
			
			// Ejecutando carga del sonido y configurando su channel
			_sound.load(soundURLRequest);             
			_soundChannel = _sound.play(0, int.MAX_VALUE);
			_isSoundPlaying = true;
			
			// Configurando detectores de eventos
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onErrorSoundHandler);
			_sound.addEventListener(Event.COMPLETE, onLoadCompleteSoundHandler);

			// MODAL PANEL
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var modalPanelVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_MODAL_PANEL_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var ModalPanel:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(modalPanelVO.className) as Class;
			
			// Creo un objeto de tipo ModalPanel
			modalPanel_mc = new ModalPanel();
			modalPanel_mc.name = modalPanelVO.instanceName;
			(modalPanel_mc.btn as SimpleButton).useHandCursor = false;
			(modalPanel_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onModalPanelButtonClickHandler);
			modalPanel_mc.visible = false;
			
			// Creo un objeto de tipo InterfaceObject
			modalPanel_io = new InterfaceObject(modalPanel_mc,
				modalPanelVO.className,
				modalPanelVO.instanceName,
				modalPanelVO.hashId,
				modalPanelVO.changeSize,
				modalPanelVO.percentageWidth,
				modalPanelVO.percentageHeight,
				modalPanelVO.changePositionX,
				modalPanelVO.changePositionY,
				modalPanelVO.percentageX,
				modalPanelVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(modalPanelVO.hashId, modalPanel_io, modalPanelVO.visible);
			
			
			// Actualizando modelo de datos
			var modalPanelComponent:BtobComponent = new BtobComponent(modalPanelVO, modalPanel_io, modalPanel_mc);
			BtobDataModel.getInstance().componentList.push(modalPanelComponent);
			
			// MODAL WINDOW
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var modalWindowVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_MODAL_WINDOW_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var ModalWindow:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(modalWindowVO.className) as Class;
			
			// Creo un objeto de tipo ModalWindow
			modalWindow_mc = new ModalWindow();
			modalWindow_mc.name = modalWindowVO.instanceName;	
			(modalWindow_mc.closeButton.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onModalWindowCloseButtonHandler);
			(modalWindow_mc.vote_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onVoteButtonClickHandler);
			modalWindow_mc.visible = false;
			
			// Creo un objeto de tipo InterfaceObject
			modalWindow_io = new InterfaceObject(modalWindow_mc,
												modalWindowVO.className,
												modalWindowVO.instanceName,
												modalWindowVO.hashId,
												modalWindowVO.changeSize,
												modalWindowVO.percentageWidth,
												modalWindowVO.percentageHeight,
												modalWindowVO.changePositionX,
												modalWindowVO.changePositionY,
												modalWindowVO.percentageX,
												modalWindowVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(modalWindowVO.hashId, modalWindow_io, modalWindowVO.visible);
			
			// Actualizando modelo de datos
			var modalWindowComponent:BtobComponent = new BtobComponent(modalWindowVO, modalWindow_io, modalWindow_mc);
			BtobDataModel.getInstance().componentList.push(modalWindowComponent);
			
			// HELLO WINDOW
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var helloWindowVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_HELLO_WINDOW_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var HelloWindow:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(helloWindowVO.className) as Class;
			
			// Creo un objeto de tipo HelloWindow
			helloWindow_mc = new HelloWindow();
			helloWindow_mc.name = helloWindowVO.instanceName;	
			(helloWindow_mc.closeButton.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onHelloWindowCloseButtonHandler);
			helloWindow_mc.visible = false;					
			
			// Creo un objeto de tipo InterfaceObject
			helloWindow_io = new InterfaceObject(helloWindow_mc,
				helloWindowVO.className,
				helloWindowVO.instanceName,
				helloWindowVO.hashId,
				helloWindowVO.changeSize,
				helloWindowVO.percentageWidth,
				helloWindowVO.percentageHeight,
				helloWindowVO.changePositionX,
				helloWindowVO.changePositionY,
				helloWindowVO.percentageX,
				helloWindowVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(helloWindowVO.hashId, helloWindow_io, helloWindowVO.visible);
			
			// Actualizando modelo de datos
			var helloWindowComponent:BtobComponent = new BtobComponent(helloWindowVO, helloWindow_io, helloWindow_mc);
			BtobDataModel.getInstance().componentList.push(helloWindowComponent);
			
			// ERROR WINDOW
			
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var errorWindowVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_ERROR_WINDOW_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var ErrorWindow:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(errorWindowVO.className) as Class;
			
			// Creo un objeto de tipo ErrorWindow
			errorWindow_mc = new ErrorWindow();
			errorWindow_mc.name = errorWindowVO.instanceName;	
			(errorWindow_mc.closeButton.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onErrorWindowCloseButtonHandler);
			errorWindow_mc.visible = false;					
			
			// Creo un objeto de tipo InterfaceObject
			errorWindow_io = new InterfaceObject(errorWindow_mc,
				errorWindowVO.className,
				errorWindowVO.instanceName,
				errorWindowVO.hashId,
				errorWindowVO.changeSize,
				errorWindowVO.percentageWidth,
				errorWindowVO.percentageHeight,
				errorWindowVO.changePositionX,
				errorWindowVO.changePositionY,
				errorWindowVO.percentageX,
				errorWindowVO.percentageY);						
			
			// Agregando objeto al escenario
			StageManager.getInstance().addObject(errorWindowVO.hashId, errorWindow_io, errorWindowVO.visible);
			
			// Actualizando modelo de datos
			var errorWindowComponent:BtobComponent = new BtobComponent(errorWindowVO, errorWindow_io, errorWindow_mc);
			BtobDataModel.getInstance().componentList.push(errorWindowComponent);
			
			// LOADER (cambio de nivel de visualizacion)
			
			// Cambio de nivel de visualizacion de BtobLoader para que este en la capa maxima de la lista de visualizacion
			var loaderVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_LOADER_HASH);
			var io:InterfaceObject = StageManager.getInstance().removeObject(loaderVO.hashId);					
			
			// Actualizando refenrecias al loader
			loader_io = io;
			loader_mc = io.interactiveObject as MovieClip;	
			
			// Adicionando al escenario
			StageManager.getInstance().addObject(loaderVO.hashId, loader_io, loaderVO.visible);
			
			// CARGANDO SECCION HOME
			
			// Recupero el swf cargado (HOME)
			var home_mc:MovieClip = _bulkLoader.getMovieClip(SECTION_HOME);
			var homeVO:SectionVO = BtobDataModel.getInstance().settings.getSectionByName(SECTION_HOME);
			_homeSectionController.sectionVO = homeVO;
			addSectionControllerToList(_homeSectionController);
			updateStatusLoadedSection(homeVO.id, true);
			updateSectionController(_homeSectionController);
			
			// Pasandole el homeMovie (Movieclip) a la clase controladora
			_homeSectionController.sectionMovie = home_mc;
			
			// Actualizando seccion actual
			activeSection_mc = home_mc;
			
			// Agregando SWF cargado al Movieclip que representa la seccion de contenidos					
			this.addInfoToSectionPanel(home_mc);
			
			// IMAGENES SECTION HOME
			
			// Cargando imagenes de la seccion home (visor de imagenes)			
			for(var i:uint = 0; i < BtobDataModel.getInstance().settings.greatVOList.length; i++)
			{
				// Recuperando objeto de datos
				var greatVO:GreatVO = BtobDataModel.getInstance().settings.greatVOList[i] as GreatVO;							
				
				// Adicionando objeto de datos a la lista de la clase controladora de la seccion (HomeSectionController)
				_homeSectionController.addGreatVO(greatVO); 
				
				// Verificando tipo de contenido
				if(greatVO.typeThumb == TableDataManager.IMAGE_TYPE)
				{
					// Inicializando contenedor
					var imageContainer_sp:Sprite = new Sprite();
					
					// Configurando contenedor de la imagen
					imageContainer_sp.visible = false;	
					
					// Recuperando imagen cargada por el gestor de descargas multiples
					var img:Bitmap = _bulkLoader.getBitmap(this.urlServerPath + greatVO.urlThumb);
					
					// Adicionando la imagen al contenedor de imagen
					imageContainer_sp.addChild(img);	
					
					// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
					_homeSectionController.addImageContainer(imageContainer_sp);
					
					// Adicionando la imagen al contenedor de imagen
					_homeSectionController.sectionMovie.homeViewer_mc.loaderImage_mc.addChild(imageContainer_sp);										
				}
				else if(greatVO.typeThumb == TableDataManager.VIDEO_TYPE)
				{
					// Inicializando contenedor
					var videoContainer_sp:Sprite = new Sprite();
					
					// Configurando contenedor de la imagen
					videoContainer_sp.visible = false;	

					// Adicionando objeto de datos al destacado
					greatVO.youtubeObject = new YouTubeObject(greatVO.id, new Loader(), new Object(), videoContainer_sp);
					
					// Adicionando los contenedores de imagenes a las listas de la clase HomeSectionController, para que puedan ser manejados por ella
					_homeSectionController.addImageContainer(videoContainer_sp);
					
					// Adicionando la imagen al contenedor de imagen
					_homeSectionController.sectionMovie.homeViewer_mc.loaderImage_mc.addChild(videoContainer_sp);	
				}							
			}
			
			// Actualizando background y imagenes de destacados
			_homeSectionController.updateHomeInfo();
		}

		public function onBulkElementProgressHandler(evt:BulkProgressEvent):void 
		{
			trace("onBulkElementProgressHandler: name=" + evt.target + " bytesLoaded=" + evt.bytesLoaded + " bytesTotal=" + evt.bytesTotal);
			var percent:uint = Math.floor((evt.totalPercentLoaded) * 100) ;	
			loader_mc.bar_mc.gotoAndStop(percent);
			if(evt.bytesLoaded == evt.bytesTotal)
				loader_mc.bar_mc.gotoAndStop(100);
		}									
		
		public function onXMLSettingsErrorHandler(evt:XMLServiceEvent):void {
			throw new Error(evt.message);
			this.showErrorWindow(evt.message);
		}
		
		public function onErrorHandler(evt:Event):void {
			this.showErrorWindow(evt.toString());
			throw new Error("\nERROR: " + evt);
		}
		
		/** 
		 * Generate a random number
		 * @return Random Number
		 * @error throws Error if low or high is not provided
		 */  
		public static function randomNumber(low:Number=NaN, high:Number=NaN):Number
		{
			var low:Number = low;
			var high:Number = high;
			
			if(isNaN(low)) {
				throw new Error("low must be defined");
			} 
			if(isNaN(high)) {
				throw new Error("high must be defined");
			}
			
			return Math.round(Math.random() * (high - low)) + low;
		}
		
		public function updateTooltips(socialVO:SocialVO, type:String):void
		{
			trace("SiteManager->updateTooltips()");
			
			// Verificando si existe el objeto de datos
			if(socialVO != null)
			{
				// Declarando tooltip
				var tooltip:MovieClip = null;							
				
				// Obteniendo tooltip correspondiente
				if(type == TOOLTIP_A)
					tooltip = infoPanel_mc.tooltipA_mc;
				else if(type == TOOLTIP_B)
					tooltip = infoPanel_mc.tooltipB_mc;
				else
					throw new Error("Tipo de tooltip desconocido");
				
				// Verificando si tiene campo de texto dinamico asociado
				//for(var i:uint = 0; (tooltip.text_mc as MovieClip).numChildren; i++)
				//	(tooltip.text_mc as MovieClip).removeChildAt(i);
				
				// Animando tooltips
				tooltip.scaleX = 0;
				tooltip.scaleY = 0;
				Tweener.addTween(tooltip, {scaleX:1, time:0.5, transition:"easeOutCubic"});
				Tweener.addTween(tooltip, {scaleY:1, time:0.5, transition:"easeOutCubic"});
	
				// Actualizando tooltip
				tooltip.image.gotoAndStop(socialVO.name);
				tooltip.text_dtxt.htmlText = socialVO.text;
								
				// Actualizando eventos del boton del tooltip
				var onTooltipButtonClick:Function =  function(){ navigateToURL(new URLRequest(socialVO.url)) };
				(tooltip.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onTooltipButtonClick);
			}
		}
		
		public function showTooltips():void 
		{
			infoPanel_mc.tooltipA_mc.visible = true;
			infoPanel_mc.tooltipB_mc.visible = true;
		}
		
		public function hideTooltips():void 
		{
			infoPanel_mc.tooltipA_mc.visible = false;
			infoPanel_mc.tooltipB_mc.visible = false;
		}
		
		private function onModalPanelButtonClickHandler(evt:MouseEvent):void
		{
			// Verificando si la ventana modal esta visible
			if(modalWindow_mc.visible)
				this.hideModalWindow();
			
			// Verificando si la ventana de formulario esta activa
			if(helloWindow_mc.visible)
				this.hideHelloWindow();
			
			// Verificando si la ventana de formulario esta activa
			if(errorWindow_mc.visible)
				this.hideErrorWindow();
		}
		
		// GRID TRANSITION FUNCTIONS
		
		public function executeBackgroundTransition():void
		{
			var bitmapdataTransitions:BitmapdataTransitions = new BitmapdataTransitions;
			bitmapdataTransitions.block(activeBackground_sp,"out",150, 150,"R",false,false,true,0.5,"random:2","easeOutSine");
			backgroundImagesContainer_sp.addChild(bitmapdataTransitions);
		}

		private function configGridTransition():void 
		{
			for(var i:uint = 0; i <= BLOCK_COUNT; i++) 	
				(gridTransition_mc["block_" + i] as MovieClip).alpha = 0;		
		}
		
		private function showTweenBlock(id:String):void 
		{
			var block:MovieClip = gridTransition_mc["block_" + id] as MovieClip;					
			Tweener.addTween(block, {alpha:0.5, time:0.05, transition:"easeOutCubic", delay:Math.random(), onComplete:hideTweenBlock, onCompleteParams:[id]});		
		}
		
		private function hideTweenBlock(id):void 
		{
			var block:MovieClip = gridTransition_mc["block_" + id] as MovieClip;
			var blockMask:MovieClip = maskGridOff_mc["block_" + id] as MovieClip;
			maskGridOff_mc.removeChild(blockMask);
			Tweener.addTween(block, {alpha:0, time:0.05, transition:"easeOutCubic", delay:Math.random()});		
		}
		
		public function playTransition(onContainer:Sprite, offContainer:Sprite):void
		{
			// Obteniendo movieclip grid de la seccion activa
			var grid_mc:MovieClip = activeSection_mc.grid_mc as MovieClip;
			trace("Section Grid MC: " + grid_mc.name);
			
			// Obteniendo punto de referencia relativo de la posicion del movieclip (GRID)
			var gridRelativePoint:Point = new Point(0, 0);
			trace("Section Grid relative coordinates:", gridRelativePoint);
			
			// Obteniendo punto de referencia absoluto de la posicion del movieclip (GRID)
			var gridAbsolutePoint:Point = grid_mc.localToGlobal(gridRelativePoint);
			trace("Section Grid absolute coordinates:", gridAbsolutePoint);

			// Asignando coordenandas globales a la cuadricula de transicion
			gridTransition_mc.x = gridAbsolutePoint.x;
			gridTransition_mc.y = gridAbsolutePoint.y;

			// Verificando si existen elementos para las mascaras
			if(maskGridOn_mc != null && maskGridOff_mc != null)
			{
				// Eliminando los elementos anteriores
				_stage.removeChild(maskGridOn_mc);
				_stage.removeChild(maskGridOff_mc);
				
				// Reiniciando objetos
				maskGridOn_mc = null;
				maskGridOff_mc = null;
				maskGridOn_io = null;
				maskGridOff_io = null;
			}
			
			// Creando movieclips para las mascaras de las transiciones
			maskGridOn_mc = new GridMask();
			maskGridOff_mc = new GridMask();
			
			// Invisibilizando mascaras
			maskGridOn_mc.visible = false;
			maskGridOff_mc.visible = false;			
			
			// Cambiando nombre de instancias de las mascaras
			maskGridOn_mc.name = "maskGridOff_mc";	
			maskGridOff_mc.name = "maskGridOff_mc";	
			
			// Adicionando mascaras al escenario
			_stage.addChild(maskGridOn_mc);
			_stage.addChild(maskGridOff_mc);

			// Posicionando mascaras
			maskGridOn_mc.x = gridAbsolutePoint.x;			
			maskGridOn_mc.y = gridAbsolutePoint.y;
			maskGridOff_mc.x = gridAbsolutePoint.x;
			maskGridOff_mc.y = gridAbsolutePoint.y;
			
			// Adicionando mascaras a los contenedores
			onContainer.mask = maskGridOn_mc;
			offContainer.mask = maskGridOff_mc;			
				
			// Recorriendo bloques de la malla de transicion
			for(var i:uint = 0; i <= BLOCK_COUNT; i++) 
			{
				var id:String = (gridTransition_mc["block_" + i] as MovieClip).name.substr((gridTransition_mc["block_" + i] as MovieClip).name.indexOf("_") + 1);
				this.showTweenBlock(id);
			}
		}
		
		// *** END *** GRID TRANSITION FUNCTIONS
		
		// INFO PANEL FUNCTIONS
		
		public function onInfoPanelSocialButtonClick(evt:MouseEvent):void
		{
			// Obteniendo el identificador
			var socialID:String = (evt.target as SimpleButton).name.substr(0, (evt.target as SimpleButton).name.indexOf("_"));
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
				
				case "mailTo":
					url = "mailto:info@btob.es";
					break;
				
				case "googleMap":
					url = "http://maps.google.es/maps?f=q&source=s_q&hl=es&geocode=&q=btob+madrid&sll=43.580391,-2.636719&sspn=15.098892,33.815918&ie=UTF8&hq=btob&hnear=Madrid,+Comunidad+de+Madrid&ll=40.462883,-3.690205&spn=0.030986,0.066047&z=15&iwloc=A";
					break;
				
				default:
					throw new Error("SocialID desconocido: " + socialID);
			}
			
			navigateToURL(new URLRequest(url));
		}
		
		// *** END *** INFO PANEL FUNCTIONS
		
		// HELLO WINDOW FUNCTIONS
		
		private function onHelloWindowCloseButtonHandler(evt:MouseEvent):void		
		{
			// Cerrando ventana modal
			hideHelloWindow();
		}
		
		public function hideHelloWindow():void
		{
			trace("SiteManager->hideHelloWindow()");
			
			modalPanel_mc.visible = false;
			helloWindow_mc.visible = false;
			
			// Limpiando campos de la ventana
			helloWindow_mc.name_itxt.text = "";
			helloWindow_mc.email_itxt.text = "";
			helloWindow_mc.subject_itxt.text = "";
			helloWindow_mc.filePath_itxt.text = "";
			helloWindow_mc.msg_itxt.text = "";
			
			// Inisibilizando componentes
			helloWindow_mc.nameError_mc.visible = false;
			helloWindow_mc.emailError_mc.visible = false;
			helloWindow_mc.subjectError_mc.visible = false;
			helloWindow_mc.filePathError_mc.visible = false;
			helloWindow_mc.msgError_mc.visible = false;	
		}			
		
		public function showHelloWindow():void
		{
			trace("SiteManager->showHelloWindow()");
			
			// Visualizando componentes
			modalPanel_mc.visible = true;
			helloWindow_mc.visible = true;
			
			// Invisibilizando error components
			(helloWindow_mc.nameError_mc as MovieClip).visible = false;
			(helloWindow_mc.emailError_mc as MovieClip).visible = false;
			(helloWindow_mc.subjectError_mc as MovieClip).visible = false;
			(helloWindow_mc.filePathError_mc as MovieClip).visible = false;
			(helloWindow_mc.msgError_mc as MovieClip).visible = false;
			
			// Configurando clase que controla el envio de mensaje desde el formulario
			var contactFormAttachment:ContactFormAttachment = new ContactFormAttachment();
			contactFormAttachment.registerNameTextInput(helloWindow_mc.name_itxt, helloWindow_mc.nameError_mc);
			contactFormAttachment.registerEmailTextInput(helloWindow_mc.email_itxt, helloWindow_mc.emailError_mc);
			contactFormAttachment.registerSubjectTextInput(helloWindow_mc.subject_itxt, helloWindow_mc.subjectError_mc);
			contactFormAttachment.registerFilePathTextInput(helloWindow_mc.filePath_itxt, helloWindow_mc.filePathError_mc);
			contactFormAttachment.registerMessageTextArea(helloWindow_mc.msg_itxt, helloWindow_mc.msgError_mc);
			contactFormAttachment.registerSelectButton(helloWindow_mc.examButton.btn as SimpleButton);
			contactFormAttachment.registerSendButton(helloWindow_mc.sendButton.btn as SimpleButton);
		}
		
		// *** END *** HELLO WINDOW FUNCTIONS		
		
		
		// ERROR WINDOW FUNCTIONS
		
		private function onErrorWindowCloseButtonHandler(evt:MouseEvent):void		
		{
			// Cerrando ventana modal
			hideErrorWindow();
		}
		
		public function hideErrorWindow():void
		{
			trace("SiteManager->hideErrorWindow()");
			
			// Invisibilizando componentes
			modalPanel_mc.visible = false;
			errorWindow_mc.visible = false;
			
			// Limpiando campos de la ventana
			errorWindow_mc.errorMessage_txt.text = "";
		}
		
		public function showErrorWindow(errorMessage:String):void
		{
			trace("SiteManager->showErrorWindow()");
			
			// Visualizando componentes
			modalPanel_mc.visible = true;
			errorWindow_mc.visible = true;
			
			// Adicionando mensaje de error a la caja de texto
			errorWindow_mc.errorMessage_txt.text += "\n**************" + activeSectionController + "*********\n" + errorMessage;
		}
		
		// *** END *** ERROR WINDOW FUNCTIONS
					
		// MODAL WINDOW FUNCTIONS
		
		private function onVoteButtonClickHandler(evt:MouseEvent):void
		{
			trace("Caso referencia: " + this.activeCaseVOModalWindow.ref);
			trace("Caso votado: " + this.activeCaseVOModalWindow.isVoted);
			trace("Caso rating: " + this.activeCaseVOModalWindow.rating);					
			
			// Enviando variable al servicio PHP para aumentar votacion del caso
			var urlVars:URLVariables = new URLVariables();
			urlVars.ref = this.activeCaseVOModalWindow.ref

			// Opciones del servicio PHP
			var urlPHPServiceRequest:URLRequest = new URLRequest(URL_VOTE_CASE_PHP_SERVICE);
			urlPHPServiceRequest.method = URLRequestMethod.POST;
			urlPHPServiceRequest.data = urlVars;
			
			// Enviando datos al servicio
			var urlLoaderPHPService:URLLoader = new URLLoader();
			urlLoaderPHPService.load(urlPHPServiceRequest);
			urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendPHPServiceComplete);
			urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);
		}
	
		private function onSendPHPServiceComplete(evt:Event):void
		{
			// Recuperando respuesta del servicio PHP
			var isCaseVoted:Boolean = StringUtils.stringToBoolean(evt.target.data);
		
			// Verificando respuesta del servicio PHP
			if(isCaseVoted)
			{
				this.activeCaseVOModalWindow.rating++;
				(modalWindow_mc.countVote_dtxt as TextField).text = String(this.activeCaseVOModalWindow.rating);
			}
			else
			{
				this.showErrorWindow("Ya has votado antes por este caso");
			}			
		}
		
		private function onSendPHPServiceError(evt:Event):void
		{
			this.showErrorWindow("Respuesta del servicio PHP: " + evt.toString());
		}
		
		private function onModalWindowCloseButtonHandler(evt:MouseEvent):void
		{
			// Cerrando ventana modal
			hideModalWindow();
		}
		
		public function showModalWindow(caseVO:CaseVO):void
		{
			trace("SiteManager->showModalWindow()");
			
			// Actualizando caso activo para la ventana modal
			this.activeCaseVOModalWindow = caseVO;
			
			// Asignado titulo del caso a la ventana modal
			modalWindow_mc.title_dtxt.text = caseVO.title;
			
			// Rating del caso
			(modalWindow_mc.countVote_dtxt as TextField).text = String(caseVO.rating);
			
			// TODO: Si el caso ha sido votada anteriormente inhabilitar boton
			//(modalWindow_mc.vote_btn as SimpleButton).enabled = !this.activeCaseVOModalWindow.isVoted;
			
			// Asignando nuevo detector de eventos
			var onBlogButtonClickHandler:Function =  function(){ navigateToURL(new URLRequest(caseVO.urlPost)) };
			(modalWindow_mc.blog_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onBlogButtonClickHandler);					
			
			// Obteniendo contenedor de objetos media
			var modalWindowMediaContainer_mc:MovieClip = modalWindow_mc.mediaContainer_mc as MovieClip;
			trace(modalWindowMediaContainer_mc);	
			
			// Probando funcion que crear la barra de links
			this.builtModalWindowLinkBar(caseVO);

			// Si no existen elementos en la galeria de contenidos 
			if(caseVO.gallery.length == 0)
			{
				// Error, debe existir al menos un elemento en la galeria del caso
				throw new Error("Debe existir al menos un elemento en la galeria de cada caso.");
			}
			else
			{
				// Si tiene un solo elemento, invisivilizar todos los elementos de navegacion
				(modalWindow_mc.navigationContainer as MovieClip).visible = !(caseVO.gallery.length == 1);
				
				// Si tiene dos o tres elementos no mostrar los controles de navegacion
				(modalWindow_mc.navigationContainer.prev_btn as SimpleButton).visible = !(caseVO.gallery.length == 2 || caseVO.gallery.length == 3);
				(modalWindow_mc.navigationContainer.next_btn as SimpleButton).visible = !(caseVO.gallery.length == 2 || caseVO.gallery.length == 3);							
				
				// Si existe uno o mas elementos en la galeria
				var item0_mc:MovieClip = modalWindow_mc.navigationContainer.item_0;
				if(caseVO.gallery.length >= 1)
				{
					// Obteniendo primer elemento de la galeria
					var item0GalleryVO:ItemGalleryVO = caseVO.gallery[this.indexItem0ModalWindowNavigation] as ItemGalleryVO;
					
					// Realizando accion en dependencia del tipo de contenido
					if(item0GalleryVO.type == TableDataManager.IMAGE_TYPE)
					{
						// Adicionando imagen del primer elemento al contenedor de media principal de la ventana modal
						modalWindowMediaContainer_mc.addChild(item0GalleryVO.mediaContainer);
						
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (imagen)
						item0_mc.mediaContainer.addChild((caseVO.gallery[this.indexItem0ModalWindowNavigation] as ItemGalleryVO).thumbContainer);
						
						// Invisibilizando loader de cada del componente
						(item0_mc.loader_mc as MovieClip).visible = false;
					}
					else if(item0GalleryVO.type == TableDataManager.VIDEO_TYPE)
					{											
						// YOUTUBE PLAYER THUMB 
						
						// Obteniendo objeto de datos correspondiente
						var youtubeObject0:YouTubeObject = _youtubeObjectList[0] as YouTubeObject;
						
						// Actuazalindo contenedor de elementos media para el primer item de la galeria
						youtubeObject0.container = item0_mc.mediaContainer;
						
						// Actualizando componente en el objeto de datos
						youtubeObject0.item_mc = item0_mc;
						
						// Actualizando itemGalleryObject del caso en cuestion
						youtubeObject0.itemGalleryVO = caseVO.gallery[this.indexItem0ModalWindowNavigation] as ItemGalleryVO;
						
						// Haciendo visible el loader de cada del componente
						(item0_mc.loader_mc as MovieClip).visible = true;
						
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
						this.loadYouTubeVideoPlayer(youtubeObject0.id);
						
						// YOUTUBE PLAYER PRINCIPAL
						
						// Actualizando contenido del contenedor principal
						this.updateVideoMediaContainerModalWindow(youtubeObject0.itemGalleryVO.url);
					}
					
					// Adicionando descripcion del caso seleccionado 
					(modalWindow_mc.descriptionContainer as MovieClip).description_dtxt.text = caseVO.description;
					
					// Adicionando detector de eventos para el boton del item (componente)
					(item0_mc.button_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onClickButtonItemGalleryHandler);									
				} 
				else { item0_mc.visible = false; }
				
				// Si existe dos o mas elementos en la galeria
				var item1_mc:MovieClip = modalWindow_mc.navigationContainer.item_1;
				if(caseVO.gallery.length >= 2)
				{
					// Obteniendo primer elemento de la galeria
					var item1GalleryVO:ItemGalleryVO = caseVO.gallery[this.indexItem1ModalWindowNavigation] as ItemGalleryVO;
					
					// Realizando accion en dependencia del tipo de contenido
					if(item1GalleryVO.type == TableDataManager.IMAGE_TYPE)
					{
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (imagen)
						item1_mc.mediaContainer.addChild((caseVO.gallery[this.indexItem1ModalWindowNavigation] as ItemGalleryVO).thumbContainer);
						
						// Invisibilizando loader de cada del componente
						(item1_mc.loader_mc as MovieClip).visible = false;
					}
					else if(item1GalleryVO.type == TableDataManager.VIDEO_TYPE)
					{
						// Obteniendo objeto de datos correspondiente
						var youtubeObject1:YouTubeObject = _youtubeObjectList[1] as YouTubeObject;
						
						// Actuazalindo contenedor de elementos media para el primer item de la galeria
						youtubeObject1.container = item1_mc.mediaContainer;
						
						// Actualizando componente en el objeto de datos
						youtubeObject1.item_mc = item1_mc;
						
						// Actualizando itemGalleryObject del caso en cuestion
						youtubeObject1.itemGalleryVO = caseVO.gallery[this.indexItem1ModalWindowNavigation] as ItemGalleryVO;
						
						// Haciendo visible el loader de cada del componente
						(item1_mc.loader_mc as MovieClip).visible = true;
						
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
						this.loadYouTubeVideoPlayer(youtubeObject1.id);
					}
					
					// Adicionando detector de eventos para el boton del item (componente)
					(item1_mc.button_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onClickButtonItemGalleryHandler);
				}
				else { item1_mc.visible = false; }
				
				// Si existen tres o mas elementos, se muestran las miniaturas de los tres primeros y los demas se muestran a traves de la navegacion circular
				var item2_mc:MovieClip = modalWindow_mc.navigationContainer.item_2;
				if(caseVO.gallery.length >= 3)
				{
					// Adicionando detectores de eventos de los botones de la navegacion circular
					(modalWindow_mc.navigationContainer.prev_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onClickButtonNavigationHandler);
					(modalWindow_mc.navigationContainer.next_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onClickButtonNavigationHandler);
					this.isAddedHandlersToModalWindowNavigationButtons = true;
					
					// Obteniendo primer elemento de la galeria
					var item2GalleryVO:ItemGalleryVO = caseVO.gallery[this.indexItem2ModalWindowNavigation] as ItemGalleryVO;
					
					// Realizando accion en dependencia del tipo de contenido
					if(item2GalleryVO.type == TableDataManager.IMAGE_TYPE)
					{
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (imagen)
						item2_mc.mediaContainer.addChild((caseVO.gallery[this.indexItem2ModalWindowNavigation] as ItemGalleryVO).thumbContainer);
						
						// Invisibilizando loader de cada del componente
						(item2_mc.loader_mc as MovieClip).visible = false;
					}
					else if(item2GalleryVO.type == TableDataManager.VIDEO_TYPE)
					{
						// Obteniendo objeto de datos correspondiente
						var youtubeObject2:YouTubeObject = _youtubeObjectList[2] as YouTubeObject;
						
						// Actuazalindo contenedor de elementos media para el primer item de la galeria
						youtubeObject2.container = item2_mc.mediaContainer;
						
						// Actualizando componente en el objeto de datos
						youtubeObject2.item_mc = item2_mc;
						
						// Actualizando itemGalleryObject del caso en cuestion
						youtubeObject2.itemGalleryVO = caseVO.gallery[this.indexItem2ModalWindowNavigation] as ItemGalleryVO;
						
						// Haciendo visible el loader de cada del componente
						(item2_mc.loader_mc as MovieClip).visible = true;
						
						// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
						this.loadYouTubeVideoPlayer(youtubeObject2.id);
					}
					
					// Adicionando detector de eventos para el boton del item (componente)
					(item2_mc.button_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onClickButtonItemGalleryHandler);
				}
				else { item2_mc.visible = false; }
			}
			
			// Visualizando componentes
			modalPanel_mc.visible = true;
			modalWindow_mc.visible = true;
		}
		
		public function hideModalWindow():void
		{
			trace("SiteManager->hideModalWindow()");
			
			// Invisibilizando componentes
			modalPanel_mc.visible = false;
			modalWindow_mc.visible = false;
			
			// Obteniendo contenedor de objetos media
			var modalWindowMediaContainer_mc:MovieClip = modalWindow_mc.mediaContainer_mc as MovieClip;
			
			// Deteniendo reproduccion de VIDEO en el contenedor principal
			if(_mainYoutubeVideoPlayer != null)
				_mainYoutubeVideoPlayer.stopVideo();
			
			// Poniendo sonido en el estado actual 
			SiteManager.getInstance().onSoundButtonClick(null, true);
			
			// Eliminando contenidos anteriores 
			this.clearModalWindowContents();
			
			// Eliminando detectores de eventos de los botones de la navegacion circular
			if(isAddedHandlersToModalWindowNavigationButtons == true) {
				(modalWindow_mc.navigationContainer.prev_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onClickButtonNavigationHandler);
				(modalWindow_mc.navigationContainer.next_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onClickButtonNavigationHandler);
				this.isAddedHandlersToModalWindowNavigationButtons = false;
			}
			
			// Reiniciando visibilidad de los elementos 
			(modalWindow_mc.navigationContainer.item_0 as MovieClip).visible = true;
			(modalWindow_mc.navigationContainer.item_1 as MovieClip).visible = true;
			(modalWindow_mc.navigationContainer.item_2 as MovieClip).visible = true;
			
			// Reiniciando indices de la navegacion
			this.activeCaseVOModalWindow = null;
			this.indexItem0ModalWindowNavigation = 0;
			this.indexItem1ModalWindowNavigation = 1;
			this.indexItem2ModalWindowNavigation = 2;
			
			// Si hay algun caso activado desde otra seccion directamente, vuelve a la seccion anterior
			if(ClientSectionController.getInstance().activeClientSubdestinationID != -1)
				ClientSectionController.getInstance().backToSectionBeforeModalWindow();
		}
		
		private function onClickButtonItemGalleryHandler(evt:MouseEvent):void
		{
			trace("SiteManager->onClickButtonItemGalleryHandler()");	
			
			// Obteniendo nombre del componente clickado
			var itemName:String = ((evt.target as SimpleButton).parent as MovieClip).name;
			
			// Obteniendo identificador del componente clickado
			var itemID:uint = uint(itemName.substr(itemName.indexOf("_") + 1));									
			
			// Realizando accion en dependencia del componente clickado
			var itemGalleryVO:ItemGalleryVO = null;
			var itemMediaContainer_sp:Sprite = null;
			var indexClicked:uint;
			switch(itemID)
			{
				case 0:
					indexClicked = this.indexItem0ModalWindowNavigation;
					break;
				
				case 1:
					indexClicked = this.indexItem1ModalWindowNavigation;
					break;
				
				case 2:
					indexClicked = this.indexItem2ModalWindowNavigation;
					break;
				
				default:
					throw new Error("Identificador de componente desconocido.");
			}			
			
			// Obteniendo contenedor de objetos media
			var modalWindowMediaContainer_mc:MovieClip = modalWindow_mc.mediaContainer_mc as MovieClip;
			
			// Poniendo sonido en el estado actual 
			SiteManager.getInstance().onSoundButtonClick(null, true);
			
			// Deteniendo reproduccion de VIDEO en el contenedor principal
			if(_mainYoutubeVideoPlayer != null)
				_mainYoutubeVideoPlayer.stopVideo();
			
			// Eliminando contenido anterior 				
			modalWindowMediaContainer_mc.removeChildAt(0);
			trace("modalWindowMediaContainer_mc.numChildren [remove]: " + modalWindowMediaContainer_mc.numChildren);
			
			// Obteniendo objeto de datos del componente correspondiente
			itemGalleryVO = this.activeCaseVOModalWindow.gallery[indexClicked] as ItemGalleryVO;
			itemMediaContainer_sp = itemGalleryVO.mediaContainer;
			
			// Si el elemento seleccionado es de tipo IMAGE
			if(itemGalleryVO.type == TableDataManager.IMAGE_TYPE)
			{
				// Adicionando contenedor de imagen al contenedor de objetos media
				modalWindowMediaContainer_mc.addChild(itemMediaContainer_sp);
			}
			else if(itemGalleryVO.type == TableDataManager.VIDEO_TYPE)
			{
				// YOUTUBE PLAYER PRINCIPAL
				
				// Obteniendo movieclip del loader asociado al contenedor principal de la ventana modal
				var mainLoader_mc:MovieClip = modalWindow_mc.mainLoader_mc as MovieClip;
				trace("mainLoader_mc: " + mainLoader_mc);
				
				// Invisivilizando video loader
				mainLoader_mc.visible = true;
				
				// Actualizando contenido del contenedor principal
				this.updateVideoMediaContainerModalWindow(itemGalleryVO.url);
			}
			
			// Adicionando descripcion del elemento 
			(modalWindow_mc.descriptionContainer as MovieClip).description_dtxt.text = this.activeCaseVOModalWindow.description;
		}
		
		private function onClickButtonNavigationHandler(evt:MouseEvent):void
		{
			trace("SiteManager->onClickButtonNavigationHandler()");
			
			// Obteniendo identificador del boton clickado
			var idButton:String = (evt.target as SimpleButton).name.substr(0, (evt.target as SimpleButton).name.indexOf("_"));
			
			// Realizando accion en dependencia del identificador del boton clickado
			switch(idButton)
			{
				case PREV:
					
					// Incrementando indices de navegacion
					this.indexItem0ModalWindowNavigation = Math.abs(this.indexItem0ModalWindowNavigation + (activeCaseVOModalWindow.gallery.length - 1));
					this.indexItem1ModalWindowNavigation = Math.abs(this.indexItem1ModalWindowNavigation + (activeCaseVOModalWindow.gallery.length - 1));
					this.indexItem2ModalWindowNavigation = Math.abs(this.indexItem2ModalWindowNavigation + (activeCaseVOModalWindow.gallery.length - 1));
					
					// Ajustando indices si se salen de rango
					if(indexItem0ModalWindowNavigation >= 5)
						this.indexItem0ModalWindowNavigation %= activeCaseVOModalWindow.gallery.length;
					
					if(indexItem1ModalWindowNavigation >= 5)
						this.indexItem1ModalWindowNavigation %= activeCaseVOModalWindow.gallery.length;
					
					if(indexItem2ModalWindowNavigation >= 5)
						this.indexItem2ModalWindowNavigation %= activeCaseVOModalWindow.gallery.length;
					
					break;
				
				case NEXT:
					
					// Incrementando indices de navegacion
					this.indexItem0ModalWindowNavigation = Math.abs(this.indexItem0ModalWindowNavigation + 1) % activeCaseVOModalWindow.gallery.length;
					this.indexItem1ModalWindowNavigation = Math.abs(this.indexItem1ModalWindowNavigation + 1) % activeCaseVOModalWindow.gallery.length;
					this.indexItem2ModalWindowNavigation = Math.abs(this.indexItem2ModalWindowNavigation + 1) % activeCaseVOModalWindow.gallery.length;
					
					break;
				
				default:
					throw new Error("Identificador de boton de navegacion desconocido.");
			}					
			
			// ACTUALIZANDO MINIATURAS 
			
			// Obteniendo los tres primeros items (componentes) de la galleria
			var item0_mc:MovieClip = modalWindow_mc.navigationContainer.item_0;
			var item1_mc:MovieClip = modalWindow_mc.navigationContainer.item_1;
			var item2_mc:MovieClip = modalWindow_mc.navigationContainer.item_2;
			
			// Eliminando contenidos anteriores de los items de la galeria
			(item0_mc.mediaContainer as MovieClip).removeChildAt(0);
			(item1_mc.mediaContainer as MovieClip).removeChildAt(0);
			(item2_mc.mediaContainer as MovieClip).removeChildAt(0);
			
			// Obteniendo objetos de datos asociados a cada elemento
			var item0GalleryVO:ItemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem0ModalWindowNavigation] as ItemGalleryVO;
			var item1GalleryVO:ItemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem1ModalWindowNavigation] as ItemGalleryVO;
			var item2GalleryVO:ItemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem2ModalWindowNavigation] as ItemGalleryVO;
			
			// Verificando tipo de contenido del primer elemento
			if(item0GalleryVO.type == TableDataManager.IMAGE_TYPE)
			{
				// Actualizando contenidos de la ventana modal del correspondiente elemento
				item0_mc.mediaContainer.addChild(item0GalleryVO.thumbContainer);				
			}
			else if(item0GalleryVO.type == TableDataManager.VIDEO_TYPE)
			{
				// Obteniendo objeto de datos correspondiente
				var youtubeObject0:YouTubeObject = _youtubeObjectList[0] as YouTubeObject;
				
				// Actuazalindo contenedor de elementos media para el primer item de la galeria
				youtubeObject0.container = item0_mc.mediaContainer;
				
				// Actualizando componente en el objeto de datos
				youtubeObject0.item_mc = item0_mc;
				
				// Actualizando itemGalleryObject del caso en cuestion
				youtubeObject0.itemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem0ModalWindowNavigation] as ItemGalleryVO;
				
				// Invisibilizando loader visual
				(youtubeObject0.item_mc.loader_mc as MovieClip).visible = true;
				
				// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
				this.loadYouTubeVideoPlayer(youtubeObject0.id);
			}
			
			// Verificando tipo de contenido del segundo elemento
			if(item1GalleryVO.type == TableDataManager.IMAGE_TYPE)
			{
				// Actualizando contenidos de la ventana modal del correspondiente elemento
				item1_mc.mediaContainer.addChild(item1GalleryVO.thumbContainer);
			}
			else if(item1GalleryVO.type == TableDataManager.VIDEO_TYPE)
			{
				// Obteniendo objeto de datos correspondiente
				var youtubeObject1:YouTubeObject = _youtubeObjectList[1] as YouTubeObject;
				
				// Actuazalindo contenedor de elementos media para el primer item de la galeria
				youtubeObject1.container = item1_mc.mediaContainer;
				
				// Actualizando componente en el objeto de datos
				youtubeObject1.item_mc = item1_mc;
				
				// Actualizando itemGalleryObject del caso en cuestion
				youtubeObject1.itemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem1ModalWindowNavigation] as ItemGalleryVO;
				
				// Invisibilizando loader visual
				(youtubeObject1.item_mc.loader_mc as MovieClip).visible = true;
				
				// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
				this.loadYouTubeVideoPlayer(youtubeObject1.id);
			}
			
			// Verificando tipo de contenido del tercer elemento
			if(item2GalleryVO.type == TableDataManager.IMAGE_TYPE)
			{
				// Actualizando contenidos de la ventana modal del correspondiente elemento		
				item2_mc.mediaContainer.addChild(item2GalleryVO.thumbContainer);
			}
			else if(item2GalleryVO.type == TableDataManager.VIDEO_TYPE)
			{
				// Obteniendo objeto de datos correspondiente
				var youtubeObject2:YouTubeObject = _youtubeObjectList[2] as YouTubeObject;
				
				// Actuazalindo contenedor de elementos media para el primer item de la galeria
				youtubeObject2.container = item2_mc.mediaContainer;
				
				// Actualizando componente en el objeto de datos
				youtubeObject2.item_mc = item2_mc;
				
				// Actualizando itemGalleryObject del caso en cuestion
				youtubeObject2.itemGalleryVO = this.activeCaseVOModalWindow.gallery[this.indexItem2ModalWindowNavigation] as ItemGalleryVO;
				
				// Invisibilizando loader visual
				(youtubeObject2.item_mc.loader_mc as MovieClip).visible = true;
				
				// Actualizando contenidos de la ventana modal con el primer elemento de la galeria (video)
				this.loadYouTubeVideoPlayer(youtubeObject2.id);
			}
		}
		
		private function loadYouTubeVideoPlayer(itemID:uint):void 
		{
			// Inicializando y configurando youtube objects en dependencia del ID del elemento de la galeria
			switch(itemID)
			{
				case 0:		// Item 0 de la galeria
										
					// Obteniendo primer elemento de la lista (_youtubeObject0)
					var youtubeObject0:YouTubeObject = _youtubeObjectList[itemID] as YouTubeObject;
					
					// Configurando elemento para una carga personalizada
					youtubeObject0.loader.contentLoaderInfo.addEventListener(Event.INIT, onItem0LoaderInit);
					youtubeObject0.loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
					
					break;
				
				case 1:		// Item 1 de la galeria
					
					// Obteniendo primer elemento de la lista (_youtubeObject0)
					var youtubeObject1:YouTubeObject = _youtubeObjectList[itemID] as YouTubeObject;
					
					// Configurando elemento para una carga personalizada
					youtubeObject1.loader.contentLoaderInfo.addEventListener(Event.INIT, onItem1LoaderInit);
					youtubeObject1.loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
					
					break;
				
				case 2:		// Item 2 de la galeria
					
					// Obteniendo primer elemento de la lista (_youtubeObject0)
					var youtubeObject2:YouTubeObject = _youtubeObjectList[itemID] as YouTubeObject;
					
					// Configurando elemento para una carga personalizada
					youtubeObject2.loader.contentLoaderInfo.addEventListener(Event.INIT, onItem2LoaderInit);
					youtubeObject2.loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
					
					break;
				
				default:
					throw new Error("ID de elemento de la galeria desconocido: " + itemID);
			}					
		}
		
		private function onItem0LoaderInit(evt:Event):void 
		{
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[0] as YouTubeObject;
			trace("Se ha cargado el player de youtube: " + youtubeObject.id);
			
			// Adicionando player cargado al contenedor del item de la galeria
			youtubeObject.container.addChild(youtubeObject.loader);
			
			// Configurando detectores de eventos para el player
			youtubeObject.loader.content.addEventListener("onReady", onItem0PlayerReady);
			youtubeObject.loader.content.addEventListener("onError", onPlayerError);
			youtubeObject.loader.content.addEventListener("onStateChange", onPlayerStateChange);
			youtubeObject.loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onItem1LoaderInit(evt:Event):void 
		{
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[1] as YouTubeObject;
			trace("Se ha cargado el player de youtube: " + youtubeObject.id);
			
			// Adicionando player cargado al contenedor del item de la galeria
			youtubeObject.container.addChild(youtubeObject.loader);
			
			// Configurando detectores de eventos para el player
			youtubeObject.loader.content.addEventListener("onReady", onItem1PlayerReady);
			youtubeObject.loader.content.addEventListener("onError", onPlayerError);
			youtubeObject.loader.content.addEventListener("onStateChange", onPlayerStateChange);
			youtubeObject.loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onItem2LoaderInit(evt:Event):void 
		{
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[2] as YouTubeObject;
			trace("Se ha cargado el player de youtube: " + youtubeObject.id);
			
			// Adicionando player cargado al contenedor del item de la galeria
			youtubeObject.container.addChild(youtubeObject.loader);
			
			// Configurando detectores de eventos para el player
			youtubeObject.loader.content.addEventListener("onReady", onItem2PlayerReady);
			youtubeObject.loader.content.addEventListener("onError", onPlayerError);
			youtubeObject.loader.content.addEventListener("onStateChange", onPlayerStateChange);
			youtubeObject.loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onItem0PlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[0] as YouTubeObject;
			
			// Invisibilizando loader visual
			(youtubeObject.item_mc.loader_mc as MovieClip).visible = false;
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			youtubeObject.videoPlayer = youtubeObject.loader.content;
			youtubeObject.videoPlayer.setSize(171, 114);
			
			// Cargar video segun ID de video youtube
			var url:String = youtubeObject.itemGalleryVO.thumb;
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			youtubeObject.videoPlayer.cueVideoById(videoID, 0);
		}
		
		private function onItem1PlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[1] as YouTubeObject;
			
			// Invisibilizando loader visual
			(youtubeObject.item_mc.loader_mc as MovieClip).visible = false;
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			youtubeObject.videoPlayer = youtubeObject.loader.content;
			youtubeObject.videoPlayer.setSize(171, 114);
			
			// Cargar video segun ID de video youtube
			var url:String = youtubeObject.itemGalleryVO.thumb;
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			youtubeObject.videoPlayer.cueVideoById(videoID, 0);
		}
		
		private function onItem2PlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Obteniendo youtube object del primer elemento de navegacion de la galeria
			var youtubeObject:YouTubeObject = _youtubeObjectList[2] as YouTubeObject;
			
			// Invisibilizando loader visual
			(youtubeObject.item_mc.loader_mc as MovieClip).visible = false;
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			youtubeObject.videoPlayer = youtubeObject.loader.content;
			youtubeObject.videoPlayer.setSize(171, 114);
			
			// Cargar video segun ID de video youtube
			var url:String = youtubeObject.itemGalleryVO.thumb;
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			youtubeObject.videoPlayer.cueVideoById(videoID, 0);
		}
		
		private function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
		
		private function updateVideoMediaContainerModalWindow(videoURL:String):void
		{
			// Actualizando URL del video que se cargara
			_mainYoutubeURL = videoURL;
			
			// Inicializando loader del player
			_mainYoutubeLoader = new Loader();
			_mainYoutubeLoader.contentLoaderInfo.addEventListener(Event.INIT, onMainVideoLoaderInit);
			_mainYoutubeLoader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		
		private function onMainVideoLoaderInit(event:Event):void 
		{
			// Obteniendo contenedor de objetos media de la ventana modal
			var modalWindowMediaContainer_mc:MovieClip = modalWindow_mc.mediaContainer_mc as MovieClip;
			
			// Eliminando contenidos cargados en el contenedor anteriormente
			for(var i:uint = 0; i < modalWindowMediaContainer_mc.numChildren; i++)
				modalWindowMediaContainer_mc.removeChildAt(i);
			
			modalWindowMediaContainer_mc.addChild(_mainYoutubeLoader);
			_mainYoutubeLoader.content.addEventListener("onReady", onMainVideoPlayerReady);
			_mainYoutubeLoader.content.addEventListener("onError", onMainVideoPlayerError);
			_mainYoutubeLoader.content.addEventListener("onStateChange", onMainVideoPlayerStateChange);
			_mainYoutubeLoader.content.addEventListener("onPlaybackQualityChange", onMainVideoPlaybackQualityChange);
		}
				
		private function onMainVideoPlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Asignando contenido al player (Object)
			_mainYoutubeVideoPlayer = _mainYoutubeLoader.content;
			_mainYoutubeVideoPlayer.setSize(861, 583);
			
			// Obteniendo movieclip del loader asociado al contenedor principal de la ventana modal
			var mainLoader_mc:MovieClip = modalWindow_mc.mainLoader_mc as MovieClip;
			trace("mainLoader_mc: " + mainLoader_mc);
			
			// Invisivilizando video loader
			mainLoader_mc.visible = false;
			
			// Cargar video segun ID de video youtube
			var url:String = _mainYoutubeURL;	
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			_mainYoutubeVideoPlayer.cueVideoById(videoID, 0);
		}
		
		private function onMainVideoPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onMainVideoPlayerStateChange(event:Event):void 
		{
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
			
			switch(Object(event).data)
			{
				case 0:		// Video detenido 
					SiteManager.getInstance().onSoundButtonClick(null, true);
					this.onMainVideoPlayerReady(null);
					break;
				
				case 1: 	// Video reproduciendo
					SiteManager.getInstance().onSoundButtonClick(null, false);
					break;
				
			}
		}
		
		private function onMainVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
		
		private function clearModalWindowContents():void
		{
			trace("SiteManager->clearModalWindowContents()");
			
			// Obteniendo contenedor de objetos media
			var modalWindowMediaContainer_mc:MovieClip = modalWindow_mc.mediaContainer_mc as MovieClip;
			
			// Eliminando contenidos anteriores del contenedor principal
			for(var i:uint = 0; i < modalWindowMediaContainer_mc.numChildren; i++)
				modalWindowMediaContainer_mc.removeChildAt(i);
			
			// Elimiando contenidos anteriores de los elementos de navegacion
			if((modalWindow_mc.navigationContainer.item_0.mediaContainer as MovieClip).numChildren > 0)
				(modalWindow_mc.navigationContainer.item_0.mediaContainer as MovieClip).removeChildAt(0);
			
			if((modalWindow_mc.navigationContainer.item_1.mediaContainer as MovieClip).numChildren > 0)
				(modalWindow_mc.navigationContainer.item_1.mediaContainer as MovieClip).removeChildAt(0);
			
			if((modalWindow_mc.navigationContainer.item_2.mediaContainer as MovieClip).numChildren > 0)
				(modalWindow_mc.navigationContainer.item_2.mediaContainer as MovieClip).removeChildAt(0);
			
			// Haciendo visibles loader de los elementos de la galeria
			(modalWindow_mc.navigationContainer.item_0.loader_mc as MovieClip).visible = true;
			(modalWindow_mc.navigationContainer.item_1.loader_mc as MovieClip).visible = true;
			(modalWindow_mc.navigationContainer.item_2.loader_mc as MovieClip).visible = true;
		}
		
		private function builtModalWindowLinkBar(caseVO:CaseVO):void
		{
			trace("SiteManager->builtModalWindowLinkBar()");	
						
			// Eliminando elementos anteriores
			//for(var j:uint = 0; j < (this.modalWindow_mc.descriptionContainer.linkBar as MovieClip).numChildren; j++)
				//(this.modalWindow_mc.descriptionContainer.linkBar as MovieClip).removeChildAt(j);
			
			var linkBar_mc = (this.modalWindow_mc.descriptionContainer.linkBar as MovieClip);
			var j:int = linkBar_mc.numChildren;
			while( j-- )
				linkBar_mc.removeChildAt(j);
			
			trace("linkBar numChildren: " + linkBar_mc.numChildren);
						
			// Creo un objeto de tipo Class para luego crear objetos del tipo del className cargado por xml
			var linkButtonVO:ComponentVO = BtobDataModel.getInstance().settings.getComponentByHash(COMPONENT_LINK_BUTTON_HASH);
			
			// Creo una clase correspondiente al objeto en la biblioteca del swf
			var LinkButton:Class = manager_mc.loaderInfo.applicationDomain.getDefinition(linkButtonVO.className) as Class;
			
			// Construyendo LinkBar
			var totalWidthButtons:Number = 0;
			
			for(var i:uint = 0; i < caseVO.linkList.length; i++)
			{							
				// Creo un objeto de tipo LinkButton
				var linkButton_mc = new LinkButton();
				linkButton_mc.id = i;
				linkButton_mc.urlLink = (caseVO.linkList[i] as LinkVO).url;
				linkButton_mc.name = "linkButton" + i + "_btn";
				linkButton_mc.x = (i != 0) ? (PADDING_BUTTON * (i + 1)) + totalWidthButtons : PADDING_BUTTON * (i + 1);					
				(linkButton_mc.label_dtxt as TextField).x = PADDING_TEXT;	
				(linkButton_mc.label_dtxt as TextField).autoSize = TextFieldAutoSize.LEFT;								
				(linkButton_mc.label_dtxt as TextField).text = (caseVO.linkList[i] as LinkVO).text;				
				(linkButton_mc.btn as SimpleButton).width = (linkButton_mc.label_dtxt as TextField).width;																		
				(linkButton_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onLinkButtonClickHandler);
				totalWidthButtons += linkButton_mc.width;
				
				// Adicionando elemento visual al la barra de links de la ventana modal para el caso en cuestion				
				(this.modalWindow_mc.descriptionContainer.linkBar as MovieClip).addChild(linkButton_mc);				
			}	
		}
		
		private function onLinkButtonClickHandler(evt:MouseEvent):void			
		{
			var linkButton_mc:MovieClip = evt.target.parent as MovieClip;
			navigateToURL(new URLRequest(linkButton_mc.urlLink))
		}
		
		private function drawOval(mc:MovieClip, mw:Number, mh:Number, r:Number, fillColor:uint, alphaAmount:Number) 
		{			
			mc.graphics.clear();
			mc.graphics.beginFill(fillColor,alphaAmount);
			mc.graphics.moveTo(r,0);
			mc.graphics.lineTo(mw-r,0);
			mc.graphics.curveTo(mw,0,mw,r);
			mc.graphics.lineTo(mw,mh-r);
			mc.graphics.curveTo(mw,mh,mw-r,mh);
			mc.graphics.lineTo(r,mh);
			mc.graphics.curveTo(0,mh,0,mh-r)
			mc.graphics.lineTo(0,r);
			mc.graphics.curveTo(0,0,r,0);
			mc.graphics.endFill();
		}

		// *** END *** MODAL WINDOW FUNCTIONS	
		
		
		// SOUND FUNCTIONS	
		
		private function onLoadCompleteSoundHandler(evt:Event):void {
			//var soundVO:SoundVO = BtobDataModel.getInstance().settings.soundList[0] as SoundVO;
			//showErrorWindow("Ha cargado el sonido: " + soundVO.url);
		}	
		
		private function onErrorSoundHandler(errorEvent:IOErrorEvent):void {
			showErrorWindow("El sonido no ha podido cargarse: " + errorEvent.text);
		}
		
		public function onSoundButtonClick(evt:MouseEvent, soundOn:Boolean = false):void
		{
			trace("SiteManager->onSoundButtonClick()");
			
			// Declarando variable auxiliar
			var sound_mc:MovieClip = null;
			
			// Si el usuario ha apagado el sonido, entonces activar la variable de control de sonido
			if(evt != null)
			{
				// Actualizando variable para el control de accion del usuario
				_isUserSoundOff = !_isUserSoundOff;
				
				// Reproduciendo o deteniendo sonido
				_isSoundPlaying = !_isSoundPlaying;						
			}
			else
			{
				if(soundOn == true) {			// Encendido del sonido, accion automatica ejecutada por reproduccion de video
					if(isSoundPlaying == true) return;
					_isSoundPlaying = !_isUserSoundOff;		
				}
				else if(soundOn == false)	// Apagado del sonido, accion automatica ejecutada por reproduccion de video
					_isSoundPlaying = false;
			}
			
			// Obteniendo acceso al padre del boton, movieclip que contiene las barras
			sound_mc = _sound_mc;
			
			// Verificando estado del sonido
			if(_isSoundPlaying)
			{
				// Animacion de las barras a ON
				(sound_mc.bar_1 as MovieClip).gotoAndPlay(0);
				(sound_mc.bar_2 as MovieClip).gotoAndPlay(0);
				(sound_mc.bar_3 as MovieClip).gotoAndPlay(0);
				(sound_mc.bar_4 as MovieClip).gotoAndPlay(0);
				(sound_mc.bar_5 as MovieClip).gotoAndPlay(0);
				
				// Reproduciendo sonido
				_soundChannel = _sound.play(0, int.MAX_VALUE);
			}
			else
			{
				// Animacion de las barras a OFF
				(sound_mc.bar_1 as MovieClip).gotoAndPlay("off");
				(sound_mc.bar_2 as MovieClip).gotoAndPlay("off");
				(sound_mc.bar_3 as MovieClip).gotoAndPlay("off");
				(sound_mc.bar_4 as MovieClip).gotoAndPlay("off");
				(sound_mc.bar_5 as MovieClip).gotoAndPlay("off");
				
				// Deteniendo sonido
				_soundChannel.stop();
			}
		}
		
		// *** END *** SOUND FUNCTIONS	
	}
}