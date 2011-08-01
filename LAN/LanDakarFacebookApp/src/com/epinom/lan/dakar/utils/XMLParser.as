/**
 * ...
 * XMLParser
 * Parseador de un fichero XML.
 * Segun la aplicacion en cuestion, se utiliza para convertir un fichero XML de configuracion, en objetos contenedores de datos (VOs)
 * 
 * @author Ernesto Pino Martínez
 * @date 20/09/2010
 */

package com.epinom.lan.dakar.utils
{
	import com.epinom.lan.dakar.managers.TableDataManager;
	import com.epinom.lan.dakar.model.DataModel;
	import com.epinom.lan.dakar.vo.AuthorVO;
	import com.epinom.lan.dakar.vo.ComponentVO;
	import com.epinom.lan.dakar.vo.LanguageVO;
	import com.epinom.lan.dakar.vo.OwnerVO;
	import com.epinom.lan.dakar.vo.ResolutionVO;
	import com.epinom.lan.dakar.vo.SettingsVO;
	import com.epinom.lan.dakar.vo.SoundVO;
	import com.epinom.lan.dakar.vo.WinnerVO;

	public class XMLParser
	{
		public function XMLParser() {}
		
		public static function parseSettingsXML(settingsXML:XML, currentSettings:SettingsVO = null):SettingsVO
		{
			trace("XMLParser->parseSettingsXML()");
			
			// Instanciando objeto de datos para configuracion
			var settings:SettingsVO = currentSettings ? currentSettings : new SettingsVO();
			
			// Almacenando valores obtenidos del fichero de configuracion
			settings.appName = String(settingsXML.appName);
			settings.version = String(settingsXML.version);	
			
			// Creando objeto de datos y almacenando valores
			var author:AuthorVO = new AuthorVO();
			author.name = String(settingsXML.author.name);
			author.lastname = String(settingsXML.author.lastname);
			author.alias = String(settingsXML.author.alias);
			author.email = String(settingsXML.author.email);
			author.web = String(settingsXML.author.web);
			author.blog = String(settingsXML.author.blog);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.author = author;
			
			// Creando objeto de datos y almacenando valores
			var owner:OwnerVO = new OwnerVO();
			owner.name = String(settingsXML.author.name);
			owner.web = String(settingsXML.author.web);
			owner.blog = String(settingsXML.author.blog);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.owner = owner;
			
			// Creando objeto de datos y almacenando valores
			var resolution:ResolutionVO = new ResolutionVO();
			resolution.width = Number(settingsXML.resolution.@width);
			resolution.height = Number(settingsXML.resolution.@height);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.resolution = resolution;
			
			// Recorriendo seciones en fichero de configuracion y contruyendo objetos de datos 
			var soundXMLList:XMLList = settingsXML.sounds;
			for each(var sound:XML in soundXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var soundVO:SoundVO = new SoundVO();
				soundVO.id = uint(sound.@id);
				soundVO.url = String(sound.@url);
				
				// Adicionando objeto de datos a la lista de secciones del objeto de configuracion principal
				settings.soundList.push(soundVO);
			}					

			// Recorriendo componentes en fichero de configuracion y contruyendo objetos de datos 
			var componentXMLList:XMLList = settingsXML.components;
			for each(var c:XML in componentXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var component:ComponentVO = new ComponentVO();
				component.type = String(c.type);
				component.className = String(c.className);
				component.instanceName = String(c.instanceName);
				component.visible = StringUtils.stringToBoolean(c.visible);
				component.hashId = String(c.hashId);
				component.url = String(c.url);
				component.changeSize = StringUtils.stringToBoolean(c.changeSize);
				component.percentageWidth = Number(c.percentageWidth);
				component.percentageHeight = Number(c.percentageHeight);
				component.changePositionX = StringUtils.stringToBoolean(c.changePositionX);
				component.changePositionY = StringUtils.stringToBoolean(c.changePositionY);
				component.percentageX = Number(c.percentageX);
				component.percentageY = Number(c.percentageY);
				component.centralReference = StringUtils.stringToBoolean(c.centralReference);
				component.elementOrder = Number(c.elementOrder);
				component.yPosition = Number(c.yPosition);
				component.percentagePadding= StringUtils.stringToBoolean(c.percentagePadding);
				component.paddingTop = Number(c.paddingTop);
				component.paddingBottom = Number(c.paddingBootom);
				component.paddingLeft = Number(c.paddingLeft);
				component.paddingRight = Number(c.paddingRight);
				
				// Adicionando objeto de datos a la lista de componentes del objeto de configuracion principal
				settings.componentList.push(component);
			}
			
			return settings;	
		}
		
		public static function parseWinnersXML(winnersXML:XML):Array
		{
			trace("XMLParser->parseWinnersXML()");
			
			try
			{
				// Inicializando lista de ganadores
				var winnerList:Array = new Array();
				
				// Recorriendo componentes en fichero de configuracion y contruyendo objetos de datos 
				var idCounter:uint = 0;
				for each(var fbuser:XML in winnersXML.fbuser)
				{
					// Creando objeto de datos y almacenando valores
					var winner:WinnerVO = new WinnerVO();
					winner.id = idCounter;
					winner.name = String(fbuser.@name);
					winner.pic = String(fbuser.@pic);	
					winner.gift = String(fbuser.@gift);
					winner.date = String(fbuser.@date);
					
					// Adicionando objeto de datos a la lista de componentes del objeto de configuracion principal
					winnerList.push(winner);
					
					// Actualizando identificador del ganador
					idCounter++;
				}
			
			} catch (e:Error) { throw new Error("Parser error: " + e.toString()); }
			
			return winnerList;
		}
		
		
		public static function parseLanguageXML(languageXML:XML, currentLanguage:LanguageVO = null):LanguageVO
		{
			trace("XMLParser->parseLanguageXML()");
			
			// Instanciando objeto de datos para configuracion
			var language:LanguageVO = currentLanguage ? currentLanguage : new LanguageVO();
			
			// Menu
			language.menu.hash = String(languageXML.menu.@id);
			language.menu.button0Text = String(languageXML.menu.button0Text);
			language.menu.button1Text = String(languageXML.menu.button1Text);
			language.menu.button2Text = String(languageXML.menu.button2Text);
			
			// Legal Text			
			language.legalText = String(languageXML.legalText);
			
			// GameSection			
			language.gameSection.hash = String(languageXML.gameSection.@id);
			language.gameSection.titleText = String(languageXML.gameSection.titleText);
			language.gameSection.subtitleText = String(languageXML.gameSection.subtitleText);
			
			// GameSection
			language.giftSection.hash = String(languageXML.giftSection.@id);	
			language.giftSection.buttonText = String(languageXML.giftSection.buttonText);			
			
			// QuestionPanel
			language.questionPanel.hash = String(languageXML.questionPanel.@id);
			
			// SEMANA PAR
			language.questionPanel.mondayQuestionPar = String(languageXML.questionPanel.mondayQuestionPar);
			language.questionPanel.mondaySignalPar = String(languageXML.questionPanel.mondaySignalPar);
			language.questionPanel.mondayAnswerPar = String(languageXML.questionPanel.mondayAnswerPar);
			
			language.questionPanel.tuesdayQuestionPar = String(languageXML.questionPanel.tuesdayQuestionPar);
			language.questionPanel.tuesdaySignalPar = String(languageXML.questionPanel.tuesdaySignalPar);
			language.questionPanel.tuesdayAnswerPar = String(languageXML.questionPanel.tuesdayAnswerPar);
			
			language.questionPanel.wednesdayQuestionPar = String(languageXML.questionPanel.wednesdayQuestionPar);
			language.questionPanel.wednesdaySignalPar = String(languageXML.questionPanel.wednesdaySignalPar);
			language.questionPanel.wednesdayAnswerPar = String(languageXML.questionPanel.wednesdayAnswerPar);
			
			language.questionPanel.thursdayQuestionPar = String(languageXML.questionPanel.thursdayQuestionPar);
			language.questionPanel.thursdaySignalPar = String(languageXML.questionPanel.thursdaySignalPar);
			language.questionPanel.thursdayAnswerPar = String(languageXML.questionPanel.thursdayAnswerPar);
			
			language.questionPanel.fridayQuestionPar = String(languageXML.questionPanel.fridayQuestionPar);
			language.questionPanel.fridaySignalPar = String(languageXML.questionPanel.fridaySignalPar);
			language.questionPanel.fridayAnswerPar = String(languageXML.questionPanel.fridayAnswerPar);
			
			language.questionPanel.saturdayQuestionPar = String(languageXML.questionPanel.saturdayQuestionPar);
			language.questionPanel.saturdaySignalPar = String(languageXML.questionPanel.saturdaySignalPar);
			language.questionPanel.saturdayAnswerPar = String(languageXML.questionPanel.saturdayAnswerPar);
			
			language.questionPanel.sundayQuestionPar = String(languageXML.questionPanel.sundayQuestionPar);
			language.questionPanel.sundaySignalPar = String(languageXML.questionPanel.sundaySignalPar);
			language.questionPanel.sundayAnswerPar = String(languageXML.questionPanel.sundayAnswerPar);
			
			// SEMANA IMPAR
			language.questionPanel.mondayQuestionImpar = String(languageXML.questionPanel.mondayQuestionImpar);
			language.questionPanel.mondaySignalImpar = String(languageXML.questionPanel.mondaySignalImpar);
			language.questionPanel.mondayAnswerImpar = String(languageXML.questionPanel.mondayAnswerImpar);
			
			language.questionPanel.tuesdayQuestionImpar = String(languageXML.questionPanel.tuesdayQuestionImpar);
			language.questionPanel.tuesdaySignalImpar = String(languageXML.questionPanel.tuesdaySignalImpar);
			language.questionPanel.tuesdayAnswerImpar = String(languageXML.questionPanel.tuesdayAnswerImpar);
			
			language.questionPanel.wednesdayQuestionImpar = String(languageXML.questionPanel.wednesdayQuestionImpar);
			language.questionPanel.wednesdaySignalImpar = String(languageXML.questionPanel.wednesdaySignalImpar);
			language.questionPanel.wednesdayAnswerImpar = String(languageXML.questionPanel.wednesdayAnswerImpar);
			
			language.questionPanel.thursdayQuestionImpar = String(languageXML.questionPanel.thursdayQuestionImpar);
			language.questionPanel.thursdaySignalImpar = String(languageXML.questionPanel.thursdaySignalImpar);
			language.questionPanel.thursdayAnswerImpar = String(languageXML.questionPanel.thursdayAnswerImpar);
			
			language.questionPanel.fridayQuestionImpar = String(languageXML.questionPanel.fridayQuestionImpar);
			language.questionPanel.fridaySignalImpar = String(languageXML.questionPanel.fridaySignalImpar);
			language.questionPanel.fridayAnswerImpar = String(languageXML.questionPanel.fridayAnswerImpar);
			
			language.questionPanel.saturdayQuestionImpar = String(languageXML.questionPanel.saturdayQuestionImpar);
			language.questionPanel.saturdaySignalImpar = String(languageXML.questionPanel.saturdaySignalImpar);
			language.questionPanel.saturdayAnswerImpar = String(languageXML.questionPanel.saturdayAnswerImpar);
			
			language.questionPanel.sundayQuestionImpar = String(languageXML.questionPanel.sundayQuestionImpar);
			language.questionPanel.sundaySignalImpar = String(languageXML.questionPanel.sundaySignalImpar);
			language.questionPanel.sundayAnswerImpar = String(languageXML.questionPanel.sundayAnswerImpar);
			
			// COMPONENTES
			language.questionPanel.buttonText = String(languageXML.questionPanel.buttonText);
			language.questionPanel.signalText = String(languageXML.questionPanel.signalText);
			
			// DataFormModalWindow
			language.dataFormModalWindow.hash = String(languageXML.dataFormModalWindow.@id);
			language.dataFormModalWindow.titleText = String(languageXML.dataFormModalWindow.titleText);
			language.dataFormModalWindow.subtitleText = String(languageXML.dataFormModalWindow.subtitleText);
			language.dataFormModalWindow.nameText = String(languageXML.dataFormModalWindow.nameText);
			language.dataFormModalWindow.lastnameText = String(languageXML.dataFormModalWindow.lastnameText);
			language.dataFormModalWindow.emailText = String(languageXML.dataFormModalWindow.emailText);
			language.dataFormModalWindow.phoneText = String(languageXML.dataFormModalWindow.phoneText);
			language.dataFormModalWindow.dniText = String(languageXML.dataFormModalWindow.dniText);
			language.dataFormModalWindow.streetText = String(languageXML.dataFormModalWindow.streetText);
			language.dataFormModalWindow.numberText = String(languageXML.dataFormModalWindow.numberText);
			language.dataFormModalWindow.floorText = String(languageXML.dataFormModalWindow.floorText);
			language.dataFormModalWindow.letterText = String(languageXML.dataFormModalWindow.letterText);
			language.dataFormModalWindow.zpText = String(languageXML.dataFormModalWindow.zpText);
			language.dataFormModalWindow.poblationText = String(languageXML.dataFormModalWindow.poblationText);
			language.dataFormModalWindow.stateText = String(languageXML.dataFormModalWindow.stateText);
			language.dataFormModalWindow.privacyPolicyText = String(languageXML.dataFormModalWindow.privacyPolicyText);
			language.dataFormModalWindow.sendButtonText = String(languageXML.dataFormModalWindow.sendButtonText);
			
			// FailureModalWindow
			language.failureModalWindow.hash = String(languageXML.failureModalWindow.@id);
			language.failureModalWindow.titleText = String(languageXML.failureModalWindow.titleText);
			language.failureModalWindow.text = String(languageXML.failureModalWindow.text);
			language.failureModalWindow.buttonText = String(languageXML.failureModalWindow.buttonText);
			
			// RightAnswerModalWindow
			language.rightAnswerModalWindow.hash = String(languageXML.rightAnswerModalWindow.@id);
			language.rightAnswerModalWindow.titleText = String(languageXML.rightAnswerModalWindow.titleText);
			language.rightAnswerModalWindow.text = String(languageXML.rightAnswerModalWindow.text);
			language.rightAnswerModalWindow.buttonText = String(languageXML.rightAnswerModalWindow.buttonText);
			
			// SuccessModalWindow
			language.successModalWindow.hash = String(languageXML.successModalWindow.@id);
			language.successModalWindow.titleText = String(languageXML.successModalWindow.titleText);
			language.successModalWindow.text = String(languageXML.successModalWindow.text);
			language.successModalWindow.buttonText = String(languageXML.successModalWindow.buttonText);
			
			// WinnersModalWindow
			language.winnersModalWindow.hash = String(languageXML.winnersModalWindow.@id);
			language.winnersModalWindow.titleText = String(languageXML.winnersModalWindow.titleText);
			language.winnersModalWindow.text = String(languageXML.winnersModalWindow.subtitleText);
			language.winnersModalWindow.buttonText = String(languageXML.winnersModalWindow.buttonText);
			
			// FanModalWindow
			language.fanModalWindow.hash = String(languageXML.fanModalWindow.@id);
			language.fanModalWindow.titleText = String(languageXML.fanModalWindow.titleText);
			language.fanModalWindow.text = String(languageXML.fanModalWindow.subtitleText);
			language.fanModalWindow.buttonText = String(languageXML.fanModalWindow.buttonText);
			
			// WelcomeModalWindow
			language.welcomeModalWindow.hash = String(languageXML.welcomeModalWindow.@id);
			language.welcomeModalWindow.titleText = String(languageXML.welcomeModalWindow.titleText);
			language.welcomeModalWindow.text = String(languageXML.welcomeModalWindow.subtitleText);
			language.welcomeModalWindow.buttonText = String(languageXML.welcomeModalWindow.buttonText);
			
			// ConfirmDataFormModalWindow
			language.confirmDataFormModalWindow.hash = String(languageXML.confirmDataFormModalWindow.@id);
			language.confirmDataFormModalWindow.titleText = String(languageXML.confirmDataFormModalWindow.titleText);
			language.confirmDataFormModalWindow.text = String(languageXML.confirmDataFormModalWindow.subtitleText);
			language.confirmDataFormModalWindow.buttonText = String(languageXML.confirmDataFormModalWindow.buttonText);
			
			return language;
		}
		
	}
}