/**
 * ...
 * MainManager
 * Representa la pelicula principal de la aplicacion.
 * Conecta el fichero principal (main.swf), con la logica de la aplicacion (clases).
 * Una vez cargada la configuracion necesaria pasa el control a la clase LanDakarFacebookTabManager (com.epinom.lan.dakar.managers.LanDakarFacebookTabManager)
 * 
 * @author Ernesto Pino Martínez
 * @date 20/10/2010
 */

package com.epinom.lan.dakar.managers
{
	import caurina.transitions.Tweener;
	
	import com.digitalsurgeons.loading.BulkLoader;
	import com.digitalsurgeons.loading.BulkProgressEvent;
	import com.digitalsurgeons.loading.loadingtypes.LoadingItem;
	import com.epinom.lan.dakar.model.ComponentModel;
	import com.epinom.lan.dakar.model.DataModel;
	import com.epinom.lan.dakar.ui.Component;
	import com.epinom.lan.dakar.utils.XMLParser;
	import com.epinom.lan.dakar.vo.ComponentVO;
	import com.epinom.lan.dakar.vo.LanguageVO;
	import com.epinom.lan.dakar.vo.ModalWindowVO;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import net.stevensacks.preloaders.CircleSlicePreloader;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class MainManager extends Sprite
	{
		/**
		 * @property
		 * Referencias a los objetos visuales de la pelicula
		 */
		private var _modalPanelMC:MovieClip;
		private var _loaderMC:MovieClip;
		
		/**
		 * @property
		 * Objeto responsable de cargas multiples de ficheros externos
		 */
		private var _bulkLoader:BulkLoader;	
		
		/**
		 * @property
		 * Debugger
		 */
		private var debugger:MonsterDebugger;
		
		/**
		 * @property
		 * Referencia al swf "manager.swf"
		 */
		private var manager_mc:MovieClip;
		private var managerLoader:Loader;
		
		/**
		 * @property
		 * Objeto contenedor de variables externas enviadas desde el HTML/PHP
		 */
		private var flashvars:Object;
		
		/**
		 * @property
		 * Variables para comunicacion entre AS3 y Javascript en un entorno Facebook
		 */
		private var connection:LocalConnection; 
		private var connectionName:String;
		
		/**
		 * @property
		 * Loader visual
		 */
		private var visualPreloader:CircleSlicePreloader;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */		
		public function MainManager()
		{
			// Agregando cualquier dominio para temas de seguridad de Flash Player
			if(LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
			{
				Security.allowInsecureDomain("*");
				Security.allowDomain("*");
				Security.allowDomain("http://conlanadakar.es/facebook/main.swf");
				Security.allowDomain("http://conlanadakar.es/facebook/manager.swf");
				Security.loadPolicyFile("http://conlanadakar.es/crossdomain.xml"); 
			}
			
			super();
			trace("MainManager->MainManager()");

			// Inicializando propiedades
			this.stage.align = StageAlign.TOP;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			debugger = new MonsterDebugger(this);
			manager_mc = null;
			flashvars = null;			
			
			// Inicializando aplicacion
			init();
		}				
		
		/**
		 * @PRIVATE METHODS
		 * Funciones privadas de la clase
		 */
		
		/**
		 * @method
		 * Inicializa la apicacion
		 */
		private function init():void
		{
			// Iniciando carga de elementos externos
			_bulkLoader = new BulkLoader(TableDataManager.MAIN_MANAGER);
			_bulkLoader.logLevel = BulkLoader.LOG_INFO;
			
			// Configurando detectores de eventos
			this.loaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);				
		}
		
		private function onLoaderComplete(evt:Event):void 
		{	
			trace("MainManager->onLoaderComplete()");
			
			// Obteniendo flashvars
			flashvars = (this.root.loaderInfo as LoaderInfo).parameters;
			
			// Trazas
			var flag:Boolean = false;
			if(flashvars.access_token != null && flag)
			{
				(console as TextField).appendText(flashvars.access_token);
				(console as TextField).appendText(flashvars.url);
				(console as TextField).appendText(flashvars.participation);
				(console as TextField).appendText(flashvars.language);
				(console as TextField).appendText(flashvars.invite);
			}
			
			// Suscribiendose a la clase LanguageManager, para recibir sus eventos
			LanguageManager.getInstance().addEventListener(TableDataManager.LANGUAGE_LOADED, onLanguageConfigurationLoaded);
			
			// Solicitando configuracion de lenguaje a servicio PHP externo, una vez que este sea cargado satisfactoriamente se continua con la ejecucion de la aplicaicon a traves de la funcion "onLanguageConfigurationLoaded"
			LanguageManager.getInstance().loadLanguageConfiguration(flashvars);					
		}
		
		/**
		 * @method
		 * Configura la aplicacion
		 */
		private function configApp():void
		{
			// Obteniendo XMls cargados
			var settingsXML:XML = _bulkLoader.getXML(TableDataManager.SETTINGS_FILE);				
			var languageXML:XML = _bulkLoader.getXML(LanguageManager.getInstance().data.languageXMLLocation);
			if(!LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
				var winnersXML:XML = _bulkLoader.getXML(TableDataManager.WINNERS_FILE);	
			
			// Parseando ficheros XML de configuracion
			DataModel.getInstance().settings = XMLParser.parseSettingsXML(settingsXML, DataModel.getInstance().settings);				
			LanguageManager.getInstance().data = XMLParser.parseLanguageXML(languageXML, LanguageManager.getInstance().data);	
			if(!LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
				DataModel.getInstance().winnerList = XMLParser.parseWinnersXML(winnersXML);
			
			// Construyendo interfaz, se le pasa el mismo evento que recibe para poder acceder al loaderInfo 
			buildInterface();
		}
		
		/**
		 * @method
		 * Construye interfaz la apicacion
		 */
		private function buildInterface():void			
		{		
			// Verificando si la aplicacion correo sobre un dominio de Facebook
			var urlApp:String = "";
			if(LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)	
				urlApp = TableDataManager.URL_FACEBOOK;

			try
			{		
				// BLUE PANEL
				var bluePanelComponentVO:ComponentVO = new ComponentVO();
				bluePanelComponentVO.hashId = TableDataManager.COMPONENT_BLUE_PANEL_HASH;				
				var bluePanelComponent:Component = new Component(bluePanelComponentVO);
				bluePanelComponent.name = TableDataManager.COMPONENT_BLUE_PANEL_HASH;			
				ComponentModel.getInstance().addComponent(bluePanelComponent);
				this.addChild(bluePanelComponent);	
				
				// BG GIFT SECTION
				var bgGiftSectionComponentVO:ComponentVO = new ComponentVO();
				bgGiftSectionComponentVO.hashId = TableDataManager.COMPONENT_BG_GIFT_SECTION_HASH;				
				var bgGiftSectionComponent:Component = new Component(bgGiftSectionComponentVO);
				bgGiftSectionComponent.name = TableDataManager.COMPONENT_BG_GIFT_SECTION_HASH;			
				ComponentModel.getInstance().addComponent(bgGiftSectionComponent);
				this.addChild(bgGiftSectionComponent);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				bgGiftSectionComponent.addChild(manager_mc.bgGiftSection_mc);
				(bgGiftSectionComponent.getChildAt(0) as MovieClip).gotoAndStop(LanguageManager.getInstance().languageApplication);		
				
				// BG GAME SECTION
				var bgGameSectionComponentVO:ComponentVO = new ComponentVO();
				bgGameSectionComponentVO.hashId = TableDataManager.COMPONENT_BG_GAME_SECTION_HASH;
				
				var bgGameSectionComponent:Component = new Component(bgGameSectionComponentVO);
				bgGameSectionComponent.name = TableDataManager.COMPONENT_BG_GAME_SECTION_HASH;
				ComponentModel.getInstance().addComponent(bgGameSectionComponent);
				this.addChild(bgGameSectionComponent);
				bgGameSectionComponent.addChild(manager_mc.bgGameSection_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				bgGameSectionComponent.addChild(manager_mc.bgGameSection_mc);
				(bgGameSectionComponent.getChildAt(0) as MovieClip).gotoAndStop(LanguageManager.getInstance().languageApplication);	
				
				// BUTTON GIFT SECTION
				var buttonGiftSectionComponentVO:ComponentVO = new ComponentVO();
				buttonGiftSectionComponentVO.hashId = TableDataManager.COMPONENT_BUTTON_GIFT_SECTION_HASH;
				
				var buttonGiftSectionComponent:Component = new Component(buttonGiftSectionComponentVO);
				buttonGiftSectionComponent.name = TableDataManager.COMPONENT_BUTTON_GIFT_SECTION_HASH;
				buttonGiftSectionComponent.visible = false;
				ComponentModel.getInstance().addComponent(buttonGiftSectionComponent);
				this.addChild(buttonGiftSectionComponent);
				buttonGiftSectionComponent.addChild(manager_mc.buttonGiftSection_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
	
				// TEXT GAME SECTION
				var textGameSectionComponentVO:ComponentVO = new ComponentVO();
				textGameSectionComponentVO.hashId = TableDataManager.COMPONENT_TEXT_GAME_SECTION_HASH;
				
				var textGameSectionComponent:Component = new Component(textGameSectionComponentVO);
				textGameSectionComponent.name = TableDataManager.COMPONENT_TEXT_GAME_SECTION_HASH;
				ComponentModel.getInstance().addComponent(textGameSectionComponent);
				this.addChild(textGameSectionComponent);
				textGameSectionComponent.addChild(manager_mc.textGameSection_mc);	
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// IMAGE VIEWER
				var imageViewerComponentVO:ComponentVO = new ComponentVO();
				imageViewerComponentVO.hashId = TableDataManager.COMPONENT_IMAGE_VIEWER_HASH;
				
				var imageViewerComponent:Component = new Component(imageViewerComponentVO);
				imageViewerComponent.name = TableDataManager.COMPONENT_IMAGE_VIEWER_HASH;
				ComponentModel.getInstance().addComponent(imageViewerComponent);
				this.addChild(imageViewerComponent);
				imageViewerComponent.addChild(manager_mc.imageViewer_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// QUESTION PANEL
				var questionPanelComponentVO:ComponentVO = new ComponentVO();
				questionPanelComponentVO.hashId = TableDataManager.COMPONENT_QUESTION_PANEL_HASH;
				
				var questionPanelComponent:Component = new Component(questionPanelComponentVO);
				questionPanelComponent.name = TableDataManager.COMPONENT_QUESTION_PANEL_HASH;
				ComponentModel.getInstance().addComponent(questionPanelComponent);
				this.addChild(questionPanelComponent);
				questionPanelComponent.addChild(manager_mc.questionPanel_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// MENU
				var menuComponentVO:ComponentVO = new ComponentVO();
				menuComponentVO.hashId = TableDataManager.COMPONENT_MENU_HASH;
				
				var menuComponent:Component = new Component(menuComponentVO);
				menuComponent.name = TableDataManager.COMPONENT_MENU_HASH;
				ComponentModel.getInstance().addComponent(menuComponent);
				this.addChild(menuComponent);
				menuComponent.addChild(manager_mc.menu_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// LEGAL TEXT
				var legalTextComponentVO:ComponentVO = new ComponentVO();
				legalTextComponentVO.hashId = TableDataManager.COMPONENT_LEGAL_TEXT;
				
				var legalTextComponent:Component = new Component(legalTextComponentVO);
				legalTextComponent.name = TableDataManager.COMPONENT_LEGAL_TEXT;
				ComponentModel.getInstance().addComponent(legalTextComponent);
				this.addChild(legalTextComponent);
				legalTextComponent.addChild(manager_mc.legalText_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// MODAL PANEL
				var modalPanelComponentVO:ComponentVO = new ComponentVO();
				modalPanelComponentVO.hashId = TableDataManager.COMPONENT_MODAL_PANEL_HASH;
				
				var modalPanelComponent:Component = new Component(modalPanelComponentVO);
				modalPanelComponent.name = TableDataManager.COMPONENT_MODAL_PANEL_HASH;
				ComponentModel.getInstance().addComponent(modalPanelComponent);
				this.addChild(modalPanelComponent);
				modalPanelComponent.addChild(manager_mc.modalPanel_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// DATA FORM
				var dataFormModalWindowComponentVO:ComponentVO = new ComponentVO();
				dataFormModalWindowComponentVO.hashId = TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH;
				
				var dataFormModalWindowComponent:Component = new Component(dataFormModalWindowComponentVO);
				dataFormModalWindowComponent.name = TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(dataFormModalWindowComponent);
				this.addChild(dataFormModalWindowComponent);
				dataFormModalWindowComponent.addChild(manager_mc.dataFormModalWindow_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// GENERIC MODAL WINDOW
				var genericModalWindowComponentVO:ComponentVO = new ComponentVO();
				genericModalWindowComponentVO.hashId = TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH;
				
				var genericModalWindowComponent:Component = new Component(genericModalWindowComponentVO);
				genericModalWindowComponent.name = TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(genericModalWindowComponent);
				this.addChild(genericModalWindowComponent);
				genericModalWindowComponent.addChild(manager_mc.genericModalWindow_mc);
				
				// Invisibilizando boton de la ventana modal generica para que no se pueda cerrar
				(manager_mc.genericModalWindow_mc.close_btn as SimpleButton).visible = false;
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// WINNERS MODAL WINDOW
				var winnersModalWindowComponentVO:ComponentVO = new ComponentVO();
				winnersModalWindowComponentVO.hashId = TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH;
				
				var winnersModalWindowComponent:Component = new Component(winnersModalWindowComponentVO);
				winnersModalWindowComponent.name = TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(winnersModalWindowComponent);
				this.addChild(winnersModalWindowComponent);
				winnersModalWindowComponent.addChild(manager_mc.winnersModalWindow_mc);		
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);								
				
				// WELCOME MODAL WINDOW
				var welcomeModalWindowComponentVO:ComponentVO = new ComponentVO();
				welcomeModalWindowComponentVO.hashId = TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH;
				
				var welcomeModalWindowComponent:Component = new Component(welcomeModalWindowComponentVO);
				welcomeModalWindowComponent.name = TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(welcomeModalWindowComponent);
				this.addChild(welcomeModalWindowComponent);
				welcomeModalWindowComponent.addChild(manager_mc.welcomeModalWindow_mc);	
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// FAN MODAL WINDOW
				var fanModalWindowComponentVO:ComponentVO = new ComponentVO();
				fanModalWindowComponentVO.hashId = TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH;
				
				var fanModalWindowComponent:Component = new Component(fanModalWindowComponentVO);
				fanModalWindowComponent.name = TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(fanModalWindowComponent);
				this.addChild(fanModalWindowComponent);
				fanModalWindowComponent.addChild(manager_mc.fanModalWindow_mc);
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);
				((fanModalWindowComponent.getChildAt(0) as MovieClip).fanImages_mc as MovieClip).gotoAndStop(LanguageManager.getInstance().languageApplication);	
				
				// CONFIRM DATA FORM MODAL WINDOW
				var confirmDataFormModalWindowComponentVO:ComponentVO = new ComponentVO();
				confirmDataFormModalWindowComponentVO.hashId = TableDataManager.COMPONENT_CONFIRM_DATA_FORM_MODAL_WINDOW_HASH;
				
				var confirmDataFormModalWindowComponent:Component = new Component(confirmDataFormModalWindowComponentVO);
				confirmDataFormModalWindowComponent.name = TableDataManager.COMPONENT_CONFIRM_DATA_FORM_MODAL_WINDOW_HASH;
				ComponentModel.getInstance().addComponent(confirmDataFormModalWindowComponent);
				this.addChild(confirmDataFormModalWindowComponent);
				confirmDataFormModalWindowComponent.addChild(manager_mc.confirmDataFormModalWindow_mc);	
				
				// Superponiendo el Panel Azul sobre el ultimo elemento adicionado al escenario
				this.addChild(bluePanelComponent);	
				
				// LOADER (Cambiando nivel de visibilidad)
				this.addChild(_loaderMC);	
				
				// Pasando el control de la aplicacion a la clase LanDakarFacebookTabManager (com.epinom.lan.dakar.managers.LanDakarFacebookTabManager)
				LanDakarFacebookTabManager.getInstance(flashvars);
				
				// Pasando referencia a objetos a la clase que tiene el control de la aplicacion
				LanDakarFacebookTabManager.getInstance().setStage(this.stage);
				LanDakarFacebookTabManager.getInstance().setLoader(_loaderMC);
				LanDakarFacebookTabManager.getInstance().setFacebookBridge(this.runJavascriptFacebookBridge);	
				LanDakarFacebookTabManager.getInstance().setReloadBridge(this.reloadPageFacebookBridge);	
			}
			catch(e:Error)
			{
				var error:String = "MainManager->buildInterface():\nMANAGER MC: " + manager_mc +
									"\nBULKLOADER: " + _bulkLoader + 
									"\nURL MANAGER FILE: " + urlApp + TableDataManager.MANAGER_FILE + 
									"\nID MANAGER BULKLOADER: " + TableDataManager.MANAGER_FILE + 					
									"\n" + e.toString();
					
				for(var i:uint = 0; i < _bulkLoader.itemsLoaded; i++)
				{
					error += "\nID: " + (_bulkLoader.items[i] as LoadingItem).id;
					error += "\nURL: " + ((_bulkLoader.items[i] as LoadingItem).url as URLRequest).url;
				}
				
				throw new Error(error);
			}
		}
		
		
		/**
		 * @PUBLIC METHODS
		 * Funciones publicas de la clase
		 */
		
		/**
		 * @method
		 * Muestra en pantalla dialogo que indica que se esta cargando un contenido externo		
		 */
		public function showLoader():void 
		{			
			// Reiniciando barra de precarga del loader
			_modalPanelMC.visible = true;				
			_loaderMC.bar_mc.gotoAndStop(0);			
			
			// Realizando animacion del objeto de loading visual
			_loaderMC.x = this.stage.stageWidth / 2;
			_loaderMC.y = this.stage.stageHeight / 2;					
			_loaderMC.alpha = 0;	
			Tweener.addTween(_loaderMC, {alpha:1, time:1, transition:"easeOutCubic"});
			Tweener.addTween(_loaderMC, { x:_loaderMC.x, y:_loaderMC.y - 40, time:1, transition:"easeOutCubic"});	
		}		
		
		/**
		 * @method
		 * Elimina de pantalla dialogo que indica que se esta cargando un contenido externo		
		 */
		public function hideLoader():void 
		{
			// Realizando animacion del objeto de loader visual			
			Tweener.addTween(_loaderMC, {alpha:0, time:1, transition:"easeOutCubic"});
			Tweener.addTween(_loaderMC, {x:_loaderMC.x, y:_loaderMC.y + 40, time:1, transition:"easeOutCubic"} );
			_modalPanelMC.visible = false;			
		}
		
		public function runJavascriptFacebookBridge():void
		{
			try
			{
				var connection:LocalConnection = new LocalConnection();
				var connectionName:String = LoaderInfo(this.root.loaderInfo).parameters.fb_local_connection;
				connection.allowDomain("*");
				connection.send(connectionName, "callFBJS", "showInvite", null);
			}
			catch(e:Error)
			{

				var msg:String = "";
				msg += "_modalPanelMC: " + _modalPanelMC + "\n" + 
					   "_modalPanelMC.console: " + _modalPanelMC.console + "\n" +
					   "connectionName: " + connectionName;
				
				throw new Error(e.toString());
			}
		}	
		
		public function reloadPageFacebookBridge():void
		{
			try
			{
				var connection:LocalConnection = new LocalConnection();
				var connectionName:String = LoaderInfo(this.root.loaderInfo).parameters.fb_local_connection;
				connection.allowDomain("*");
				connection.send(connectionName, "callFBJS", "reloadPage", null);
			}
			catch(e:Error)
			{
				throw new Error(e.toString());
			}
		}	
		
		
		/**
		 * @EVENTS
		 * Funciones que responden a eventos de la clase
		 */
		
		/**
		 * @event
		 * Ejecuta acciones una vez cargado el lenguage de la aplicacion
		 */
		private function onLanguageConfigurationLoaded(evt:Event):void
		{
			trace("Lenguage de la aplicacion cargado con exito");
			
			// Verificando si la aplicacion correo sobre un dominio de Facebook
			var urlApp:String = "";
			if(LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)	
				urlApp = TableDataManager.URL_FACEBOOK;
			
			// Configurando urls de los ficheros de configuracion
			DataModel.getInstance().settings.settingsXMLLocation = urlApp + TableDataManager.SETTINGS_FILE;	
			if(!LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
				DataModel.getInstance().settings.winnersXMLLocation = urlApp + TableDataManager.WINNERS_FILE;	
			
			// Trazas de las rutas
			//(console as TextField).appendText(urlApp + TableDataManager.SETTINGS_FILE);
			//(console as TextField).appendText(urlApp + TableDataManager.WINNERS_FILE);
			//(console as TextField).appendText(urlApp + TableDataManager.MANAGER_FILE);

			// Adicionando loader a la pelicula, la clase LoaderMC es el identificador de la biblioteca del objeto loader en la pelicula "main.swf"
			_loaderMC = new LoaderMC();
			_loaderMC.x = this.stage.stageWidth / 2 ;
			_loaderMC.y = this.stage.stageHeight / 2 ;
			this.addChild(_loaderMC);												

			// Adicionando elementos a la cargar multiple
			_bulkLoader.add(new URLRequest(DataModel.getInstance().settings.settingsXMLLocation), {id: TableDataManager.SETTINGS_FILE});
			if(!LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
				_bulkLoader.add(new URLRequest(DataModel.getInstance().settings.winnersXMLLocation), {id: TableDataManager.WINNERS_FILE});
			
			// Verificando lenguaje de la aplicacion para carga de fichero externa en correspondencia con el mismo
			if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)		
				LanguageManager.getInstance().data.languageXMLLocation = urlApp + TableDataManager.SPANISH_FILE;				
			else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
				LanguageManager.getInstance().data.languageXMLLocation = urlApp + TableDataManager.FRENCH_FILE;
			
			// Adicionando a la cola de precarga de ficheros externos el archivo de configuracion de idioma de la aplicacion
			trace(LanguageManager.getInstance().data.languageXMLLocation);
			_bulkLoader.add(new URLRequest(LanguageManager.getInstance().data.languageXMLLocation), {id: LanguageManager.getInstance().data.languageXMLLocation}); 

			// Configurando detectores de eventos		
			_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorHandler);
			_bulkLoader.start();
			
			// Cargando "manager.swf" de forma directa sin utilizar librerias externas
			managerLoader = new Loader();
			var managerContext:LoaderContext = new LoaderContext();
			managerContext.checkPolicyFile = true;
			managerContext.securityDomain = SecurityDomain.currentDomain;
			managerContext.applicationDomain = ApplicationDomain.currentDomain;
			var managerURLRequest:URLRequest = new URLRequest(urlApp + TableDataManager.MANAGER_FILE);
			managerLoader.load(managerURLRequest);
			managerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onBulkElementLoadedHandler);
			managerLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onBulkElementProgressHandler);
			managerLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			this.addChild(managerLoader);
		}
		
		/**
		 * @event
		 * Ejecuta acciones una vez terminada las descargas de ficheros externos	
		 */
		public function onBulkElementLoadedHandler(evt:Event):void 
		{
			trace("MainManager->onBulkElementLoadedHandler()");
			
			// Desactivando detectores de eventos
			_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
			_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);	
			_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorHandler);
			
			// Realizando animacion del objeto de loader visual
			Tweener.addTween(_loaderMC, {alpha:0, time:1, transition:"easeOutCubic"});
			Tweener.addTween(_loaderMC, {x:_loaderMC.x, y:_loaderMC.y + 40, time:1, transition:"easeOutCubic"} );	
			
			// Obteniendo swf cargado
			manager_mc = evt.target.content as MovieClip;
			trace(manager_mc);				
				
			// Configurando aplicacion
			configApp();			
		}
		
		/**
		 * @event
		 * Ejecuta acciones mientras se descargan los ficheros externos	
		 */
		public function onBulkElementProgressHandler(evt:ProgressEvent):void 
		{
			var percentLoaded:Number = evt.bytesLoaded/evt.bytesTotal;
			percentLoaded = Math.round(percentLoaded * 100);
			_loaderMC.bar_mc.gotoAndStop(percentLoaded);
			if(evt.bytesLoaded == evt.bytesTotal)
				_loaderMC.bar_mc.gotoAndStop(100);
			
			/*
			trace("onBulkElementProgressHandler: name=" + evt.target + " bytesLoaded=" + evt.bytesLoaded + " bytesTotal=" + evt.bytesTotal);
			var percent:uint = Math.floor((evt.totalPercentLoaded) * 100) ;	
			_loaderMC.bar_mc.gotoAndStop(percent);
			if(evt.bytesLoaded == evt.bytesTotal)
				_loaderMC.bar_mc.gotoAndStop(100);
			*/
		}									

		/**
		 * @event
		 * Ejecuta acciones cuando se captura algun error en la descarga de ficheros externos
		 */
		public function onErrorHandler(evt:Event):void 
		{	
			throw new Error("\nERROR: " + evt);
		}
	}
}