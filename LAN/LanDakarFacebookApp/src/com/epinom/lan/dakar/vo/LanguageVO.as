/**
 * ...
 * LanguageVO
 * Objeto de Datos
 * 
 * @author Ernesto Pino Martínez
 * @date 21/09/2010
 */

package com.epinom.lan.dakar.vo
{
	public class LanguageVO
	{
		private var _languageXMLLocation:String;
		private var _menu:MenuVO;
		private var _legalText:String;
		private var _gameSection:GameSectionVO;
		private var _giftSection:GiftSectionVO;
		private var _questionPanel:QuestionPanelVO;
		private var _dataFormModalWindow:DataFormModalWindowVO;
		private var _failureModalWindow:ModalWindowVO;
		private var _rightAnswerModalWindow:ModalWindowVO;
		private var _successModalWindow:ModalWindowVO;
		private var _winnersModalWindow:ModalWindowVO;
		private var _fanModalWindow:ModalWindowVO;
		private var _welcomeModalWindow:ModalWindowVO;
		private var _confirmDataFormModalWindow:ModalWindowVO;
		
		public function LanguageVO() 
		{
			_menu = new MenuVO();
			_gameSection = new GameSectionVO();
			_giftSection = new GiftSectionVO();
			_questionPanel = new QuestionPanelVO();
			_dataFormModalWindow = new DataFormModalWindowVO();
			_failureModalWindow = new ModalWindowVO();
			_rightAnswerModalWindow = new ModalWindowVO();
			_successModalWindow = new ModalWindowVO();
			_winnersModalWindow = new ModalWindowVO();
			_fanModalWindow = new ModalWindowVO();
			_welcomeModalWindow = new ModalWindowVO();
			_confirmDataFormModalWindow = new ModalWindowVO();
		}
		
		public function get languageXMLLocation():String { return _languageXMLLocation; }		
		public function set languageXMLLocation(value:String):void { _languageXMLLocation = value; }	
		
		public function get menu():MenuVO { return _menu; }
		public function set menu(value:MenuVO):void { _menu = value; }
		
		public function get legalText():String { return _legalText; }		
		public function set legalText(value:String):void { _legalText = value; }	
		
		public function get gameSection():GameSectionVO { return _gameSection; }
		public function set gameSection(value:GameSectionVO):void { _gameSection = value; }
		
		public function get giftSection():GiftSectionVO { return _giftSection; }
		public function set giftSection(value:GiftSectionVO):void { _giftSection = value; }
		
		public function get questionPanel():QuestionPanelVO { return _questionPanel; }
		public function set questionPanel(value:QuestionPanelVO):void { _questionPanel = value; }
		
		public function get dataFormModalWindow():DataFormModalWindowVO { return _dataFormModalWindow; }
		public function set dataFormModalWindow(value:DataFormModalWindowVO):void { _dataFormModalWindow = value; }
		
		public function get failureModalWindow():ModalWindowVO { return _failureModalWindow; }
		public function set failureModalWindow(value:ModalWindowVO):void { _failureModalWindow = value; }
		
		public function get rightAnswerModalWindow():ModalWindowVO { return _rightAnswerModalWindow; }
		public function set rightAnswerModalWindow(value:ModalWindowVO):void { _rightAnswerModalWindow = value; }
		
		public function get successModalWindow():ModalWindowVO { return _successModalWindow; }
		public function set successModalWindow(value:ModalWindowVO):void { _successModalWindow = value; }
		
		public function get winnersModalWindow():ModalWindowVO { return _winnersModalWindow; }
		public function set winnersModalWindow(value:ModalWindowVO):void { _winnersModalWindow = value; }
		
		public function get fanModalWindow():ModalWindowVO { return _fanModalWindow; }
		public function set fanModalWindow(value:ModalWindowVO):void { _fanModalWindow = value; }
		
		public function get welcomeModalWindow():ModalWindowVO { return _welcomeModalWindow; }
		public function set welcomeModalWindow(value:ModalWindowVO):void { _welcomeModalWindow = value; }
		
		public function get confirmDataFormModalWindow():ModalWindowVO { return _confirmDataFormModalWindow; }
		public function set confirmDataFormModalWindow(value:ModalWindowVO):void { _confirmDataFormModalWindow = value; }
	}
}