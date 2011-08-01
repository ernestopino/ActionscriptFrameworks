/**
 * ...
 * ContactFormAttachment, Versión AS3
 * Formulario de contacto con fichero adjunto (utiliza PHP)
 * 
 * @author 		Fabio Biondi
 * @modified    by Ernesto Pino Martínez
 */

package com.epinom.btob.utils {
	
	import com.epinom.btob.managers.SiteManager;
	import com.epinom.btob.managers.TableDataManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ContactFormAttachment extends Sprite
	{ 
		// Constantes 
		//private static const URL_UPLOAD_SERVICE:String = "services/ContactFormAttach.php";
		private static const URL_UPLOAD_SERVICE:String = "/back/web/uploadFile/";
		private static const URL_DATA_SERVICE:String = "/back/web/contact";
		//private static const URL_UPLOAD_SERVICE:String = "http://localhost/btob/services/ContactFormAttach.php";
		
		// Variables 
		private var uploadRequest:URLRequest;
		private var dataRequest:URLRequest;
		private var fileRef:FileReference;
		private var file:FileReference;
		
		// Componentes
		private var selectButton:SimpleButton;
		private var sendButton:SimpleButton;
		private var nameTextInput:*;
		private var emailTextInput:*;
		private var subjectTextInput:*;
		private var filePathTextInput:*;
		private var msgTextArea:*;
		
		// Componentes errores
		private var nameError_mc:MovieClip;
		private var emailError_mc:MovieClip;
		private var subjectError_mc:MovieClip;
		private var filePathError_mc:MovieClip;
		private var msgError_mc:MovieClip;	
		
		private var urlServerPath:String = "";
		
		/**
		* Constructor
		*/
		public function ContactFormAttachment() 
		{		
			trace("ContactFormAttachment->ContactFormAttachment()");
			
			// Configurando detectores de eventos para el objeto que realiza la conexion con ficheros locales
			this.fileRef = new FileReference();
			this.fileRef.addEventListener(Event.SELECT, selectHandler);
			this.fileRef.addEventListener(Event.COMPLETE, completeHandler);
			this.fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			this.fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadComplete);	
		}
		
		// Funciones para registrar los componentes que van a ser manejados por la clase
		public function registerSelectButton(value:SimpleButton):void 
		{
			this.selectButton = value;
			this.selectButton.addEventListener(MouseEvent.CLICK, openDialog)
		}
		
		public function registerSendButton(value:SimpleButton):void 
		{
			this.sendButton = value;
			this.sendButton.addEventListener(MouseEvent.CLICK, sendAll)
		}
		
		public function registerNameTextInput(value:*, errorMC:MovieClip):void 
		{ 
			this.nameError_mc = errorMC;
			this.nameError_mc.visible = false;
			this.nameTextInput = value; 
		}
		
		public function registerEmailTextInput(value:*, errorMC:MovieClip):void 
		{ 
			this.emailError_mc = errorMC;
			this.emailError_mc.visible = false;
			this.emailTextInput = value;
			this.emailTextInput.addEventListener(Event.DEACTIVATE, onEmailTextInputDeactivateHandler);
		}
		public function registerSubjectTextInput(value:*, errorMC:MovieClip):void 
		{ 
			this.subjectError_mc = errorMC;
			this.subjectError_mc.visible = false;
			this.subjectTextInput = value; 
		}
				
		public function registerFilePathTextInput(value:*, errorMC:MovieClip):void 
		{ 
			this.filePathError_mc = errorMC;
			this.filePathError_mc.visible = false;
			this.filePathTextInput = value; 
		}
		
		public function registerMessageTextArea(value:*, errorMC:MovieClip):void 
		{ 
			this.msgError_mc = errorMC;
			this.msgError_mc.visible = false;
			this.msgTextArea = value; 
		}
		
		private function onEmailTextInputDeactivateHandler(evt:Event):void
		{
			if (!isEmailValid(this.emailTextInput.text)) 
			{
				this.emailTextInput.text = "Email no válido";
				this.emailError_mc.visible = true;
				return;
			}
			else
			{
				this.emailError_mc.visible = false;
			}
		}
				
		/**
		* Open the browser file window
		*/
		private function openDialog(event:MouseEvent):void{
			fileRef.browse();
		}
				
		/**
		* Dispatched when the user selects a file for upload or download from the file-browsing dialog box.
		*/
		private function selectHandler(event:Event):void{
			
			// Get file info
			this.file = FileReference(event.target);
			
			
			// check if file < 1mb
			if (file.size < 1000000) 
			{		
				// Verificando si esta activa la carga de imagenes desde el servidor 
				if(SiteManager.ACTIVE_SERVICE_SIDE)
					this.urlServerPath = TableDataManager.URL_PATH_SERVER;
				
				// The PHP Script to call				
				uploadRequest = new URLRequest(this.urlServerPath + URL_UPLOAD_SERVICE + file.name);
				trace("Fichero enviado: " + this.urlServerPath + URL_UPLOAD_SERVICE + file.name);
				
				// Set variables to send
				uploadRequest.method = URLRequestMethod.POST;
				uploadRequest.data = new URLVariables();
				fileRef.upload(uploadRequest);
				
				// Display File information (name + size)
				this.filePathTextInput.text = file.name + " (" + file.size + " Kb)"
				this.filePathError_mc.visible = false;
					
			} 
			else 
			{
				// File >= 1mb
				this.filePathTextInput.text = "Fichero superior a 1mb"
				this.filePathError_mc.visible = true;
				this.filePathTextInput.setFocus();
			}
		}
		
		/**
		* Submit the form 
		* Invoked after submit button click event
		*/
		private function sendAll(event:MouseEvent):void{
			
			// If email is not valid we stop the submit
			if (!isEmailValid(this.emailTextInput.text)) {
				this.emailTextInput.text = "Email no válido";
				this.emailError_mc.visible = true;
				this.emailTextInput.setFocus();
				return;
			}
			else
			{
				this.emailError_mc.visible = false;
			}
			
			// Enviando variable al servicio PHP para aumentar votacion del caso
			var urlVars:URLVariables = new URLVariables();
			urlVars.name = this.nameTextInput.text;
			urlVars.email = this.emailTextInput.text;
			urlVars.subject = this.subjectTextInput.text;
			urlVars.consult = this.msgTextArea.text;
			urlVars.filename = this.file.name;
			
			// Opciones del servicio PHP
			var urlPHPServiceRequest:URLRequest = new URLRequest(this.urlServerPath + URL_DATA_SERVICE);
			urlPHPServiceRequest.method = URLRequestMethod.POST;
			urlPHPServiceRequest.data = urlVars;
			
			// Enviando datos al servicio
			var urlLoaderPHPService:URLLoader = new URLLoader();
			urlLoaderPHPService.load(urlPHPServiceRequest);
			urlLoaderPHPService.addEventListener(Event.COMPLETE, onSendPHPServiceComplete);
			urlLoaderPHPService.addEventListener(IOErrorEvent.IO_ERROR, onSendPHPServiceError);		
		}					
			
		/**
		* Dispatched periodically during the file upload or download operation 
		* NOTE: it's useful to get the upload progress percentage)
		*/
		private function progressHandler(event:ProgressEvent):void {
			// Display upload file progress
			this.filePathTextInput.text = int((event.bytesLoaded / event.bytesTotal)* 100) + "%"
		}

		/**
		* Dispatched when download is complete or when upload generates an HTTP status code of 200.
		*/
		private function completeHandler(event:Event):void {
			this.filePathTextInput.text = "Descarga terminada"
		}

		/**
		* Dispatched after data is received from the server after a successful upload.
		*/
		private function uploadComplete(e:DataEvent):void {
			
			var mailResponse:Object = e.data
			trace("mailResponse: " + mailResponse);
				
			// Email sent with success
			if (mailResponse == "1") {						
				
				// Set to null the request object
				uploadRequest = null
				
			} else {
				this.filePathTextInput.text = "Hay algun problema en el servidor";				
			}			
		}
		
		
		/**
		* CHECK EMAIL VALID
		* Return TRUE = Email valid | FALSE = Email Wrong
		*/
		private function isEmailValid(mail:String):Boolean 
		{
			var emailRegEx:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			
			if (!emailRegEx.test(mail)) 				
				return false
			else
				return true;
		}
		
		
		private function onSendPHPServiceComplete(evt:Event):void
		{
			// Recuperando respuesta del servicio PHP
			trace("Respuesta del servidor: " + evt.target.data);
			
			// Reset form fields
			this.nameTextInput.text = "";
			this.emailTextInput.text = "";
			this.subjectTextInput.text = "";
			this.filePathTextInput.text = "";				
			this.msgTextArea.text = "";
			
			// Change SUBMIT button status to disable
			this.sendButton.enabled = false;	
		}
		
		private function onSendPHPServiceError(evt:Event):void
		{
			SiteManager.getInstance().showErrorWindow("Respuesta del servicio PHP: " + evt.toString());
		}

	}
}