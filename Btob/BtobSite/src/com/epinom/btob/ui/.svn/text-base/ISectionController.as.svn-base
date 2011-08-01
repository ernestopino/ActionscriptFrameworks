package com.epinom.btob.ui
{
	import com.epinom.btob.data.SectionVO;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;

	public interface ISectionController
	{
		function get sectionVO():SectionVO;
		function set sectionVO(value:SectionVO):void;
		function get sectionMovie():MovieClip;
		function set sectionMovie(value:MovieClip):void;
		function addBackgroundImageContainer(backgroundImageContainer:DisplayObject, idClient:int = -1):void; 
		function buildSection(vo:SectionVO, idClient:String = null, idCase:String = null):void;
		function onBulkSectionLoadedHandler(evt:Event):void;
		function activateSection(idClient:String = null, idCase:String = null):void;
		function desactivateSection():void;
	}
}