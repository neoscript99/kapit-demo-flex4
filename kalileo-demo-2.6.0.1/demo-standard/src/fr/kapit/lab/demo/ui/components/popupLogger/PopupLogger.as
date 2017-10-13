package fr.kapit.lab.demo.ui.components.popupLogger
{
	import flash.display.DisplayObject;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	import fr.kapit.lab.demo.popup.TextualPopup;
	import fr.kapit.lab.demo.util.BuildInfo;
	import fr.kapit.lab.demo.util.LogPanelTarget;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.logging.Log;
	import mx.managers.PopUpManager;
	
	public class PopupLogger
	{
		/**
		 * Instance of the Popup to show logs
		 */
		protected var _logPopup:IFlexDisplayObject;
		
		/**
		 * ContextMenuItems to show / hide log popup
		 */
		protected var _showLogContextItem:ContextMenuItem;
		protected var _hideLogContextItem:ContextMenuItem;
		
		/**
		 * ContextMenuItem to show version number
		 **/
		private var _buildIndoContextItem:ContextMenuItem;
		
		/**
		 * Log target to push into log popup
		 */
		protected var _popupLogTarget:LogPanelTarget;
		
		public function PopupLogger()
		{
			FlexGlobals.topLevelApplication.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
			
			_logPopup = PopUpManager.createPopUp(DisplayObject(FlexGlobals.topLevelApplication), TextualPopup, false);
			_logPopup.x = FlexGlobals.topLevelApplication.width - 160 - _logPopup.width;
			_logPopup.y = 40;
			TextualPopup(_logPopup).title = "View source live console";
			TextualPopup(_logPopup).addEventListener(Event.CLOSE, closeLogPopupDemandHandler);
			_logPopup.visible = false;
			
			_popupLogTarget = new LogPanelTarget(TextualPopup(_logPopup).textarea);
			_popupLogTarget.includeDate = false;
			_popupLogTarget.includeTime = false;
			_popupLogTarget.includeCategory = false;
			_popupLogTarget.includeLevel = false;
			_popupLogTarget.filters = [ "fr.kapit.lab.demo.*" ];
			_popupLogTarget.fieldSeparator = "";
			Log.addTarget(_popupLogTarget);
			
			createContextItems();
		}
		
		private function applicationCompleteHandler(event:FlexEvent):void
		{
			FlexGlobals.topLevelApplication.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
			addVersionNumberToContextMenu();
		}
		
		protected function closeLogPopupDemandHandler(event:Event):void
		{
			hideLogHandler(null);
		}
		
		protected function createContextItems():void
		{
			_showLogContextItem = new ContextMenuItem("Show log");
			_showLogContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, showLogHandler);
			
			_hideLogContextItem = new ContextMenuItem("Hide log");
			_hideLogContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, hideLogHandler);
			
			updateContextMenu(_showLogContextItem);
			
			CONFIG::TDF
			{
				showLogHandler(null)
			}
		}
		
		private function addVersionNumberToContextMenu():void
		{
			var bytes:ByteArray = FlexGlobals.topLevelApplication.loaderInfo.bytes;
			var s:String = new BuildInfo(bytes).toString();
			_buildIndoContextItem = new ContextMenuItem(s);
			
			FlexGlobals.topLevelApplication.contextMenu.customItems.push(_buildIndoContextItem);
		}
		
		protected function updateContextMenu(showItem:ContextMenuItem):void
		{
			var demoContextMenu:ContextMenu = new ContextMenu();
			demoContextMenu.hideBuiltInItems();
			if (_buildIndoContextItem)
				demoContextMenu.customItems.push(_buildIndoContextItem);
			demoContextMenu.customItems.push(showItem);
			FlexGlobals.topLevelApplication.contextMenu = demoContextMenu;
		}
		
		protected function showLogHandler(event:ContextMenuEvent=null):void
		{
			updateContextMenu(_hideLogContextItem);
			_logPopup.visible = true;
		}
		
		protected function hideLogHandler(event:ContextMenuEvent):void
		{
			updateContextMenu(_showLogContextItem);
			_logPopup.visible = false;
		}
	}
}