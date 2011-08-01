package com.epinom.vetusta.musicexperience.ui
{
	import caurina.transitions.Tweener;
	
	import com.epinom.vetusta.musicexperience.data.DataModel;
	import com.epinom.vetusta.musicexperience.events.EventComplex;
	
	import fl.controls.Slider;
	import fl.events.SliderEvent;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ToolBar extends MovieClip
	{		
		private var _playlist:Playlist;
		private var _player:Player;
		private var _zoom:Zoom;
		
		public function ToolBar()
		{
			super();
			trace("ToolBar->ToolBar()");
				
			// Guardando referencias a componentes visuales
			_playlist = playlistComponent;
			_player = playerComponent;
			_zoom = zoomComponent;
			
			// Inicializando componente
			init();
		}
		
		public function get zoom():Zoom { return _zoom; }
		
		private function init():void
		{
			// Configurando detectores de eventos
			_playlist.addEventListener(DataModel.USER_CHANGE_TRACK_EVENT, userChangeTrackHandler);
			_player.addEventListener(DataModel.COMPLETE_TRACK_EVENT, onCompleteTrackEventHandler);
			_player.addEventListener(DataModel.SOUND_SELECTED_LOADED, onSoundSelectedLoadedEventHandler);
		}
		
		public function userChangeTrackHandler(evt:EventComplex):void
		{
			trace("[ToolBar] Evento USER_CHANGE_TRACK_EVENT capturado: ", evt.data.trackIndex);
			
			// Pasandole evento capturado al player para que actualice la cancion seleccionada por el usuario
			_player.userChangeTrackHandler(evt);
		}
		
		private function onCompleteTrackEventHandler(evt:Event):void 
		{
			trace("[ToolBar] Track complete event captured...");
			_playlist.nextTrack();
		}
		
		private function onSoundSelectedLoadedEventHandler(evt:Event):void 
		{
			trace("[ToolBar] Sound loaded event captured...");
			_playlist.stopActivityIndicator();
		}
	}
}