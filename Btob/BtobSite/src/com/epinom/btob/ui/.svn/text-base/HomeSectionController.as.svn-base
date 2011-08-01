package com.epinom.btob.ui
{
	import com.digitalsurgeons.loading.BulkLoader;
	import com.digitalsurgeons.loading.BulkProgressEvent;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.ExperiencesVO;
	import com.epinom.btob.data.GreatVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.SocialVO;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.LoaderManager;
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.utils.Timer;

	public class HomeSectionController implements ISectionController
	{
		private static var _instance:HomeSectionController = null;
		private static var _allowInstantiation:Boolean;
		
		public static const SECTION_NAME:String = "home";		
		public static const HOME_SECTION_CONTROLLER:String = "HomeSectionController";
		private static const UPDATE_TIME_TOOLTIPS:uint = 10 * 1000;
		private static const UPDATE_TIME_GREATS:uint = 20 * 1000;
		
		private var _sectionVO:SectionVO;
		private var _sectionMovie:MovieClip;
		private var _activeGreatId:uint;
		private var _activeBackgroundImageContainer:Sprite;
		private var _activeImageContainer:Sprite;
		private var _backgroundImageContainerList:Array;
		private var _imageContainerList:Array;
		private var _greatVOList:Array;
		private var _activeTooltipAIndex:uint;
		private var _activeTooltipBIndex:uint;
		private var _timerTooltipA:Timer;
		private var _timerTooltipB:Timer;
		private var _timerGreats:Timer;	
		
		public var isTransitionCanceled:Boolean;
		
		public function HomeSectionController()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use SiteManager.getInstance() instead of new.");
			} else {		
				
				// Agregando cualquier dominio para temas de seguridad de Flash Player
				Security.allowInsecureDomain("*");
				Security.allowDomain("*");
				
				_sectionMovie = null;
				_activeGreatId = 0;
				_activeBackgroundImageContainer = null;
				_activeImageContainer = null;
				_backgroundImageContainerList = new Array();
				_imageContainerList = new Array();	
				_greatVOList = new Array();	
				
				// Determina si la seccion HOME esta esperando que la seccion EXPERIENCES cargue sus datos de configuracion
				isTransitionCanceled = false;				
				
				// Timers
				_activeTooltipAIndex = 0;	// Indices pares
				_activeTooltipBIndex = 1;	// Indices impares
				_timerTooltipA = new Timer(UPDATE_TIME_TOOLTIPS);
				_timerTooltipB = new Timer(UPDATE_TIME_TOOLTIPS);
				_timerTooltipA.addEventListener(TimerEvent.TIMER, onTimerTooltipA);
				_timerTooltipB.addEventListener(TimerEvent.TIMER, onTimerTooltipB);
				_timerGreats = new Timer(UPDATE_TIME_GREATS);
				_timerGreats.addEventListener(TimerEvent.TIMER, onTimerGreats);										
			}
		}
		
		public static function getInstance():HomeSectionController 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new HomeSectionController();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get sectionVO():SectionVO { return _sectionVO; }
		public function set sectionVO(value:SectionVO):void { _sectionVO = value; }	
		
		public function get sectionMovie():MovieClip { return _sectionMovie; }
		public function set sectionMovie(value:MovieClip):void { 
			_sectionMovie = value;
			_sectionMovie.addEventListener(TableDataManager.SECTION_EVENT, onHomeEventHandler, false, 0, true);
			_sectionMovie.addEventListener(TableDataManager.HELLO_WINDOW, onHelloClickHandler, false, 0, true);
			_sectionMovie.addEventListener(TableDataManager.SHOW_CLIENT_DETAILS, onGreatLinkButtonClickHandler, false, 0, true);
			_sectionMovie.addEventListener(TableDataManager.VIEW_CASE_IN_BLOG, onGreatPostButtonClickHandler, false, 0, true);
		}
		
		public function get activeBackgroundImageContainer():Sprite { return _activeBackgroundImageContainer; }
		public function set activeBackgroundImageContainer(value:Sprite):void { _activeBackgroundImageContainer = value; }
		
		public function buildSection(vo:SectionVO, idClient:String = null, idCase:String = null):void {};
		
		public function onBulkSectionLoadedHandler(evt:Event):void {};
		
		public function addGreatVO(greatVO:GreatVO):void {
			_greatVOList.push(greatVO);
		}
		
		public function activateSection(idClient:String = null, idCase:String = null):void 
		{
			// Hace visibles todas sus secciones de informacion
			sectionMovie.visible = true;
			_activeBackgroundImageContainer.visible = true;
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Obteniendo destacado
			var greatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Si es de tipo video cargar el player
			if(greatVO.typeThumb == TableDataManager.VIDEO_TYPE)
				this.loadGreatYouTubeVideoPlayer();
			
			// Visualizando tooltips
			SiteManager.getInstance().showTooltips();
			
			// Reiniciando timers
			_timerTooltipA.start();
			_timerTooltipB.start();
			_timerGreats.start();
			
			/* Codigo utilizado para tracear la posicion de los backgrounds es la lista de visualizacion 
			trace("\n Antes:");
			var sp:Sprite = null;
			for(var i:uint = 0; i < SiteManager.getInstance().backgroundImageContainer.numChildren; i++) 
			{
				sp = SiteManager.getInstance().backgroundImageContainer.getChildAt(i) as Sprite;
				trace("backgroundImageContainer elemento ( nivel " + i + " ) : "  + sp.name + " [ visible = " + sp.visible + "]");
			}
			*/
				
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
				trace("oldBackgroundContainer_sp: " + oldBackgroundContainer_sp.name);
				
				// Reposicionando el elemento en la lista de visualizacion para que este por encima de los demas
				SiteManager.getInstance().backgroundImageContainer.addChild(oldBackgroundContainer_sp);
							
				// Transicion entre background de un destacado y el otro
				SiteManager.getInstance().playTransition(_activeBackgroundImageContainer, oldBackgroundContainer_sp);
			}
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
			trace("HomeSectionController->addBackgroundImageContainer()");		
			
			backgroundImageContainer.name = "homeBackgroundImageContainer_" + _backgroundImageContainerList.length;
			_backgroundImageContainerList.push(backgroundImageContainer);
		}
		
		public function addImageContainer(imageContainer:DisplayObject):void 
		{
			trace("HomeSectionController->addImageContainer()");		
			
			imageContainer.name = "homeImageContainer_" + _imageContainerList.length;
			_imageContainerList.push(imageContainer);
		}
		
		public function updateHomeInfo():void 
		{
			trace("HomeSectionController->updateHomeImageInfo()");
			
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Visualizando el primer background
			var backgroundImageContainer:Sprite = _backgroundImageContainerList[_activeGreatId] as Sprite;
			_activeBackgroundImageContainer = backgroundImageContainer;
			_activeBackgroundImageContainer.visible = true;
			
			// Verificando tipo de media
			if(great.typeThumb == TableDataManager.IMAGE_TYPE)
			{
				// Visualizando el primer contenedor de imagenes
				var imageContainer:Sprite = _imageContainerList[_activeGreatId] as Sprite;
				_activeImageContainer = imageContainer;
				_activeImageContainer.visible = true;
			}
			else if(great.typeThumb == TableDataManager.VIDEO_TYPE)
			{				
				this.loadGreatYouTubeVideoPlayer();				
			}
			
			// Rellenando los textos
			/* Las siguientes lineas no son necesarias mientras no sean dinamicos los textos de los destacados */
			//_sectionMovie.homeViewer_mc.info_mc.title_dtxt.text = great.title;
			//_sectionMovie.homeViewer_mc.info_mc.subtitle_dtxt.text = great.subtitle;
			//_sectionMovie.homeViewer_mc.info_mc.text_dtxt.text = great.text;
			
			/* Las siguientes lineas no son necesarias mientras no cambie el color de los textos de los botones de cada destacado */
			//_sectionMovie.homeViewer_mc.info_mc.case_mc.text_dtxt.htmlText = great.caseGreatButton.text;
			//_sectionMovie.homeViewer_mc.info_mc.post_mc.text_dtxt.htmlText = great.postGreatButton.text;
			
			// Obteniendo elementos sociales pares e impares
			var socialA:SocialVO = great.socialVOList[_activeTooltipAIndex] as SocialVO;
			var socialB:SocialVO = great.socialVOList[_activeTooltipBIndex] as SocialVO;
			
			// Actuzlizando tooltips
			SiteManager.getInstance().updateTooltips(socialA, SiteManager.TOOLTIP_A);
			SiteManager.getInstance().updateTooltips(socialB, SiteManager.TOOLTIP_B);	
			
			// Iniciando timers
			_timerTooltipA.start();
			_timerTooltipB.start();
			_timerGreats.start();
		}
		
		private function nextGreat():void 
		{
			trace("HomeSectionController->nextGreat()");
			
			// Invisibilizando contenedores actual
			_activeBackgroundImageContainer.visible = true;
			_activeImageContainer.visible = false;
			
			// Deteniendo reproduccion de VIDEO en el contenedor principal
			var actualGreatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			if(actualGreatVO.youtubeObject != null)
				if(actualGreatVO.youtubeObject.videoPlayer != null)
					if(actualGreatVO.youtubeObject.videoPlayer.getPlayerState() == 1){
						actualGreatVO.youtubeObject.videoPlayer.stopVideo();
						SiteManager.getInstance().onSoundButtonClick(null, true);
					}
			
			// Actulizando datos y recuperando contenedor del siguiente destacado (lista circular)
			_activeGreatId = Math.abs(_activeGreatId + 1) % _imageContainerList.length;
			var nextBackgroundImageContainer:Sprite = _backgroundImageContainerList[_activeGreatId] as Sprite;
			var nextImageContainer:Sprite = _imageContainerList[_activeGreatId] as Sprite;
			var greatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Visibilizando containers (background & viewer)
			nextBackgroundImageContainer.visible = true;
			nextImageContainer.visible = true;
			
			// Si es de tipo video cargar el player
			if(greatVO.typeThumb == TableDataManager.VIDEO_TYPE)
				this.loadGreatYouTubeVideoPlayer();
			
			/* Adicionando background al backgroundContainer principal (SiteManager).
			Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
			Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
			como consecuencia el elemento queda por enciama de los demas elementos
			*/
			SiteManager.getInstance().backgroundImageContainer.addChild(_activeBackgroundImageContainer);
						
			// Transicion entre background de un destacado y el otro
			SiteManager.getInstance().playTransition(nextBackgroundImageContainer, _activeBackgroundImageContainer);

			// Rellenando los textos
			/* Las siguientes lineas no son necesarias mientras no sean dinamicos los textos de los destacados */
			//_sectionMovie.homeViewer_mc.info_mc.title_dtxt.text = greatVO.title;
			//_sectionMovie.homeViewer_mc.info_mc.subtitle_dtxt.text = greatVO.subtitle;
			//_sectionMovie.homeViewer_mc.info_mc.text_dtxt.text = greatVO.text;
						
			/* Las siguientes lineas no son necesarias mientras no cambie el color de los textos de los botones de cada destacado */
			//_sectionMovie.homeViewer_mc.info_mc.case_mc.text_dtxt.htmlText = greatVO.caseGreatButton.text;
			//_sectionMovie.homeViewer_mc.info_mc.post_mc.text_dtxt.htmlText = greatVO.postGreatButton.text;
			
			// Actualizando contenedores activos
			_activeBackgroundImageContainer = nextBackgroundImageContainer;
			_activeImageContainer = nextImageContainer;
			
			// Actualizando tooltips
			_activeTooltipAIndex = 0;	// Indices pares
			_activeTooltipBIndex = 1;	// Indices impares
			
			// Obteniendo elementos sociales pares e impares
			var socialA:SocialVO = greatVO.socialVOList[_activeTooltipAIndex] as SocialVO;
			var socialB:SocialVO = greatVO.socialVOList[_activeTooltipBIndex] as SocialVO;
			
			// Actuzlizando tooltips
			SiteManager.getInstance().updateTooltips(socialA, SiteManager.TOOLTIP_A);
			SiteManager.getInstance().updateTooltips(socialB, SiteManager.TOOLTIP_B);	
			
			// Reiniciando timer de los destacados
			_timerGreats.stop();
			_timerGreats.start();
		}
		
		private function prevGreat():void 
		{
			trace("HomeSectionController->prevGreat()");
			
			// Invisibilizando contenedores actual
			_activeBackgroundImageContainer.visible = true;
			_activeImageContainer.visible = false;
			
			// Deteniendo reproduccion de VIDEO en el contenedor principal
			var actualGreatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			if(actualGreatVO.youtubeObject != null)
				if(actualGreatVO.youtubeObject.videoPlayer != null)
					if(actualGreatVO.youtubeObject.videoPlayer.getPlayerState() == 1) {
						actualGreatVO.youtubeObject.videoPlayer.stopVideo();
						SiteManager.getInstance().onSoundButtonClick(null, true);
					}
			
			// Actulizando datos y recuperando contenedor del siguiente destacado (lista circular)
			_activeGreatId = Math.abs(_activeGreatId + (_imageContainerList.length - 1));
			
			// Ajustando indices si se salen de rango
			if(_activeGreatId >= 5)
				_activeGreatId %= _imageContainerList.length;

			var prevBackgroundImageContainer:Sprite = _backgroundImageContainerList[_activeGreatId] as Sprite;
			var prevImageContainer:Sprite = _imageContainerList[_activeGreatId] as Sprite;
			var greatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
		
			// Visibilizando nuevo container
			prevBackgroundImageContainer.visible = true;
			prevImageContainer.visible = true;
			
			// Si es de tipo video cargar el player
			if(greatVO.typeThumb == TableDataManager.VIDEO_TYPE)
				this.loadGreatYouTubeVideoPlayer();
			
			/* Adicionando background al backgroundContainer principal (SiteManager).
			Con esto se consigue poner el elemento que se quiere visualizar por encima, en la lista de visualizacion, que los demas.
			Sucede asi cuando se vuelve añadir a la lista de visualizacion un elemento que ya se encontraba en ella, 
			como consecuencia el elemento queda por enciama de los demas elementos
			*/
			SiteManager.getInstance().backgroundImageContainer.addChild(_activeBackgroundImageContainer);
			
			// Transicion entre background de un destacado y el otro
			SiteManager.getInstance().playTransition(prevBackgroundImageContainer, _activeBackgroundImageContainer);
			
			// Rellenando los textos
			/* Las siguientes lineas no son necesarias mientras no sean dinamicos los textos de los destacados */
			//_sectionMovie.homeViewer_mc.info_mc.title_dtxt.text = greatVO.title;
			//_sectionMovie.homeViewer_mc.info_mc.subtitle_dtxt.text = greatVO.subtitle;
			//_sectionMovie.homeViewer_mc.info_mc.text_dtxt.text = greatVO.text;
			
			/* Las siguientes lineas no son necesarias mientras no cambie el color de los textos de los botones de cada destacado */			
			//_sectionMovie.homeViewer_mc.info_mc.case_mc.text_dtxt.htmlText = greatVO.caseGreatButton.text;
			//_sectionMovie.homeViewer_mc.info_mc.post_mc.text_dtxt.htmlText = greatVO.postGreatButton.text;
			
			// Actualizando contenedores activos
			_activeBackgroundImageContainer = prevBackgroundImageContainer;
			_activeImageContainer = prevImageContainer;
			
			// Actualizando tooltips
			_activeTooltipAIndex = 0;	// Indices pares
			_activeTooltipBIndex = 1;	// Indices impares
			
			// Obteniendo elementos sociales pares e impares
			var socialA:SocialVO = greatVO.socialVOList[_activeTooltipAIndex] as SocialVO;
			var socialB:SocialVO = greatVO.socialVOList[_activeTooltipBIndex] as SocialVO;
			
			// Actuzlizando tooltips
			SiteManager.getInstance().updateTooltips(socialA, SiteManager.TOOLTIP_A);
			SiteManager.getInstance().updateTooltips(socialB, SiteManager.TOOLTIP_B);
			
			// Reiniciando timer de los destacados
			_timerGreats.stop();
			_timerGreats.start();
		}
		
		private function onHelloClickHandler(evt:Event):void
		{
			SiteManager.getInstance().showHelloWindow();	
		}
		
		private function onHomeEventHandler(evt:EventComplex):void 
		{
			trace("HomeSectionController->onHomeEventHandler()");
			trace(evt.data);
			
			// Si el objeto de datos contenido en el evento es de tipo DataEventObject, el evento se refiere a una accion de cambio de seccion
			if(evt.data is DataEventObject)
			{
				// Obteniendo DataEvenObject con los datos de la accion a realizar
				var dataEO:DataEventObject = evt.data as DataEventObject;
				
				// Segun los datos del evento recibido (origin, destination, subdestination, action, etc), se ejecuta una accion
				var sectionVO:SectionVO = null;									
				
				if(dataEO.origin != dataEO.destination) 
				{
					// Detener e invisibilizar tooltips de destacados
					_timerTooltipA.stop();
					_timerTooltipB.stop();
					SiteManager.getInstance().hideTooltips();
					_timerGreats.stop();
					
					// Actualizando antiguo background para realizar animacion de transicion
					SiteManager.getInstance().setOldBackgroundContainer(_activeBackgroundImageContainer);
					
					// Reproduciendo sonido, esta funcion reproduce el sonido en caso de que no haya sido detenido por el usuario
					SiteManager.getInstance().onSoundButtonClick(null, true);
					
					// Deteniendo reproduccion de VIDEO en el contenedor principal
					var actualGreatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
					if(actualGreatVO.youtubeObject != null)
						if(actualGreatVO.youtubeObject.videoPlayer != null)
							if(actualGreatVO.youtubeObject.videoPlayer.getPlayerState() == 1)
								actualGreatVO.youtubeObject.videoPlayer.stopVideo();
					
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
				else
				{										
					// Segun la los datos del evento recibido (action, greatIndex), se ejecuta una accion				
					switch(dataEO.action)
					{			
						case TableDataManager.LOAD_HOME_SECTION:
							trace("Seccion actual: " + _sectionVO.name);
							
							break;
						
						case TableDataManager.UPDATE_BACKGROUND_IMAGE:
							trace("Actualizando imagen de fondo");
							break;
						
						case TableDataManager.LOAD_NEXT_GREAT:
							// Siguiente informacion visual (background & viewer)
							nextGreat();						
							break;
						
						case TableDataManager.LOAD_PREV_GREAT:
							// Anterior informacion visual (background & viewer)
							prevGreat();
							break;
						
						default:
							throw new Error("Unknow action");					
					}
				}
			}			
		}	
		
		private function onTimerTooltipA(evt:TimerEvent):void
		{
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Proximo elemento par
			_activeTooltipAIndex += 2;
			
			// Verificando si existe ese elemento
			if(great.socialVOList[_activeTooltipAIndex] == null)
				_activeTooltipAIndex = 0;
			
			// Obteniendo elemento sociales pares e impares
			var socialA:SocialVO = great.socialVOList[_activeTooltipAIndex] as SocialVO;
			
			// Actuzlizando tooltip de tipo A
			SiteManager.getInstance().updateTooltips(socialA, SiteManager.TOOLTIP_A);					
		}
		
		private function onTimerTooltipB(evt:TimerEvent):void
		{
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Proximo elemento par
			_activeTooltipBIndex += 2;
			
			// Verificando si existe ese elemento
			if(great.socialVOList[_activeTooltipBIndex] == null)
				_activeTooltipBIndex = 1;
			
			// Obteniendo elemento sociales pares e impares
			var socialB:SocialVO = great.socialVOList[_activeTooltipBIndex] as SocialVO;
			
			// Actuzlizando tooltip de tipo A
			SiteManager.getInstance().updateTooltips(socialB, SiteManager.TOOLTIP_B);	
		}
		
		private function onTimerGreats(evt:TimerEvent):void
		{
			// Cambiando destacado automaticamente
			nextGreat();
		}
		
		private function onGreatLinkButtonClickHandler(evt:Event):void
		{		
			// Detener e invisibilizar tooltips de destacados
			_timerTooltipA.stop();
			_timerTooltipB.stop();			
			_timerGreats.stop();
			SiteManager.getInstance().hideTooltips();
			
			// Obteniendo objeto de datos 
			var greatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			trace("GREAD CLIENT ID: " + greatVO.clientRef);
			trace("GREAD CASE ID: " + greatVO.caseRef);
			
			// Declaracion de variables
			var destination:String = TableDataManager.SECTION_CLIENT;
			var subdestination:String = null;
			var action:String = TableDataManager.LOAD_CLIENT_SECTION;
			var type:String = LoaderManager.SWF_TYPE;
			
			// Creando objeto de datos para el evento
			var dataEventObject:DataEventObject = new DataEventObject(TableDataManager.SECTION_EXPERIENCES, destination, action, type);
			dataEventObject.idClient = greatVO.clientRef;
			dataEventObject.idCase = greatVO.caseRef;
			dataEventObject.controller = this;
			trace(dataEventObject);
			
			// Actualiznado variable bandera de espera de configuracion de la seccion EXPERIENCES
			this.isTransitionCanceled = true;
			
			// Creando evento complejo
			var actionEvent:EventComplex = new EventComplex(TableDataManager.SECTION_EVENT, dataEventObject);
			ExperiencesSectionController.getInstance().loadExperiencesConfiguration(actionEvent);
		}
		
		private function onGreatPostButtonClickHandler(evt:Event):void
		{
			// Obteniendo objeto de datos 
			var greatVO:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			trace("GREAD URL POST: " + greatVO.urlPost);
			
			// Lanzando navegador con la direccion del post en el blog de Btob
			navigateToURL(new URLRequest(greatVO.urlPost));
		}
		
		// GREAT YOUTUBE VIDEO PLAYER
		
		private function loadGreatYouTubeVideoPlayer():void
		{
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Haciendo visible loader
			(_sectionMovie.homeViewer_mc.visualLoader_mc as MovieClip).visible = true;
			
			// Inicializando loader del player
			great.youtubeObject.loader.contentLoaderInfo.addEventListener(Event.INIT, onGreatVideoLoaderInit);
			great.youtubeObject.loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}
		
		private function onGreatVideoLoaderInit(event:Event):void 
		{
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Eliminando contenidos cargados en el contenedor anteriormente
			for(var i:uint = 0; i < great.youtubeObject.container.numChildren; i++)
				great.youtubeObject.container.removeChildAt(i);
			
			// Adicionando contenido
			great.youtubeObject.container.addChild(great.youtubeObject.loader);
			great.youtubeObject.loader.content.addEventListener("onReady", onGreatVideoPlayerReady);
			great.youtubeObject.loader.content.addEventListener("onError", onGreatVideoPlayerError);
			great.youtubeObject.loader.content.addEventListener("onStateChange", onGreatVideoPlayerStateChange);
			great.youtubeObject.loader.content.addEventListener("onPlaybackQualityChange", onGreatVideoPlaybackQualityChange);
		}
		
		private function onGreatVideoPlayerReady(event:Event):void 
		{
			// Event.data contains the event parameter, which is the Player API ID 
			trace("player ready:", Object(event).data);
			
			// Obteniendo destacado
			var great:GreatVO = _greatVOList[_activeGreatId] as GreatVO;
			
			// Invisibilizando loader
			(_sectionMovie.homeViewer_mc.visualLoader_mc as MovieClip).visible = false;
			
			// Asignando contenido al player (Object)
			great.youtubeObject.videoPlayer = great.youtubeObject.loader.content;
			great.youtubeObject.videoPlayer.setSize(650, 505);
			
			// Cargar video segun ID de video youtube
			var url:String = great.urlThumb;	
			var index:int = url.indexOf("=");
			var videoID:String = url.substr(index + 1);
			great.youtubeObject.videoPlayer.cueVideoById(videoID, 0);
			
			if(_activeImageContainer == null)
			{
				_activeImageContainer = great.youtubeObject.container;
				_activeImageContainer.visible = true;
			}
		}
		
		private function onGreatVideoPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		private function onGreatVideoPlayerStateChange(event:Event):void 
		{
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
			
			switch(Object(event).data)
			{
				case 0:		// Video detenido 
					SiteManager.getInstance().onSoundButtonClick(null, true);
					_timerGreats.start();
					this.onGreatVideoPlayerReady(null);
					break;
				
				case 1: 	// Video reproduciendo
					SiteManager.getInstance().onSoundButtonClick(null, false);
					_timerGreats.stop();
					break;
				
			}
		}
		
		private function onGreatVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}
	}
}