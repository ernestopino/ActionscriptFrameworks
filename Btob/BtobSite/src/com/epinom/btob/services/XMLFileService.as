package com.epinom.btob.services
{
	import com.epinom.btob.events.XMLServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	public class XMLFileService extends EventDispatcher	
	{
		static public const FILE_LOADED:String = "FILE STATUS: XML file loaded.";
		static public const FILE_SECURITY_ERROR:String = "FILE ERROR: A SecurityError has occurred.";		
		static public const FILE_ERROR:String = "FILE ERROR: Had problem loading the XML File.";
		
		private var _data:XML;
		private var _urlLoader:URLLoader;
				
		public function XMLFileService(){}
		public function get data():XML { return _data; }

		public function loadXMLFile(filename:String):void
		{
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onResultHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);					
            
            try 
            {
            	var request:URLRequest = new URLRequest(filename);
                _urlLoader.load(request);
            }
            catch (error:SecurityError)
            {            	
            	var securityError:Error = new Error(XMLServiceEvent.XML_ERROR);
            	securityError.message = FILE_SECURITY_ERROR;
            	
            	var xmlServiceEvent:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.XML_ERROR);
	        	xmlServiceEvent.message = FILE_SECURITY_ERROR;
	        	xmlServiceEvent.error = securityError;
	        	dispatchEvent(xmlServiceEvent);                 
            }
		}
		
		private function onResultHandler(e:Event):void 
		{
			XML.ignoreWhitespace = true;
        	_data = new XML(_urlLoader.data);
        	 
        	_urlLoader.removeEventListener(Event.COMPLETE, onResultHandler);
        	_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
        	
        	var xmlServiceEvent:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.XML_LOADED);
        	xmlServiceEvent.xml = _data;
        	xmlServiceEvent.message = FILE_LOADED;
        	dispatchEvent(xmlServiceEvent);      				
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
			var ioError:Error = new Error(XMLServiceEvent.XML_ERROR);
        	ioError.message = FILE_ERROR;
        	
        	var xmlServiceEvent:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.XML_ERROR);
        	xmlServiceEvent.message = FILE_ERROR;
        	xmlServiceEvent.error = ioError;
        	dispatchEvent(xmlServiceEvent); 
		}
	}
}