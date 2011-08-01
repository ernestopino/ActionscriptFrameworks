/**
 * ...
 * LanDakarFacebookTabManager
 * Lleva el control de toda la aplicacion, incluyendo el manejo de todas las clases que la integran y los datos relacionados.
 * Utiliza un patron Singleton, con el objetivo de que solo pueda existir una unica instancia de la clase.
 * 
 * @author Ernesto Pino Martínez
 * @date 20/10/2010
 */ 

package com.epinom.lan.dakar.managers
{
	import caurina.transitions.Tweener;
	
	import com.digitalsurgeons.loading.BulkLoader;
	import com.digitalsurgeons.loading.BulkProgressEvent;
	import com.digitalsurgeons.loading.lazyloaders.LazyBulkLoader;
	import com.epinom.lan.dakar.model.ComponentModel;
	import com.epinom.lan.dakar.model.DataModel;
	import com.epinom.lan.dakar.ui.Component;
	import com.epinom.lan.dakar.utils.StringUtils;
	import com.epinom.lan.dakar.utils.XMLParser;
	import com.epinom.lan.dakar.vo.ModalWindowVO;
	import com.epinom.lan.dakar.vo.WinnerVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.sensors.Accelerometer;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import net.stevensacks.preloaders.CircleSlicePreloader;
	
	import nl.michelvandersteege.transitions.BitmapdataTransitions;
	
	public class LanDakarFacebookTabManager 
	{
		/**
		 * @property
		 * Instancia de la clase, se instancia una unica vez (Singleton)
		 */
		private static var _instance:LanDakarFacebookTabManager = null;
		
		/**
		 * @property
		 * Controla la instanciacion de la clase
		 */
		private static var _allowInstantiation:Boolean; 
		
		/**
		 * @property
		 * Objeto responsable de cargas multiples de ficheros externos
		 */
		private var _bulkLoader:BulkLoader;
		
		/**
		 * @property
		 * Loader visual
		 */
		private var _loader_mc:MovieClip;		
		
		/**
		 * @property
		 * Variable de control para la seccion activa
		 */
		private var _idActiveSection:uint; 	
		
		/**
		 * @property
		 * Dia actual en que se ejecuta la aplicacion
		 */
		private var _actualDay:Date;
		private var _actualDayStr:String;
		
		/**
		 * @property
		 * Variables de textos de dia actual
		 */
		private var _actualQuestion:String;
		private var _actualSignal:String;
		private var _actualAnswer:String;
		
		/**
		 * @property
		 * Variables de control de la ventana modal de ganadores
		 */
		private var _totalWinners:uint;
		private var _totalWinnerPages:uint;
		private var _actualWinnerPage:uint
		private var _firstWinnerIndex:uint;
		private var _isWinnerModalWindowLoaded:Boolean;
		
		/**
		 * @property
		 * Objeto de datos correspondiente a la ventana modal actual
		 */
		private var _actualModalWindowVO:ModalWindowVO		
		
		/**
		 * @property
		 * Referencoa al objeto contenedor de variables externas enviadas desde el HTML/PHP
		 */
		private var _flashvars:Object;
		
		/**
		 * @property
		 * Referencia a funcion
		 */
		private var _bridgeFunction:Function;
		
		/**
		 * @property
		 * Referencia a funcion
		 */
		private var _reloadFunction:Function;
		
		/**
		 * @property
		 * Controla si la apicacion corre en el dominio de facebook
		 */
		public static const ACTIVE_URL_FACEBOOK:Boolean = true;	
		
		/**
		 * @property
		 * Loader visual
		 */
		private var _visualPreloader:CircleSlicePreloader;
		
		/**
		 * @property
		 * Referencia al stage de la pelicula principal
		 */
		private var _stage:Stage;
		
		/**
		 * @property
		 * Referencia al stage de la pelicula principal
		 */
		private var _winnerCounter:uint;
		
		/**
		 * @property
		 * Timer para control de formulario
		 */
		private var _timer:Timer;
		
		/**
		 * @constructor
		 * Constructor de la clase	 
		 */
		public function LanDakarFacebookTabManager(flashvars:Object)
		{
			trace("LanDakarFacebookTabManager->LanDakarFacebookTabManager()");
			
			if (!_allowInstantiation) {
				throw new Error("Error: Instanciación fallida: Use LanDakarFacebookTabManager.getInstance() para crar nuevas instancias.");
			} else {				
				
				// Agregando cualquier dominio para temas de seguridad de Flash Player
				if(LanDakarFacebookTabManager.ACTIVE_URL_FACEBOOK)
				{
					Security.allowInsecureDomain("*");
					Security.allowDomain("*");
				}
				
				// Inicializando propiedades
				_flashvars = flashvars;	
				_winnerCounter = 0
				_timer = new Timer(5*1000, 1);
				
				// Loader visual
				_visualPreloader = new CircleSlicePreloader();
				_visualPreloader.name = "friendmapVisualLoader_mc";
				_visualPreloader.scaleX = 1.5;
				_visualPreloader.scaleY = 1.5;
				
				// Obteniendo el dia de ejecucion de la aplicacion
				_actualDay = new Date();
				_actualDayStr = StringUtils.getDayByIndex(_actualDay.getDay());
				trace("Hoy es: " + _actualDayStr);
				
				// Inicializando objeto responsable de cargas multiples de ficheros externos
				_bulkLoader = new BulkLoader(TableDataManager.LAN_DAKAR_FACEBOOK_TAB_MANAGER);							
				
				// Inicializando variable de control de carga de la ventana modal de ganadores
				_isWinnerModalWindowLoaded = false;
				
				// Iniciando applicacion
				init();							
			}	
		}
		
		/**
		 * @PRIVATE METHODS
		 * Funciones privadas de la clase
		 */
		
		/**
		 * @method
		 * Inicializa la aplicacion 
		 */
		private function init():void
		{
			// Invisibilizando componentes			
			
			// MODAL PANEL
			/* kitar las dos proximas lineas
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanel.visible = false;
			*/
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanel.visible = !(StringUtils.stringToBoolean(_flashvars.invite) && StringUtils.stringToBoolean(_flashvars.isFan));
			
			// DATA FORM MODAL WINDOW
			var dataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH) as Component;				
			dataFormModalWindow.visible = false;	
			var dataFormModalWindow_mc:MovieClip = dataFormModalWindow.getChildAt(0) as MovieClip;	
			
			trace("dataFormModalWindow_mc: " + dataFormModalWindow_mc);
			trace("dataFormModalWindow_mc.sendButton: " + dataFormModalWindow_mc.sendButton);
			trace("(dataFormModalWindow_mc.sendButton.btn: " + dataFormModalWindow_mc.sendButton.btn);
			
			(dataFormModalWindow_mc.sendButton.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onDataFormSendButtonClickHandler);
						
			// GENERIC MODAL WINDOW
			var modalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH) as Component;
			modalWindow.visible = false;
			
			// WINNERS MODAL WINDOW
			var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
			winnersModalWindow.visible = false;					
			
			// WELCOME MODAL WINDOW
			/* kitar las dos proximas lineas
			var welcomeModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH) as Component;
			welcomeModalWindow.visible = false;
			*/
			var welcomeModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH) as Component;
			if(StringUtils.stringToBoolean(_flashvars.isFan))
				welcomeModalWindow.visible = !StringUtils.stringToBoolean(_flashvars.invite);
			else
				welcomeModalWindow.visible = false;
			((welcomeModalWindow.getChildAt(0) as MovieClip).button_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onWelcomeModalWindowClickHandler);	
			
			// FAN MODAL WINDOW
			/* kitar las dos proximas lineas
			var fanModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH) as Component;
			fanModalWindow.visible = false;
			*/
			var fanModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH) as Component;
			fanModalWindow.visible = !StringUtils.stringToBoolean(_flashvars.isFan);
			((fanModalWindow.getChildAt(0) as MovieClip).button_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onFanModalWindowClickHandler);
			
			// CONFIRM DATA FORM MODAL WINDOW
			var confirmDataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_CONFIRM_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			confirmDataFormModalWindow.visible = false;			
						
			// Cargando textos de la aplicacion en el lenguage correspondiente
			this.loadLanguageTextInComponents();
			
			// Seleccionando primera seccion en el menu
			var menu:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MENU_HASH) as Component;
			var menu_mc:MovieClip = menu.getChildAt(0) as MovieClip;			
			if(menu_mc != null) {
				(menu_mc.menuButton0_mc as MovieClip).gotoAndStop("selected");
				_idActiveSection = 0;
			}
			
			// IMAGE VIEWER
			
			var imageViewer:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_IMAGE_VIEWER_HASH) as Component;
			var imageViewer_mc:MovieClip = imageViewer.getChildAt(0) as MovieClip;				
			(imageViewer_mc.images as MovieClip).gotoAndStop(_actualDayStr + _flashvars.weekType);		
			if(StringUtils.stringToBoolean(_flashvars.invite) && StringUtils.stringToBoolean(_flashvars.isFan))
				imageViewer_mc.playTransition();
			
			// MENU
			
			// Configurando detectores de eventos
			(menu_mc.menuButton0_mc as MovieClip).id = 0;
			((menu_mc.menuButton0_mc as MovieClip).btn as SimpleButton).addEventListener(MouseEvent.CLICK, onMenuButtonClickHandler);
			
			(menu_mc.menuButton1_mc as MovieClip).id = 1;
			((menu_mc.menuButton1_mc as MovieClip).btn as SimpleButton).addEventListener(MouseEvent.CLICK, onMenuButtonClickHandler);
			
			(menu_mc.menuButton2_mc as MovieClip).id = 2;
			((menu_mc.menuButton2_mc as MovieClip).btn as SimpleButton).addEventListener(MouseEvent.CLICK, onMenuButtonClickHandler);
			
			// QUESTION PANEL
			
			// Obteniendo movieclip "questionPanel"
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			
			// Configurando detectores de eventos
			(questionPanel_mc.questionButton_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onQuestionButtonClickHandler);
			(questionPanel_mc.textDay_dtxt as TextField).addEventListener(FocusEvent.FOCUS_IN, onAnswerTextFieldFocusInHandler); 
			(questionPanel_mc.textDay_dtxt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onAnswerTextFieldFocusOutHandler); 
			(questionPanel_mc.textDay_dtxt as TextField).addEventListener(Event.CHANGE, onAnswerTextFieldChangeHandler); 
			
			// BUTTON GIFT SECTION
			var buttonGiftSectionComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BUTTON_GIFT_SECTION_HASH) as Component;
			var buttonGiftSection_mc:MovieClip = buttonGiftSectionComponent.getChildAt(0) as MovieClip;
			if(buttonGiftSection_mc != null)
				(buttonGiftSection_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onButtonGiftSectionClickHandler);	
			
			// Invisibilizando el Panel Azul
			var bluePanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BLUE_PANEL_HASH) as Component;
			bluePanel.visible = false;
		}
		
		/**
		 * @method
		 * Configura la interfaz en el idioma correspondiente
		 */
		private function loadLanguageTextInComponents():void
		{
			// MENU
			var menu:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MENU_HASH) as Component;
			var menu_mc:MovieClip = menu.getChildAt(0) as MovieClip;
			if(menu_mc != null) 
			{			
				((menu_mc.menuButton0_mc as MovieClip).text_dtxt as TextField).text = LanguageManager.getInstance().data.menu.button0Text;
				((menu_mc.menuButton1_mc as MovieClip).text_dtxt as TextField).text = LanguageManager.getInstance().data.menu.button1Text;
				((menu_mc.menuButton2_mc as MovieClip).text_dtxt as TextField).text = LanguageManager.getInstance().data.menu.button2Text;
			}
			
			// LEGAL TEXT
			var legalText:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_LEGAL_TEXT) as Component;
			var legalText_mc:MovieClip = legalText.getChildAt(0) as MovieClip;
			if(legalText_mc != null) 	
			{
				// Creando objeto de estilo
				var style:StyleSheet = new StyleSheet();	
				style.parseCSS("a{text-decoration:underline}");
				
				// Cambiando el estilo de la caja de texto para el mensaje
				(legalText_mc.text_dtxt as TextField).styleSheet = style;
				
				// Configurando detector de evento del texto HTML
				(legalText_mc.text_dtxt as TextField).addEventListener(TextEvent.LINK, onLegalTextLinkEventHandler);
				
				// Configurando texto del campo
				(legalText_mc.text_dtxt as TextField).text = LanguageManager.getInstance().data.legalText;
			}
	
			// TEXT GAME SECTION
			var textGameSection:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_TEXT_GAME_SECTION_HASH) as Component;
			var textGameSection_mc:MovieClip = textGameSection.getChildAt(0) as MovieClip;
			if(textGameSection_mc != null)
			{
				(textGameSection_mc.title_dtxt as TextField).htmlText = LanguageManager.getInstance().data.gameSection.titleText;
				(textGameSection_mc.subtitle_dtxt as TextField).htmlText = LanguageManager.getInstance().data.gameSection.subtitleText;
			}
			
			// BUTTON GIFT SECTION
			var buttonGiftSectionComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BUTTON_GIFT_SECTION_HASH) as Component;
			var buttonGiftSection_mc:MovieClip = buttonGiftSectionComponent.getChildAt(0) as MovieClip;
			if(buttonGiftSection_mc != null)
				(buttonGiftSection_mc.text_dtxt as TextField).text = LanguageManager.getInstance().data.giftSection.buttonText;				
			
			// QUESTION PANEL
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			(questionPanel_mc.signal_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.signalText;
			(questionPanel_mc.questionButton_mc.text_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.buttonText;			
			if(questionPanel_mc != null)
			{				
				switch(_actualDayStr)
				{
					case TableDataManager.MONDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.mondayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.mondaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.mondayAnswerPar;						
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.mondayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.mondaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.mondayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.mondaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.mondayAnswerImpar;						
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.mondayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.mondaySignalImpar;
						}
						
						break;
					
					case TableDataManager.TUESDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.tuesdayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.tuesdaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.tuesdayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.tuesdayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.tuesdaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.tuesdayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.tuesdaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.tuesdayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.tuesdayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.tuesdaySignalImpar;
						}

						break;
					
					case TableDataManager.WEDNESDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.wednesdayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.wednesdaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.wednesdayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.wednesdayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.wednesdaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.wednesdayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.wednesdaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.wednesdayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.wednesdayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.wednesdaySignalImpar;
						}
						
						break;
					
					case TableDataManager.THURSDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.thursdayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.thursdaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.thursdayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.thursdayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.thursdaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.thursdayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.thursdaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.thursdayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.thursdayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.thursdaySignalImpar;
						}
						
						break;
					
					case TableDataManager.FRIDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.fridayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.fridaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.fridayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.fridayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.fridaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.fridayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.fridaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.fridayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.fridayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.fridaySignalImpar;
						}
						
						break;
					
					case TableDataManager.SATURDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.saturdayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.saturdaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.saturdayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.saturdayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.saturdaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.saturdayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.saturdaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.saturdayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.saturdayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.saturdaySignalImpar;
						}
						
						break;
					
					case TableDataManager.SUNDAY:
						
						if(_flashvars.weekType == TableDataManager.PAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.sundayQuestionPar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.sundaySignalPar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.sundayAnswerPar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.sundayQuestionPar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.sundaySignalPar;
						}
						else if(_flashvars.weekType == TableDataManager.IMPAR)
						{
							_actualQuestion = LanguageManager.getInstance().data.questionPanel.sundayQuestionImpar;
							_actualSignal = LanguageManager.getInstance().data.questionPanel.sundaySignalImpar;
							_actualAnswer = LanguageManager.getInstance().data.questionPanel.sundayAnswerImpar;				
							(questionPanel_mc.textDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.sundayQuestionImpar;
							(questionPanel_mc.signalDay_dtxt as TextField).text = LanguageManager.getInstance().data.questionPanel.sundaySignalImpar;
						}
						
						break;
				}				
			}
			
			// WINNERS MODAL WINDOW
			var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
			var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
			if(winnersModalWindow_mc != null)
			{
				// Configurando textos
				(winnersModalWindow_mc.title_dtxt as TextField).text = LanguageManager.getInstance().data.winnersModalWindow.titleText;
				(winnersModalWindow_mc.subtitle_dtxt as TextField).text = LanguageManager.getInstance().data.winnersModalWindow.text;
				
				// Configurando ganadores
				var winnersByPage:uint = (winnersModalWindow_mc.winnerList_mc as MovieClip).numChildren;
				for(var i:uint = 0; i < winnersByPage; i++)
				{
					// Obteniendo ganador
					var winner:WinnerVO = DataModel.getInstance().winnerList[i] as WinnerVO;
					
					// Verificando existencia de ganadores
					if(winner != null) {
						(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).id = winner.id;
						(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).vo = winner;
						(winnersModalWindow_mc.winnerList_mc["item_" + i].name_dtxt as TextField).text = winner.name;
						(winnersModalWindow_mc.winnerList_mc["item_" + i].gift_dtxt as TextField).text = winner.gift;
						(winnersModalWindow_mc.winnerList_mc["item_" + i].date_dtxt as TextField).text = winner.date;
					} else { (winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).visible = false; }					
				}
			}
			
			// FAN MODAL WINDOW
			var fanModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH) as Component;
			var fanModalWindow_mc:MovieClip = fanModalWindow.getChildAt(0) as MovieClip;
			if(fanModalWindow_mc != null)
			{
				// Configurando textos
				trace(LanguageManager.getInstance().data.fanModalWindow.titleText);
				trace(LanguageManager.getInstance().data.fanModalWindow.text);
				trace(LanguageManager.getInstance().data.fanModalWindow.buttonText);
				(fanModalWindow_mc.title_dtxt as TextField).text = LanguageManager.getInstance().data.fanModalWindow.titleText;
				(fanModalWindow_mc.text_dtxt as TextField).htmlText = LanguageManager.getInstance().data.fanModalWindow.text;
				(fanModalWindow_mc.button_mc.text_dtxt as TextField).text = LanguageManager.getInstance().data.fanModalWindow.buttonText;
			}
			
			// WELCOME MODAL WINDOW
			var welcomeModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH) as Component;
			var welcomeModalWindow_mc:MovieClip = welcomeModalWindow.getChildAt(0) as MovieClip;
			if(welcomeModalWindow_mc != null)
			{
				// Configurando textos
				trace(LanguageManager.getInstance().data.welcomeModalWindow.titleText);
				trace(LanguageManager.getInstance().data.welcomeModalWindow.text);
				trace(LanguageManager.getInstance().data.welcomeModalWindow.buttonText);
				(welcomeModalWindow_mc.title_dtxt as TextField).text = LanguageManager.getInstance().data.welcomeModalWindow.titleText;
				(welcomeModalWindow_mc.text_dtxt as TextField).htmlText = LanguageManager.getInstance().data.welcomeModalWindow.text;
				(welcomeModalWindow_mc.button_mc.text_dtxt as TextField).text = LanguageManager.getInstance().data.welcomeModalWindow.buttonText;
			}
			
			// DATA FORM MODAL WINDOW
			var dataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			var dataFormModalWindow_mc:MovieClip = dataFormModalWindow.getChildAt(0) as MovieClip;
			if(dataFormModalWindow_mc != null)
			{
				// Configurando textos
				(dataFormModalWindow_mc.title_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.titleText;
				(dataFormModalWindow_mc.subtitle_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.subtitleText;
				(dataFormModalWindow_mc.name_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.nameText;
				(dataFormModalWindow_mc.lastname_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.lastnameText;
				(dataFormModalWindow_mc.email_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.emailText;
				(dataFormModalWindow_mc.phone_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.phoneText;
				(dataFormModalWindow_mc.dni_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.dniText;
				(dataFormModalWindow_mc.street_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.streetText;
				(dataFormModalWindow_mc.number_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.numberText;
				(dataFormModalWindow_mc.floor_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.floorText;
				(dataFormModalWindow_mc.letter_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.letterText;
				(dataFormModalWindow_mc.zp_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.zpText;
				(dataFormModalWindow_mc.poblation_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.poblationText;
				(dataFormModalWindow_mc.state_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.stateText;
				(dataFormModalWindow_mc.privacyPolicy_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.privacyPolicyText;
				(dataFormModalWindow_mc.sendButton.text_dtxt as TextField).text = LanguageManager.getInstance().data.dataFormModalWindow.sendButtonText;
			}
			
			// CONFIRM DATA FORM MODAL WINDOW
			var confirmDataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_CONFIRM_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			var confirmDataFormModalWindow_mc:MovieClip = confirmDataFormModalWindow.getChildAt(0) as MovieClip;
			if(confirmDataFormModalWindow_mc != null)
			{
				// Configurando textos
				trace(LanguageManager.getInstance().data.confirmDataFormModalWindow.titleText);
				trace(LanguageManager.getInstance().data.confirmDataFormModalWindow.text);
				(confirmDataFormModalWindow_mc.title_dtxt as TextField).text = LanguageManager.getInstance().data.confirmDataFormModalWindow.titleText;
				(confirmDataFormModalWindow_mc.text_dtxt as TextField).htmlText = LanguageManager.getInstance().data.confirmDataFormModalWindow.text;
			}
		}
		
		/**
		 * @method
		 * Verifica si la respuesta escrita por el usuario es correcta
		 */
		private function verifyAnswer():void
		{
			// Obteniendo componente y respuesta del usuario
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			var userAnswer:String;
			if(questionPanel_mc != null)			
				if((questionPanel_mc.textDay_dtxt as TextField).text != "")
					userAnswer = (questionPanel_mc.textDay_dtxt as TextField).text;
			
			// Verificando si el texto del campo de respuesta es igual a la pregunta, entonces el usuario no ha respondido nada
			if(userAnswer == _actualQuestion)
				userAnswer = "";
			
			// Proceso de reemplazo de tildes
			
			// Spanish
			if(userAnswer.indexOf("á"))
				userAnswer = userAnswer.replace("á", "a");
			if(userAnswer.indexOf("é"))
				userAnswer = userAnswer.replace("é", "e");
			if(userAnswer.indexOf("í"))
				userAnswer = userAnswer.replace("í", "i");
			if(userAnswer.indexOf("ó"))
				userAnswer = userAnswer.replace("ó", "o");
			if(userAnswer.indexOf("ú"))
				userAnswer = userAnswer.replace("ú", "u");			
			if(userAnswer.indexOf("Á"))
				userAnswer = userAnswer.replace("Á", "a");
			if(userAnswer.indexOf("É"))
				userAnswer = userAnswer.replace("É", "e");
			if(userAnswer.indexOf("Í"))
				userAnswer = userAnswer.replace("Í", "i");
			if(userAnswer.indexOf("Ó"))
				userAnswer = userAnswer.replace("Ó", "o");
			if(userAnswer.indexOf("Ú"))
				userAnswer = userAnswer.replace("Ú", "u");
			
			// French
			if(userAnswer.indexOf("â"))
				userAnswer = userAnswer.replace("â", "a");
			if(userAnswer.indexOf("ê"))
				userAnswer = userAnswer.replace("ê", "e");
			if(userAnswer.indexOf("î"))
				userAnswer = userAnswer.replace("î", "i");
			if(userAnswer.indexOf("ô"))
				userAnswer = userAnswer.replace("ô", "o");
			if(userAnswer.indexOf("û"))
				userAnswer = userAnswer.replace("û", "u");			
			if(userAnswer.indexOf("Â"))
				userAnswer = userAnswer.replace("Â", "a");
			if(userAnswer.indexOf("Ê"))
				userAnswer = userAnswer.replace("Ê", "e");
			if(userAnswer.indexOf("Î"))
				userAnswer = userAnswer.replace("Î", "i");
			if(userAnswer.indexOf("Ô"))
				userAnswer = userAnswer.replace("Ô", "o");
			if(userAnswer.indexOf("Û"))
				userAnswer = userAnswer.replace("Û", "u");
			
			if(userAnswer.indexOf("à"))
				userAnswer = userAnswer.replace("à", "a");
			if(userAnswer.indexOf("è"))
				userAnswer = userAnswer.replace("è", "e");
			if(userAnswer.indexOf("ì"))
				userAnswer = userAnswer.replace("ì", "i");
			if(userAnswer.indexOf("ò"))
				userAnswer = userAnswer.replace("ò", "o");
			if(userAnswer.indexOf("ù"))
				userAnswer = userAnswer.replace("ù", "u");			
			if(userAnswer.indexOf("À"))
				userAnswer = userAnswer.replace("À", "a");
			if(userAnswer.indexOf("È"))
				userAnswer = userAnswer.replace("È", "e");
			if(userAnswer.indexOf("Ì"))
				userAnswer = userAnswer.replace("Ì", "i");
			if(userAnswer.indexOf("Ò"))
				userAnswer = userAnswer.replace("Ò", "o");
			if(userAnswer.indexOf("Ù"))
				userAnswer = userAnswer.replace("Ù", "u");
			
			// Haciendo busqueda de la cadena de respuesta correcta en la respuesta del usuario			
			trace("La respuesta correcta es: " + _actualAnswer);
			trace("La respuesta del usuario es: " + userAnswer);
			var indexResult:int = userAnswer.toLowerCase().indexOf(_actualAnswer.toLowerCase());
			trace("indexResult: " + indexResult)
			if(indexResult != -1)
				this.confirmWinnerTime();
			else
				this.wrongAnswer();
		}					
		
		/**
		 * @method
		 * Confirma que el momento de la respuesta sea un momento ganador
		 */
		private function confirmWinnerTime():void
		{
			trace("LanDakarFacebookTabManager->confirmWinnerTime()");				
			
			/*
			(console as TextField).appendText(flashvars.access_token);
			(console as TextField).appendText(flashvars.url);
			(console as TextField).appendText(flashvars.participation);
			(console as TextField).appendText(flashvars.language);
			(console as TextField).appendText(flashvars.invite);
			*/
			
			// Enviando variable al servicio PHP para aumentar votacion del caso
			var urlVars:URLVariables = new URLVariables();
			urlVars.access_token = _flashvars.access_token;
			urlVars.lang = _flashvars.language;
			
			// Opciones del servicio PHP
			var urlPHPServiceRequest:URLRequest = new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_WINNER_MOMENT_PHP_SERVICE);
			urlPHPServiceRequest.method = URLRequestMethod.POST;
			urlPHPServiceRequest.data = urlVars;
			
			// Enviando datos al servicio
			var urlLoaderPHPService:URLLoader = new URLLoader();
			urlLoaderPHPService.dataFormat = URLLoaderDataFormat.VARIABLES;
			urlLoaderPHPService.load(urlPHPServiceRequest);
			urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendPHPServiceComplete);
			urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);
		}			
		
		private function onSendPHPServiceComplete(evt:Event):void
		{
			trace("evt.target.data: " + evt.target.data);			
			var loader:URLLoader = URLLoader(evt.target);

			try
			{
				// Verificando respuesta del servicio PHP
				if(StringUtils.stringToBoolean(loader.data.success)) 
					this.winner(loader.data);
				else 
					this.rightAnswer();		
			}
			catch(e:Error)
			{
				var msg:String = "";
				msg += "loader.data.success: " + loader.data.success + "\n" +
					   "loader.data.gift: " + loader.data.gift;
				throw new Error(msg);
			}
		}
		
		private function onSendPHPServiceError(evt:Event):void {
			throw new Error("Respuesta del servicio PHP: " + evt.toString());
		}
		
		/**
		 * @method
		 * Muestra la ventana modal con mensaje de error
		 */
		private function wrongAnswer():void
		{
			trace("LanDakarFacebookTabManager->wrongAnswer()");
			_actualModalWindowVO = LanguageManager.getInstance().data.failureModalWindow;
			this.showModalWindow(_actualModalWindowVO);
		}
		
		/**
		 * @method
		 * Muestra la ventana modal con mensaje de acierto pero sin premio
		 */
		private function rightAnswer():void
		{
			trace("LanDakarFacebookTabManager->rightAnswer()");
			trace("No te ha tocado premio");
			_actualModalWindowVO = LanguageManager.getInstance().data.rightAnswerModalWindow;
			this.showModalWindow(_actualModalWindowVO);
		}
		
		/**
		 * @method
		 * Muestra la ventana modal con premio
		 */
		private function winner(data:*):void
		{
			trace("LanDakarFacebookTabManager->winner()");
			_actualModalWindowVO = LanguageManager.getInstance().data.successModalWindow;
			this.showModalWindow(_actualModalWindowVO, data);
		}
		
		/**
		 * @method
		 * Muestra la ventana modal y actualiza los datos en dependencia de la situacion
		 */
		private function showModalWindow(modalWindowVO:ModalWindowVO, data:* = null):void
		{
			// Obteniendo GenericModalWindow
			var modalPanelComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanelComponent.visible = true;
			
			// Obteniendo GenericModalWindow
			var genericModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH) as Component;
			genericModalWindow.visible = true;
			var genericModalWindow_mc:MovieClip = genericModalWindow.getChildAt(0) as MovieClip;	
			if(genericModalWindow_mc != null) 
			{
				// Creando objeto de estilo
				var style:StyleSheet = new StyleSheet();	
				style.parseCSS("a{text-decoration:underline;color:#B00F1E}");
				
				// Cambiando el estilo de la caja de texto para el mensaje
				(genericModalWindow_mc.text_dtxt as TextField).styleSheet = style;
				
				// Configurando detectores de eventos
				(genericModalWindow_mc.text_dtxt as TextField).addEventListener(TextEvent.LINK, onTextLinkEventHandler);
				(genericModalWindow_mc.button_mc.btn as SimpleButton).addEventListener(MouseEvent.CLICK, onModalWindowButtonClickHandler);
				(genericModalWindow_mc.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onCloseModalWindowHandler);
				
				// Adicionando textos a los campos
				(genericModalWindow_mc.title_dtxt as TextField).text = modalWindowVO.titleText;
				
				// Adicionando textos a los componentes
				var modalWindowText:String = modalWindowVO.text;
				if(data != null)
					modalWindowText = modalWindowText.replace("$GIFT", data.gift);
				
				(genericModalWindow_mc.text_dtxt as TextField).htmlText = modalWindowText;
				
				if(modalWindowVO.buttonText != "") {
					(genericModalWindow_mc.button_mc.text_dtxt as TextField).text = modalWindowVO.buttonText;
				} else {
					(genericModalWindow_mc.button_mc as MovieClip).visible = false;
				}
				
				// Si la ventana modal es la de ganador, iniar timer para relleno de formulario
				if(modalWindowVO.hash == TableDataManager.COMPONENT_SUCCESS_MODAL_WINDOW_HASH)
				{
					// Eliminando detectores de eventos anteriores
					if(_timer.hasEventListener(TimerEvent.TIMER))
						_timer.removeEventListener(TimerEvent.TIMER, onTimerEventHandler);
					
					// Configurando detector de eventos
					_timer.addEventListener(TimerEvent.TIMER, onTimerEventHandler);
					
					// Iniciando timer
					_timer.start();
				}
			}			
		}
		
		/**
		 * @method
		 * Cierra la ventana modal
		 */
		private function closeModalWindow():void
		{
			trace("Cerrando la ventana modal");
			
			// Obteniendo GenericModalWindow
			var modalPanelComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanelComponent.visible = false;
			
			// Verificando ventana modal activa
			switch(_actualModalWindowVO.hash)
			{
				case TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH:
					var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
					winnersModalWindow.visible = false;					
					break;
				
				case TableDataManager.COMPONENT_SUCCESS_MODAL_WINDOW_HASH:
				case TableDataManager.COMPONENT_FAILURE_MODAL_WINDOW_HASH:
					// Obteniendo GenericModalWindow
					var genericModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH) as Component;
					genericModalWindow.visible = false;
					var genericModalWindow_mc:MovieClip = genericModalWindow.getChildAt(0) as MovieClip;	
					if(genericModalWindow_mc != null) 
					{
						// Configurando detectores de eventos
						(genericModalWindow_mc.text_dtxt as TextField).removeEventListener(TextEvent.LINK, onTextLinkEventHandler);
						(genericModalWindow_mc.button_mc.btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onModalWindowButtonClickHandler);
						(genericModalWindow_mc.close_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onCloseModalWindowHandler);
						
						// Adicionando textos a los campos
						(genericModalWindow_mc.title_dtxt as TextField).text = "";
						(genericModalWindow_mc.text_dtxt as TextField).htmlText = "";
						(genericModalWindow_mc.button_mc.text_dtxt as TextField).text = "";
					}
					break;
				
				default:
					throw new Error("Identificado de ventana modal desconocido: " + _actualModalWindowVO.hash);
			}	
		}
		
		/**
		 * @method
		 * Cambia de una seccion a otra
		 * 
		 * @param 	oldSectionID	Identificador de la seccion actual
		 * @param 	newSectionID	Identificador de la nueva seccion
		 */
		private function changeSeccion(oldSectionID:uint, newSectionID:uint):void
		{
			this.updateSection(oldSectionID, false);
			this.updateSection(newSectionID, true);			
		
			// Actualizando id de la seccion actual
			_idActiveSection = newSectionID;
		}
		
		/**
		 * @method
		 * Actualiza la visibilidad de la seccion correspondiente
		 * 
		 * @param	sectionID		Identificador de la seccion
		 * @param 	visibility		Valor de visibilidad para los componentes de la seccion 
		 */
		private function updateSection(sectionID:uint, visibility:Boolean):void
		{
			// Deshabilitando componentes de la seccion activa
			var bgGameSectionComponent:Component = null;
			var bgGiftSectionComponent:Component = null;
			
			switch(sectionID)
			{
				case 0:		// GAME SECTION
					
					// Obteniendo componentes
					bgGameSectionComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BG_GAME_SECTION_HASH) as Component;
					bgGiftSectionComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BG_GIFT_SECTION_HASH) as Component;					
					
					var textGameSection:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_TEXT_GAME_SECTION_HASH) as Component;
					var imageViewerComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_IMAGE_VIEWER_HASH) as Component;
					var questionPanelComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
					
					// Invisibilizando componentes
					bgGameSectionComponent.visible = visibility;
					bgGiftSectionComponent.visible = !visibility;
					textGameSection.visible = visibility;
					imageViewerComponent.visible = visibility;
					questionPanelComponent.visible = visibility;
					
					break;
				
				case 1:		// GIFT SECTION
					
					// Obteniendo componentes
					bgGameSectionComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BG_GAME_SECTION_HASH) as Component;
					bgGiftSectionComponent = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BG_GIFT_SECTION_HASH) as Component;					
														
					var buttonGiftSectionComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_BUTTON_GIFT_SECTION_HASH) as Component;
					
					// Invisibilizando componentes
					bgGameSectionComponent.visible = !visibility;
					bgGiftSectionComponent.visible = visibility;	
					buttonGiftSectionComponent.visible = visibility;
					
					break;
				
				case 2:					
					
					break;
				
				default:
					throw new Error("Seccion desconoida: " + _idActiveSection);
			}			
		}
		
		/**
		 * @method
		 * Asigna a los componentes de ganadores sus respectivas imagenes
		 */
		private function showWinnerImages():void
		{
			trace("LanDakarFacebookTabManager->showWinnerImages()");
			
			try
			{
				// Obteniendo ModalPanel
				var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
				modalPanel.visible = true;
				
				// WINNERS MODAL WINDOW
				var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
				var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
				if(winnersModalWindow_mc != null)
				{
					// Configurando ganadores
					var winnersByPage:uint = (winnersModalWindow_mc.winnerList_mc as MovieClip).numChildren;
					for(var i:uint = 0; i < winnersByPage; i++)
					{
						// Obteniendo ganador
						var winner:WinnerVO = DataModel.getInstance().winnerList[i] as WinnerVO;
						
						// Verificando existencia de ganadores
						if(winner != null) 
						{
							// Asignando imagen al ganador
							//(winnersModalWindow_mc.winnerList_mc["item_" + i].imageContainer_mc as MovieClip).addChild(winner.loader);
							//(winnersModalWindow_mc.winnerList_mc["item_" + i].imageContainer_mc as MovieClip).addChild(winner.bitmap);
						} else {
							(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).visible = false;
						}
					}
					
					// Haciendo visible el componente
					winnersModalWindow.visible = true;
				}	
				
			} catch(e:Error) {throw new Error("winner.bitmap: " + winner.bitmap + "\n" + e.toString()); }			
		}
		
		/**
		 * @method
		 * Muestra en pantalla dialogo que indica que se esta cargando un contenido externo		
		 */
		private function showLoader():void 
		{			
			// Obteniendo ModalPanel
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanel.visible = true;
			
			// Obteniendo Loader
			if(_loader_mc != null) 
			{			
				// Reiniciando barra de precarga del loader		
				_loader_mc.bar_mc.gotoAndStop(0);			
				
				// Realizando animacion del objeto de loading visual				
				_loader_mc.alpha = 0;	
				Tweener.addTween(_loader_mc, {alpha:1, time:1, transition:"easeOutCubic"});
				Tweener.addTween(_loader_mc, { x:_loader_mc.x, y:_loader_mc.y - 40, time:1, transition:"easeOutCubic"});
			}
		}		
		
		/**
		 * @method
		 * Elimina de pantalla dialogo que indica que se esta cargando un contenido externo		
		 */
		private function hideLoader():void 
		{
			// Obteniendo ModalPanel
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			
			// Obteniendo Loader
			if(_loader_mc != null) 
			{
				// Realizando animacion del objeto de loader visual			
				Tweener.addTween(_loader_mc, {alpha:0, time:1, transition:"easeOutCubic"});
				Tweener.addTween(_loader_mc, {x:_loader_mc.x, y:_loader_mc.y + 40, time:1, transition:"easeOutCubic"} );
				modalPanel.visible = false;	
			}
		}
		
		
		/**
		 * @method
		 * Muestra en pantalla el loader visual que indica que se esta cargando un contenido externo		
		 */
		public function showAppleVisualLoader():void
		{
			// Obteniendo ModalPanel
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			modalPanel.visible = true;
			
			// Obteniendo Loader
			if(_visualPreloader != null) 
			{		
				// Posicionando loader
				_visualPreloader.x = _stage.stageWidth / 2;
				_visualPreloader.y = _stage.stageHeight / 2;			
				_stage.addChild(_visualPreloader);			
				
				// Realizando animacion del objeto de loading visual				
				_visualPreloader.alpha = 0;	
				Tweener.addTween(_visualPreloader, {alpha:1, time:1, transition:"easeOutCubic"});
				Tweener.addTween(_visualPreloader, { x:_visualPreloader.x, y:_visualPreloader.y - 40, time:1, transition:"easeOutCubic"});
			}
		}
		
		/**
		 * @method
		 * Elimina de pantalla el loader visual que indica que se esta cargando un contenido externo		
		 */
		private function hideAppleVisualLoader():void 
		{
			// Obteniendo ModalPanel
			var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
			
			// Obteniendo Loader
			if(_visualPreloader != null) 
			{
				// Realizando animacion del objeto de loader visual			
				Tweener.addTween(_visualPreloader, {alpha:0, time:1, transition:"easeOutCubic"});
				Tweener.addTween(_visualPreloader, {x:_visualPreloader.x, y:_visualPreloader.y + 40, time:1, transition:"easeOutCubic"} );
				modalPanel.visible = false;	
			}
		}
		
		/**
		 * @method
		 * Configura la paginacion en la ventana modal de ganadores	
		 */
		private function configInitPaginationWinnerModalWindow():void 
		{
			// Variables locales
			var winnersModalWindow:Component = null;
			var winnersModalWindow_mc:MovieClip = null;
			var paginator_mc:MovieClip = null;
			
			// Obteniendo cantidad de ganadores
			_totalWinners = DataModel.getInstance().winnerList.length;
			trace("Cantidad de ganadores: " + _totalWinners);
			
			// Si la cantidad de ganadores es menor que 9 no se necesita paginador
			/*
			if(_totalWinners <= 6)
			{
				// WINNERS MODAL WINDOW
				winnersModalWindow = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
				winnersModalWindow_mc = winnersModalWindow.getChildAt(0) as MovieClip;
				if(winnersModalWindow_mc != null)
				{
					// Obteniendo paginador visual
					paginator_mc = winnersModalWindow_mc.paginator_mc as MovieClip;
					paginator_mc.visible = true;
				}
			}
			else*/ 
			/*if(_totalWinners > 6)
			{*/
				// Calculando cantidad de paginas
				_totalWinnerPages = Math.ceil(_totalWinners / 6);
				trace("Paginas totales de ganadores: " + _totalWinnerPages);
				
				// Actualizando variables de control
				_actualWinnerPage = 1;
				_firstWinnerIndex = 0;
				
				// WINNERS MODAL WINDOW
				winnersModalWindow = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
				winnersModalWindow_mc = winnersModalWindow.getChildAt(0) as MovieClip;
				if(winnersModalWindow_mc != null)
				{
					// Obteniendo paginador visual
					paginator_mc = winnersModalWindow_mc.paginator_mc as MovieClip;
					if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
						(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.SPANISH_PAGE + _actualWinnerPage + TableDataManager.SPANISH_OF + _totalWinnerPages;
					else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
						(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.FRENCH_PAGE + _actualWinnerPage + TableDataManager.FRENCH_OF + _totalWinnerPages;
					
					if(_actualWinnerPage < _totalWinnerPages)
					{
						// Inhabilitar el boton de PREV PAGE
						(paginator_mc.prev_btn as SimpleButton).enabled = false;
						
						// Configurando detectores de eventos
						(paginator_mc.next_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onNextButtonPaginatorClickHandler);
						// No se configura detector de eventos porque el paginador se encuentra en la primera pagina
					}
					else
					{
						// Inhabilitar botones del navegador
						(paginator_mc.next_btn as SimpleButton).enabled = false;
						(paginator_mc.prev_btn as SimpleButton).enabled = false;
						
						// Eliminando detectores de eventos
						if((paginator_mc.next_btn as SimpleButton).hasEventListener(MouseEvent.CLICK))
							(paginator_mc.next_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onNextButtonPaginatorClickHandler);
						
						if((paginator_mc.prev_btn as SimpleButton).hasEventListener(MouseEvent.CLICK))
							(paginator_mc.prev_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onPrevButtonPaginatorClickHandler);
					}
				}
			//}
		}
		
		/**
		 * @method
		 * Muestra la siguiente pagina de ganadores
		 */
		private function nextWinnerPage():void 
		{
			trace("LanDakarFacebookTabManager->nextWinnerPage()");
			
			// WINNERS MODAL WINDOW
			var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
			var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
			if(winnersModalWindow_mc != null)
			{
				// Actualizando variables de control
				_actualWinnerPage++;
				_firstWinnerIndex += 6;
				
				// Cargando datos de ganadores de la siguiente pagina
				this.loadWinnerData(_firstWinnerIndex);
				
				// Obteniendo paginador visual
				var paginator_mc = winnersModalWindow_mc.paginator_mc as MovieClip;
				if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
					(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.SPANISH_PAGE + _actualWinnerPage + TableDataManager.SPANISH_OF + _totalWinnerPages;
				else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
					(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.FRENCH_PAGE + _actualWinnerPage + TableDataManager.FRENCH_OF + _totalWinnerPages;
				
				// Siempre que se pagina hacia delante se deja una pagina detras
				(paginator_mc.prev_btn as SimpleButton).enabled = true;
				(paginator_mc.prev_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onPrevButtonPaginatorClickHandler);
				
				// Verificando si tiene pagina siguiente
				var existNextPage:Boolean = (_actualWinnerPage < _totalWinnerPages);
				if(!existNextPage) {
					(paginator_mc.next_btn as SimpleButton).enabled = false;
					(paginator_mc.next_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onNextButtonPaginatorClickHandler);
				}
			}					
		}
		
		/**
		 * @method
		 * Muestra la anterior pagina de ganadores
		 */
		private function prevWinnerPage():void 
		{
			trace("LanDakarFacebookTabManager->prevWinnerPage()");
			
			// WINNERS MODAL WINDOW
			var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
			var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
			if(winnersModalWindow_mc != null)
			{
				// Actualizando variables de control
				_actualWinnerPage--;
				_firstWinnerIndex = 0;
				
				// Cargando datos de ganadores de la siguiente pagina
				this.loadWinnerData(_firstWinnerIndex);
				
				// Obteniendo paginador visual
				var paginator_mc = winnersModalWindow_mc.paginator_mc as MovieClip;
				if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
					(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.SPANISH_PAGE + _actualWinnerPage + TableDataManager.SPANISH_OF + _totalWinnerPages;
				else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
					(paginator_mc.text_dtxt as TextField).htmlText = TableDataManager.FRENCH_PAGE + _actualWinnerPage + TableDataManager.FRENCH_OF + _totalWinnerPages;
								
				// Siempre que se pagina hacia detras se deja una pagina delante
				(paginator_mc.next_btn as SimpleButton).enabled = true;
				(paginator_mc.next_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onNextButtonPaginatorClickHandler);

				// Verificando si tiene pagina anterior
				var existPrevPage:Boolean = (_actualWinnerPage > 1);
				if(!existPrevPage) {
					(paginator_mc.prev_btn as SimpleButton).enabled = false;
					(paginator_mc.prev_btn as SimpleButton).removeEventListener(MouseEvent.CLICK, onPrevButtonPaginatorClickHandler);
				}
			}
		}
		
		/**
		 * @method
		 * Carga los datos de los ganadores
		 * 
		 * @param	index	Indice a partir del cual se cargan 9 ganadores si los hay, y sino se cargan los que haya desde este indice hasta el final
		 */
		private function loadWinnerData(index:uint):void
		{
			// Verificando si el indice esta en el rango de la lista de ganadores
			if(index >= 0 && index < DataModel.getInstance().winnerList.length)
			{				
				// WINNERS MODAL WINDOW
				var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
				var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
				if(winnersModalWindow_mc != null)
				{				
					// Recorro la lista de ganadores a partir del indice indicado
					var winnersByPage:uint = (winnersModalWindow_mc.winnerList_mc as MovieClip).numChildren;
					for(var i:uint = 0; (i < winnersByPage) && (index < DataModel.getInstance().winnerList.length); i++)
					{
						// Obteniendo ganador
						var winner:WinnerVO = DataModel.getInstance().winnerList[index] as WinnerVO;
						
						if(ACTIVE_URL_FACEBOOK)
						{
							// Verificando existencia de ganadores
							if(winner != null) 
							{
								index++;
								(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).visible = true;
								(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).id = winner.id;
								(winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).vo = winner;
								(winnersModalWindow_mc.winnerList_mc["item_" + i].name_dtxt as TextField).text = winner.name;
								(winnersModalWindow_mc.winnerList_mc["item_" + i].gift_dtxt as TextField).text = winner.gift;
								(winnersModalWindow_mc.winnerList_mc["item_" + i].imageContainer_mc as MovieClip).removeChildAt(0);
								(winnersModalWindow_mc.winnerList_mc["item_" + i].imageContainer_mc as MovieClip).addChild(winner.loader);
							}	
						}
					}
					
					// Invisibilizando los ultimos componentes de la pagina
					var winnerItem_mc:MovieClip = null; 
					for(var j:uint = i; j < winnersByPage; j++) {
						winnerItem_mc = winnersModalWindow_mc.winnerList_mc["item_" + j] as MovieClip;
						winnerItem_mc.visible = false;
					}
					
				} else { throw new Error("Indice de ganador fuera de rango."); }	
			}
		}
			
		
		/**
		 * @PUBLIC METHODS
		 * Funciones publicas de la clase
		 */
		
		/**
		 * @method
		 * Devuelve la unica instancia de la clase LanDakarFacebookTabManager
		 * 
		 * @return	instancia	Unica instancia de la clase LanDakarFacebookTabManager 	
		 */
		public static function getInstance(flashvars:Object = null):LanDakarFacebookTabManager 
		{
			if (_instance == null) 
			{
				_allowInstantiation = true;
				_instance = new LanDakarFacebookTabManager(flashvars);
				_allowInstantiation = false;
			}
			return _instance;
		}
		
		/**
		 * @method
		 * Obtiene referencia al loader visual de la pelicula principal
		 */
		public function setLoader(loader:MovieClip):void {
			_loader_mc = loader;
		}
		
		/**
		 * @method
		 * Obtiene referencia al stage de la pelicula principal
		 */
		public function setStage(stage:Stage):void {
			_stage = stage;
		}
		
		/**
		 * @method
		 * Obtiene referencia a la funcion de comunicacion entre AS3 y Javascript en Facebook
		 */
		public function setFacebookBridge(func:Function):void {
			_bridgeFunction = func;
		}
		
		/**
		 * @method
		 * Obtiene referencia a la funcion de comunicacion entre AS3 y Javascript en Facebook
		 */
		public function setReloadBridge(func:Function):void {
			_reloadFunction = func;
		}

		/**
		 * @EVENTS
		 * Funciones que responden a eventos de la clase
		 */
		
		/**
		 * @event
		 * Ejecuta acciones al hacer click sobre un elemento del menu
		 */
		public function onMenuButtonClickHandler(evt:MouseEvent):void 
		{
			// Obteniendo el id de la seccion clickada
			var idSectionClicked:uint = (evt.target.parent as MovieClip).id;
			
			if(idSectionClicked != 2)
			{
				// Verificando que la seccion clickada no sea la seccion actual
				if(idSectionClicked != _idActiveSection) 
				{
					// Seleccionando primera seccion en el menu
					var menu:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MENU_HASH) as Component;
					var menu_mc:MovieClip = menu.getChildAt(0) as MovieClip;			
					if(menu_mc != null) 
					{
						// Desactivando seccion actual
						(menu_mc["menuButton" + _idActiveSection +"_mc"] as MovieClip).gotoAndStop("up");					
						
						// Cambiando de seccion
						(menu_mc["menuButton" + idSectionClicked +"_mc"] as MovieClip).gotoAndStop("selected");
						
						// Cambiando de seccion
						this.changeSeccion(_idActiveSection, idSectionClicked);
					}
				}	
			}
			else
			{
				if(ACTIVE_URL_FACEBOOK)
					_bridgeFunction.call();
			}
		}
		
		/**
		 * @event
		 * Ejecuta acciones al hacer click sobre el boton del "QuestionPanel"
		 */
		public function onQuestionButtonClickHandler(evt:MouseEvent):void {
			this.verifyAnswer();	
		}
		
		/**
		 * @event
		 * Ejecuta acciones al posicionar el cursor sobre el campo de texto de respuesta
		 */
		public function onAnswerTextFieldFocusInHandler(evt:Event):void 
		{
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			if(questionPanel_mc != null)			
				if((questionPanel_mc.textDay_dtxt as TextField).text == _actualQuestion)
					(questionPanel_mc.textDay_dtxt as TextField).text = "";	
		}
		
		/**
		 * @event
		 * Ejecuta acciones al posicionar el cursor fuera del campo de texto de respuesta
		 */
		public function onAnswerTextFieldFocusOutHandler(evt:Event):void 
		{
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			if(questionPanel_mc != null)		
				if((questionPanel_mc.textDay_dtxt as TextField).text == "")
					(questionPanel_mc.textDay_dtxt as TextField).text = _actualQuestion;							
											
		}
		
		/**
		 * @event
		 * Ejecuta acciones al cambiar el texto del campo de texto de respuesta
		 */
		public function onAnswerTextFieldChangeHandler(evt:Event):void 
		{
			var questionPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_QUESTION_PANEL_HASH) as Component;
			var questionPanel_mc:MovieClip = questionPanel.getChildAt(0) as MovieClip;
			if(questionPanel_mc != null) 
			{		
				if((questionPanel_mc.textDay_dtxt as TextField).text == "") {
					this.onAnswerTextFieldFocusOutHandler(null);	
				} else {
					var cursorIndex:uint = (questionPanel_mc.textDay_dtxt as TextField).caretIndex;
					if((questionPanel_mc.textDay_dtxt as TextField).length > cursorIndex) {
						var userText:String = (questionPanel_mc.textDay_dtxt as TextField).text.substr(0, cursorIndex);
						(questionPanel_mc.textDay_dtxt as TextField).text = userText;
					}
				} 
			}		
		}
		
		/**
		 * @event
		 * Ejecuta acciones cuando se captura el evento de link sobre texto HTML
		 */
		private function onTextLinkEventHandler(evt:TextEvent):void
		{
			trace("LanDakarFacebookTabManager->onTextLinkEventHandler()");						
			switch(_actualModalWindowVO.hash)
			{
				case TableDataManager.COMPONENT_RIGHT_MODAL_WINDOW_HASH:
				case TableDataManager.COMPONENT_FAILURE_MODAL_WINDOW_HASH:
					if(ACTIVE_URL_FACEBOOK)
						_reloadFunction.call();
					break;
				
				case TableDataManager.COMPONENT_SUCCESS_MODAL_WINDOW_HASH:					
					_timer.stop();
					var succesModalWindowComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_GENERIC_MODAL_WINDOW_HASH) as Component;
					succesModalWindowComponent.visible = false;
					showDataFormModalWindow();					
					break;
				
				default:
					throw new Error("Ventana Modal con ID desconocido");
			}
		}
		
		public function showDataFormModalWindow():void
		{
			// Visualizando componentes
			var dataFormModalWindowComponent:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			dataFormModalWindowComponent.visible = true;
		}
		
		public function dataFormFieldError():void
		{
			// TODO: Codigo para cuando se recibe un false despues de haber enviado los datos del formulario al servidor 
		}
		
		public function showConfirmDataFormModalWindow():void
		{
			var confirmDataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_CONFIRM_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			confirmDataFormModalWindow.visible = true;
		}
		
		public function verifyAllFieldDataForm():Boolean
		{
			var dataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			var dataFormModalWindow_mc:MovieClip = dataFormModalWindow.getChildAt(0) as MovieClip;
			if(dataFormModalWindow_mc != null)
			{
				// Verificando que ningun campo este vacio
				if(dataFormModalWindow_mc.name_itxt.text == "" || dataFormModalWindow_mc.lastname_itxt.text == "" ||
				   dataFormModalWindow_mc.email_itxt.text == "" ||	dataFormModalWindow_mc.phone_itxt.text == "" || 
				   dataFormModalWindow_mc.dni_itxt.text == "" || dataFormModalWindow_mc.street_itxt.text == "" || 
				   dataFormModalWindow_mc.number_itxt.text == "" || dataFormModalWindow_mc.floor_itxt.text == "" || 
				   dataFormModalWindow_mc.letter_itxt.text == "" || dataFormModalWindow_mc.zp_itxt.text == "" || 
				   dataFormModalWindow_mc.poblation_itxt.text == "" || dataFormModalWindow_mc.state_itxt.text == "") 
				{
					if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERROR: " + TableDataManager.EMPTY_FIELD_DATA_FORM_SPANISH;
					else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERREUR: " + TableDataManager.EMPTY_FIELD_DATA_FORM_FRENCH;
						
					return false;
				}
				
				// Verficando que el email este formado correctamente
				if(StringUtils.isValidEmail(dataFormModalWindow_mc.email_itxt.text) == false)
				{
					if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERROR: " + TableDataManager.INVALID_EMAIL_DATA_FORM_SPANISH;
					else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERREUR: " + TableDataManager.INVALID_EMAIL_DATA_FORM_FRENCH;
					
					return false;
				}
				
				// Verficando que se ha aceptado la Politica de Privacidad
				if(dataFormModalWindow_mc.privacyPolicy_chbox.selected == false)
				{
					if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERREUR: " + TableDataManager.UNSELECTED_PRIVACY_POLICY_DATA_FORM_SPANISH;
					else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
						(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "ERREUR: " + TableDataManager.UNSELECTED_PRIVACY_POLICY_DATA_FORM_FRENCH;
					
					return false;
				}
				
				
				// ************* ESPACIO PARA AGREGAR TODAS LAS VALIDACION REQUERIDAS *********************
			}
			
			return true;
		}
		
		/**
		 * @event
		 * Ejecuta acciones cuando se hace click sobre el boton de la ventana modal generica
		 */
		private function onModalWindowButtonClickHandler(evt:MouseEvent):void
		{
			trace("LanDakarFacebookTabManager->onModalWindowButtonClickHandler()");
			switch(_actualModalWindowVO.hash)
			{
				case TableDataManager.COMPONENT_RIGHT_MODAL_WINDOW_HASH:
				case TableDataManager.COMPONENT_FAILURE_MODAL_WINDOW_HASH:
					if(ACTIVE_URL_FACEBOOK)
						_reloadFunction.call();
					break;
				
				case TableDataManager.COMPONENT_SUCCESS_MODAL_WINDOW_HASH:
					
					break;
				
				default:
					throw new Error("Ventana Modal con ID desconocido");
			}
		}
		
		/**
		 * @event
		 * Cierra la ventana modal generica
		 */
		private function onCloseModalWindowHandler(evt:MouseEvent):void
		{
			trace("LanDakarFacebookTabManager->onCloseModalWindowHandler()");
			this.closeModalWindow();
		}
		
		/**
		 * @event
		 * Ejecuta acciones cuando se captura el evento de link sobre texto HTML
		 */
		private function onLegalTextLinkEventHandler(evt:TextEvent):void
		{			
			if(LanguageManager.getInstance().languageApplication == TableDataManager.SPANISH)
				navigateToURL(new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_PRIVACY_POLICY_SP), "_blank");
			else if(LanguageManager.getInstance().languageApplication == TableDataManager.FRENCH)
				navigateToURL(new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_PRIVACY_POLICY_FR), "_blank");
		}
		
		/**
		 * @event
		 * Muestra la ventana modal de ganadores
		 */
		private function onButtonGiftSectionClickHandler(evt:MouseEvent):void
		{
			trace("LanDakarFacebookTabManager->onButtonGiftSectionClickHandler()");
			
			// Obteniendo ventana modal de ganadores
			var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
			
			if(!_isWinnerModalWindowLoaded)
			{			
				// Actualizando variable de control de ventana modal de ganadores
				_isWinnerModalWindowLoaded = true;
				
				// Mostrando dialogo de carga
				this.showAppleVisualLoader();
				
				if(ACTIVE_URL_FACEBOOK)
				{
					// Haciendo peticion al servicio PHP que devuelte un XML con los ganadores
					try
					{	
						// Enviando variable al servicio PHP para aumentar votacion del caso
						var urlVars:URLVariables = new URLVariables();
						urlVars.access_token = _flashvars.access_token;
						urlVars.lang = _flashvars.language;	
						
						// Opciones del servicio PHP
						var urlPHPServiceRequest:URLRequest = new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_WINNERS_PHP_SERVICE);
						urlPHPServiceRequest.method = URLRequestMethod.POST;
						urlPHPServiceRequest.data = urlVars;
						
						// Enviando datos al servicio
						var urlLoaderPHPService:URLLoader = new URLLoader();						
						urlLoaderPHPService.load(urlPHPServiceRequest);
						urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendWinnersPHPServiceComplete);
						urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);		
						
					} catch(e:Error) { throw new Error(e.toString()); }
				}
				else
				{
					// WINNERS MODAL WINDOW				
					var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
					if(winnersModalWindow_mc != null)
					{	
						// Actualizando datos de la ventana modal actual
						_actualModalWindowVO = LanguageManager.getInstance().data.winnersModalWindow;
						
						// Configurando paginacicon
						this.configInitPaginationWinnerModalWindow();
						
						// Configurando detectores de eventos
						(winnersModalWindow_mc.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onCloseModalWindowHandler);
						
						// Cargando imagenes de ganadores
						for(var i:uint = 0; i < DataModel.getInstance().winnerList.length; i++)
						{
							// Obteniendo ganador
							var winner:WinnerVO = DataModel.getInstance().winnerList[i] as WinnerVO;
							
							// Verificando existencia de ganadores
							if(winner != null) {
								_bulkLoader.add(new URLRequest(winner.pic), {id: String(winner.id)  + "-"+ winner.pic});
							} else { (winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).visible = false; }											
						}
						
						// Configurando detectores de eventos
						_bulkLoader.addEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
						_bulkLoader.addEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);
						_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorHandler);
						_bulkLoader.start();
					}
				}
			} 
			else
			{
				// Obteniendo ModalPanel
				var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
				modalPanel.visible = true;
				
				// Mostrando ventana modal de ganadores con los datos ya cargados anteriormente
				winnersModalWindow.visible = true;
				
				// Actualizando datos de la ventana modal actual
				_actualModalWindowVO = LanguageManager.getInstance().data.winnersModalWindow;
			}
		}
		
		/**
		 * @event
		 * Ejecuta acciones una vez terminada las descargas de ficheros externos	
		 */
		public function onBulkElementLoadedHandler(evt:Event):void 
		{
			trace("LanDakarFacebookTabManager->onBulkElementLoadedHandler()");
			
			try
			{
				// Desactivando detectores de eventos
				_bulkLoader.removeEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
				_bulkLoader.removeEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);	
				_bulkLoader.removeEventListener(BulkLoader.ERROR, onErrorHandler);
							
				if(_loader_mc != null) 
				{				
					// Invisibilizando loader
					this.hideAppleVisualLoader();
					
					// Asignando imagen cargada al objeto de datos
					for(var i:uint = 0; i < DataModel.getInstance().winnerList.length; i++)
					{
						// Obteniendo ganador
						var winner:WinnerVO = DataModel.getInstance().winnerList[i] as WinnerVO;
						
						// Obteniendo a imagen correspondiente y asignandosela a ganador
						var winnerImage:Bitmap = _bulkLoader.getBitmap(String(winner.id) + "-" + winner.pic, true);
						winner.bitmap = winnerImage;
					}
					
					// Configurando aplicacion
					showWinnerImages();	
				}
				
			} catch(e:Error) { throw new Error("winnerImage: " + winnerImage + "\n" + e.toString()); }
			
		}
		
		/**
		 * @event
		 * Ejecuta acciones mientras se descargan los ficheros externos	
		 */
		public function onBulkElementProgressHandler(evt:BulkProgressEvent):void 
		{
			trace("onBulkElementProgressHandler: name=" + evt.target + " bytesLoaded=" + evt.bytesLoaded + " bytesTotal=" + evt.bytesTotal);
			var percent:uint = Math.floor((evt.totalPercentLoaded) * 100) ;	
			
			if(_loader_mc != null) 
			{				
				_loader_mc.bar_mc.gotoAndStop(percent);
				if(evt.bytesLoaded == evt.bytesTotal)
					_loader_mc.bar_mc.gotoAndStop(100);
			}
		}									
		
		/**
		 * @event
		 * Ejecuta acciones cuando se captura algun error en la descarga de ficheros externos
		 */
		public function onErrorHandler(evt:Event):void {	
			throw new Error("\nERROR: " + evt);
		}
		
		/**
		 * @event
		 * Muestra la proxima pagina de ganadores
		 */
		private function onNextButtonPaginatorClickHandler(evt:MouseEvent):void {
			this.nextWinnerPage();
		}
		
		/**
		 * @event
		 * Muestra la proxima pagina de ganadores
		 */
		private function onPrevButtonPaginatorClickHandler(evt:MouseEvent):void {
			this.prevWinnerPage();
		}
		
		/**
		 * @event
		 * Muestra la ventana de Facebook para hacer las invitaciones a sus amigos
		 */
		private function onWelcomeModalWindowClickHandler(evt:MouseEvent):void
		{			
			var welcomeModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH) as Component;
			welcomeModalWindow.visible = false;	
			if(ACTIVE_URL_FACEBOOK)
				_bridgeFunction.call();
			else
			{
				var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
				modalPanel.visible = false;
				var imageViewer:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_IMAGE_VIEWER_HASH) as Component;
				var imageViewer_mc:MovieClip = imageViewer.getChildAt(0) as MovieClip;
				imageViewer_mc.playTransition();
			}
				
		}
		
		/**
		 * @event
		 * Verifica que el usuario sea fan de LAN
		 */
		private function onFanModalWindowClickHandler(evt:MouseEvent):void
		{			
			try
			{	
				// Enviando variable al servicio PHP para aumentar votacion del caso
				var urlVars:URLVariables = new URLVariables();
				urlVars.access_token = _flashvars.access_token;
				urlVars.lang = _flashvars.language;				
				
				// Opciones del servicio PHP
				var urlPHPServiceRequest:URLRequest = new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_FAN_PHP_SERVICE);
				urlPHPServiceRequest.method = URLRequestMethod.POST;
				urlPHPServiceRequest.data = urlVars;
				
				// Enviando datos al servicio
				var urlLoaderPHPService:URLLoader = new URLLoader();
				urlLoaderPHPService.dataFormat = URLLoaderDataFormat.VARIABLES;
				urlLoaderPHPService.load(urlPHPServiceRequest);
				urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendFanPHPServiceComplete);
				urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);		

			}
			catch(e:Error) { throw e; }
				
		}
		
		/**
		 * @event
		 * Envia los datos del formulario al servidor
		 */
		private function onDataFormSendButtonClickHandler(evt:MouseEvent):void
		{
			// Obteniendo componente
			var dataFormModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_DATA_FORM_MODAL_WINDOW_HASH) as Component;
			var dataFormModalWindow_mc:MovieClip = dataFormModalWindow.getChildAt(0) as MovieClip;
			if(dataFormModalWindow_mc != null)
			{
				try
				{
					// Limpiando mensaje de error en la ventana de formulario
					(dataFormModalWindow_mc.errorMesagge_dtxt as TextField).text = "";
					
					var success:Boolean = this.verifyAllFieldDataForm();					
					if(success)					
					{
						trace("dataFormModalWindow_mc.name_itxt: " + dataFormModalWindow_mc.name_itxt);											
						
						// Enviando variable al servicio PHP para aumentar votacion del caso
						var urlVars:URLVariables = new URLVariables();
						urlVars.access_token = _flashvars.access_token;
						urlVars.lang = _flashvars.language;
						urlVars.name = dataFormModalWindow_mc.name_itxt.text;
						urlVars.lastname = dataFormModalWindow_mc.lastname_itxt.text;
						urlVars.email = dataFormModalWindow_mc.email_itxt.text;
						urlVars.phone = dataFormModalWindow_mc.phone_itxt.text;
						urlVars.dni = dataFormModalWindow_mc.dni_itxt.text;
						urlVars.street = dataFormModalWindow_mc.street_itxt.text;
						urlVars.number = dataFormModalWindow_mc.number_itxt.text;
						urlVars.floor = dataFormModalWindow_mc.floor_itxt.text;
						urlVars.letter = dataFormModalWindow_mc.letter_itxt.text;
						urlVars.zp = dataFormModalWindow_mc.zp_itxt.text;
						urlVars.poblation = dataFormModalWindow_mc.poblation_itxt.text;
						urlVars.state = dataFormModalWindow_mc.state_itxt.text;
	
						// Opciones del servicio PHP
						var urlPHPServiceRequest:URLRequest = new URLRequest(TableDataManager.URL_FACEBOOK + TableDataManager.URL_DATA_FORM_PHP_SERVICE);
						urlPHPServiceRequest.method = URLRequestMethod.POST;
						urlPHPServiceRequest.data = urlVars;
						
						// Enviando datos al servicio
						var urlLoaderPHPService:URLLoader = new URLLoader();
						urlLoaderPHPService.dataFormat = URLLoaderDataFormat.VARIABLES;
						urlLoaderPHPService.load(urlPHPServiceRequest);
						urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendDataFormPHPServiceComplete);
						urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);		
						
						// Invisibilizando formulario
						dataFormModalWindow.visible = false;											
					}
				}
				catch(e:Error)
				{
					var msg:String = "dataFormModalWindow_mc.name_itxt: " + dataFormModalWindow_mc.name_itxt + "\n";
					throw new Error(msg + e.toString());
				}
			}
		}
		
		/**
		 * @event
		 * Ejecuta acciones una vez se retorna la respuesta desde el servidor
		 */
		private function onSendDataFormPHPServiceComplete(evt:Event):void			
		{
			trace("evt.target.data: " + evt.target.data);			
			var loader:URLLoader = URLLoader(evt.target);
			
			try
			{
				// Verificando respuesta del servicio PHP
				if(StringUtils.stringToBoolean(loader.data.success)) 
					this.showConfirmDataFormModalWindow();
				else 
					this.dataFormFieldError();		
			}
			catch(e:Error)
			{
				var msg:String = "loader.data.success: " + loader.data.success + "\n";
				throw new Error(msg);
			}
		}
		
		/**
		 * @event
		 * Ejecuta acciones una vez se retorna la respuesta desde el servidor
		 */
		private function onSendFanPHPServiceComplete(evt:Event):void			
		{
			trace("evt.target.data: " + evt.target.data);			
			var loader:URLLoader = URLLoader(evt.target);
			
			try
			{
				// Verificando respuesta del servicio PHP
				if(StringUtils.stringToBoolean(loader.data.isFan)) 
				{
					// Obteniendo componente ventana modal FAN
					var fanModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_FAN_MODAL_WINDOW_HASH) as Component;
					fanModalWindow.visible = false;
					
					// Obteniendo componente ventana modal FAN
					var modalPanel:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_MODAL_PANEL_HASH) as Component;
					modalPanel.visible = !StringUtils.stringToBoolean(_flashvars.invite);;
					
					// obteniendo componente ventana modal de WELCOME
					var welcomeModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WELCOME_MODAL_WINDOW_HASH) as Component;
					welcomeModalWindow.visible = !StringUtils.stringToBoolean(_flashvars.invite);
						
					if(StringUtils.stringToBoolean(_flashvars.invite) == true)
					{
						// IMAGE VIEWER
						
						var imageViewer:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_IMAGE_VIEWER_HASH) as Component;
						var imageViewer_mc:MovieClip = imageViewer.getChildAt(0) as MovieClip;					
						imageViewer_mc.playTransition();
					}
				}
				/*else
				// TODO: Mostrar mensaje en campo de texto de error que el usuario no es fan */
			}
			catch(e:Error)
			{
				var msg:String = "loader.data.success: " + loader.data.success + "\n";
				throw new Error(msg);
			}
		}
		
		/**
		 * @event
		 * Ejecuta acciones una vez se retorna la respuesta desde el servidor
		 */
		private function onSendWinnersPHPServiceComplete(evt:Event):void			
		{
			trace("evt.target.data: " + evt.target.data);								
			try
			{
				// Recuperando XML con los ganadores enviados por el servicio PHP
				var winnersXML:XML = new XML(evt.target.data);
				DataModel.getInstance().winnerList = XMLParser.parseWinnersXML(winnersXML);

				// Obteniendo ventana modal de ganadores
				var winnersModalWindow:Component = ComponentModel.getInstance().getComponent(TableDataManager.COMPONENT_WINNERS_MODAL_WINDOW_HASH) as Component;
				
				// WINNERS MODAL WINDOW				
				var winnersModalWindow_mc:MovieClip = winnersModalWindow.getChildAt(0) as MovieClip;
				if(winnersModalWindow_mc != null)
				{	
					// Actualizando datos de la ventana modal actual
					_actualModalWindowVO = LanguageManager.getInstance().data.winnersModalWindow;
					
					// Configurando paginacicon
					this.configInitPaginationWinnerModalWindow();  
					
					// Reiniciando contador de ganadores
					_winnerCounter = 0;
					
					// Configurando detectores de eventos
					(winnersModalWindow_mc.close_btn as SimpleButton).addEventListener(MouseEvent.CLICK, onCloseModalWindowHandler);
					
					// Cargando imagenes de ganadores
					for(var i:uint = 0; i < DataModel.getInstance().winnerList.length; i++)
					{
						// Obteniendo ganador
						var winner:WinnerVO = DataModel.getInstance().winnerList[i] as WinnerVO;
						
						// Verificando existencia de ganadores
						if(winner != null) 
						{
							// Cargador de imagenes
							winner.loader = new Loader();
							var facebookLoaderContext:LoaderContext = new LoaderContext();
							facebookLoaderContext.checkPolicyFile = true;
							var picRequest:URLRequest = new URLRequest(winner.pic);
							winner.loader.load(picRequest, facebookLoaderContext);

							// Detectores de eventos
							if(winner.loader.contentLoaderInfo.hasEventListener(Event.COMPLETE)) 
								winner.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onFacebookPicLoadedHandler);

							winner.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFacebookPicLoadedHandler);
							winner.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);													
														
							/*
							var props:Object = new Object();
							props.id = String(winner.id) + "-" + winner.pic;
							props.context = loaderContext;
							_bulkLoader.add(new URLRequest(winner.pic), props);
							*/
							
						} else { (winnersModalWindow_mc.winnerList_mc["item_" + i] as MovieClip).visible = false; }											
					}
					
					/*
					// Configurando detectores de eventos
					_bulkLoader.addEventListener(BulkLoader.COMPLETE, onBulkElementLoadedHandler);
					_bulkLoader.addEventListener(BulkLoader.PROGRESS, onBulkElementProgressHandler);
					_bulkLoader.addEventListener(BulkLoader.ERROR, onErrorHandler);
					_bulkLoader.start();
					*/
				}
				
			} catch(e:Error) { throw new Error("winnerLength: " + DataModel.getInstance().winnerList + "\n" + e.toString()); }			
		}
		
		public function onFacebookPicLoadedHandler(evt:Event):void
		{
			// Actualizando contador de ganadores
			_winnerCounter++;
			
			// Verificando si se han cargado las imagenes de todos los ganadores
			if(_winnerCounter >= DataModel.getInstance().winnerList.length)
			{
				// Invisibilizando loader
				this.hideAppleVisualLoader();
				
				// Mostrando imagenes de ganadores
				showWinnerImages();
				
				// Cargando datos del contacto en componente
				this.loadWinnerData(0);
			}
		}
		
		public function onTimerEventHandler(evt:TimerEvent):void {
			this.onTextLinkEventHandler(null);			
		}
		
	}
}