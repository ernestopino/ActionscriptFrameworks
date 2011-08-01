package com.epinom.btob.ui
{
	import com.digitalsurgeons.loading.BulkLoader;
	import com.epinom.btob.data.BtobDataModel;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.events.EventComplex;
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class LikeSectionController implements ISectionController
	{
		private static var _instance:LikeSectionController = null;
		private static var _allowInstantiation:Boolean;
		
		public static const SECTION_NAME:String = "like";
		public static const SECTION_CONTROLLER:String = "likeSectionController";
		
		private var _sectionVO:SectionVO;
		private var _activeBackgroundId:uint;
		private var _sectionMovie:MovieClip;
		private var _activeBackgroundImageContainer:Sprite;
		private var _backgroundImageContainerList:Array;
		
		// Variables de control para animacion de transiciones entre secciones
		private var _actualBackgroundContainer_sp:Sprite;
		
		public function LikeSectionController()
		{
			if (!_allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use LikeSectionController.getInstance() instead of new.");
			} else {				
				_sectionMovie = null;
				_activeBackgroundImageContainer = null;
				_backgroundImageContainerList = new Array();
				_actualBackgroundContainer_sp = null;
			}
		}
		
		public static function getInstance():LikeSectionController 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new LikeSectionController();
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		public function get sectionVO():SectionVO { return _sectionVO; }
		public function set sectionVO(value:SectionVO):void { _sectionVO = value; }	
		
		public function get sectionMovie():MovieClip { return _sectionMovie; }
		public function set sectionMovie(value:MovieClip):void {  
			_sectionMovie = value;
			_sectionMovie.addEventListener(TableDataManager.SECTION_EVENT, onLikeEventHandler, false, 0, true);
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
			trace("LikeSectionController->addBackgroundImageContainer()");		
			backgroundImageContainer.name = "likeBackgroundImageContainer_" + _backgroundImageContainerList.length;
			_backgroundImageContainerList.push(backgroundImageContainer);
		}
		
		public function updateLikeImageInfo():void 
		{
			trace("LikeSectionController->updateLikeImageInfo()");
			
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
			
			// Adicionando objetos a la precarga
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
			trace("LikeSectionController->onBulkSectionLoadedHandler()");
			
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
			var like_mc:MovieClip = bulkLoader.getMovieClip(_sectionVO.urlSWF);
			trace(like_mc);
			
			// Actualizando estado de la carga de la seccion
			SiteManager.getInstance().updateStatusLoadedSection(_sectionVO.id, true);
			
			// Actualizando controlador de seccion activo en la clase principal
			SiteManager.getInstance().updateSectionController(this);
			
			// Pasandole el homeMovie (Movieclip) a la clase controladora
			this.sectionMovie = like_mc;
			
			// Actualizando seccion actual
			SiteManager.getInstance().activeSection = like_mc;
			
			// Agregando SWF cargado al Movieclip que representa la seccion de contenidos					
			SiteManager.getInstance().addInfoToSectionPanel(like_mc);
			
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
		
		private function onLikeEventHandler(evt:EventComplex):void 
		{
			trace("LikeSectionController->onLikeEventHandler()");
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
		
		
	}
}