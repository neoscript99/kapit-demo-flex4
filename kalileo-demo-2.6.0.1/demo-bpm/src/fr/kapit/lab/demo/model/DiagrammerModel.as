package fr.kapit.lab.demo.model
{
import flash.geom.Point;
import flash.net.FileFilter;
import flash.net.FileReference;

import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.diagrammer.Diagrammer;
import fr.kapit.diagrammer.actions.LinkAction;
import fr.kapit.diagrammer.actions.RedoAction;
import fr.kapit.diagrammer.actions.UndoAction;
import fr.kapit.diagrammer.actions.data.LinkActionData;
import fr.kapit.diagrammer.base.IDiagramSprite;
import fr.kapit.lab.demo.models.IDefaultGroupRendererModel;
import fr.kapit.lab.demo.models.IDefaultItemRendererModel;
import fr.kapit.lab.demo.models.IDiagrammerModel;
import fr.kapit.lab.demo.models.IGenericLinkModel;
import fr.kapit.lab.demo.models.IHistoryModel;
import fr.kapit.lab.demo.models.constants.DefaultLinkConstant;
import fr.kapit.lab.demo.util.DebugUtil;
import fr.kapit.layouts.constants.EdgeDrawType;
import fr.kapit.visualizer.actions.MultiSelectionAction;
import fr.kapit.visualizer.actions.PanAction;
import fr.kapit.visualizer.actions.ZoomAction;
import fr.kapit.visualizer.actions.data.SelectionActionData;
import fr.kapit.visualizer.actions.data.ZoomActionData;
import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;
import fr.kapit.visualizer.styles.LinkStyle;


[Bindable]
/**
 * Wrapper around the diagrammer instance.
 * This is done to dispatch what's going on, on the source code side, as
 * log message.
 */
public class DiagrammerModel extends VisualizerModel implements IDiagrammerModel
{
	/**
	 * Current instance of the diagrammer component.
	 */
	protected var _diagrammer:Diagrammer;


	/**
	 * List of active listeners
	 */
	protected var _listeners:Array = [];

	/**
	 * List of active listeners
	 */
	protected var _history:HistoryModel;


	/**
	 * Wrapper used to change the item renderer properties of the currently
	 * selected nodes.
	 */
	protected var _selectedNodeRenderersModel:NormalizedDefaultItemRendererModel;

	/**
	 * Wrapper used to change the item renderer properties of the currently
	 * selected groups.
	 */
	protected var _selectedGroupRenderersModel:NormalizedDefaultGroupRendererModel;

	/**
	 * Wrapper used to change the item renderer properties of the currently
	 * selected edges.
	 */
	protected var _selectedEdgesModel:NormalizedGenericLinkModel;


	/**
	 * Indicates if the selection state is active
	 */
	protected var _enableSelectAndResizeNodes:Boolean;

	/**
	 * Indicates if the link mode is active
	 */
	protected var _enableLinkMode:Boolean;

	/**
	 * Indicates if the multi-selection is active
	 */
	protected var _enableMultiSelection:Boolean;

	/**
	 * Indicates if the zoom is active
	 */
	protected var _enableZoom:Boolean;

	/**
	 * Constructor.
	 *
	 * @param value
	 * 		instance of the diagrammer component
	 */
	public function DiagrammerModel(value:Diagrammer)
	{
		super(value);
		_diagrammer = value;
		_targetName = "diagrammer";
		_history = new HistoryModel(_diagrammer);

		// replacing the visualizer shortcut manager.
		if (null != _shortcutManager)
			IDisposable(_shortcutManager).dispose();

		_shortcutManager = new DiagrammerShortcutManager(this);

		_selectedNodeRenderersModel = new NormalizedDefaultItemRendererModel(targetName, value);
		_selectedGroupRenderersModel = new NormalizedDefaultGroupRendererModel(targetName, value);
		_selectedEdgesModel = new NormalizedGenericLinkModel(targetName, value);
	}

	/**
	 * Current instance of the diagrammer component.
	 */
	public function get diagrammer():Diagrammer
	{
		return _diagrammer;
	}

	/**
	 * Current instance of the history model
	 */
	public function get history():IHistoryModel
	{
		return _history;
	}

	/**
	 *
	 * Registers a listener on the specified type event.
	 *
	 * @param type
	 * @param listener
	 * @param useCapture
	 *
	 */
	public function registerListener(type:String, listener:Function, useCapture:Boolean=false):void
	{
		_listeners.push({type:type, listener:listener, useCapture:useCapture});
		diagrammer.addEventListener(type, listener, useCapture);
	}

	/**
	 * Removes all the registered listeners
	 */
	public function unregisterAllListeners():void
	{
		for(var i:int=0; i<_listeners.length; ++i)
			diagrammer.removeEventListener(_listeners[i].type, _listeners[i].listener, _listeners[i].useCapture);
		_listeners = [];
	}

	/**
	 *  Undo last action
	 */
	public function undo():void
	{
		if (isLogEnabled)
			_logger.info("{0}.messageAction(UndoAction.ID,'undo');", targetName);

		diagrammer.messageAction(UndoAction.ID,'undo');
	}

	/**
	 *  Redo previous undoed action
	 */
	public function redo():void
	{
		if (isLogEnabled)
			_logger.info("{0}.messageAction(RedoAction.ID,'redo');", targetName);

		diagrammer.messageAction(RedoAction.ID,'redo');
	}

	/**
	 * @private
	 * Traces the event dispatched by the visualizer component.
	 *
	 * @param event
	 */
	override protected function traceVisualizerEvent(event:VisualizerEvent):void
	{
		// nothing
	}

	/**
	 * @private
	 * Extracts the nodes / groups / edges from the current selection
	 *
	 * @param event
	 */
	override protected function selectionChangedHandler(event:VisualizerEvent):void
	{
		super.selectionChangedHandler(event);
	
		_selectedNodeRenderersModel.updateSource(selectedNodes);
		_selectedGroupRenderersModel.updateSource(selectedGroups);
		_selectedEdgesModel.updateSource(selectedEdges);
	
	}


	/**
	 *
	 * Allows to fix size and position of nodes
	 *
	 * @param fixed Boolean indicates if nodes are movables and resizable or not.
	 *
	 */
	public function enableSelectAndResizeNodes(bValue:Boolean):void
	{
		if (isLogEnabled)
			_logger.info([
				"for each(var obj:DiagramSprite in {0}.nodesMap) {" ,
				"\tobj.isFixed = {1};",
				"\tobj.isSizeFixed = {1};",
				"}"
			].join("\n"), targetName, !bValue
		);

		_enableSelectAndResizeNodes = !bValue;

		for each(var obj:* in diagrammer.nodesMap)
		{
			if(obj is IDiagramSprite)
			{
				obj.isFixed = !bValue;
				obj.isSizeFixed = !bValue;
			}
		}
	}

	public function isEnableSelectAndResizeNodes():Boolean
	{
		return _enableSelectAndResizeNodes;
	}

	/**
	 *
	 * Adds a node with the specified dats at the specified position
	 *
	 * @param data
	 * @param position
	 *
	 */
	public function addNode(label:String, renderer:String, position:Point, size:int=50,container:IGroup=null):ISprite
	{
		if (isLogEnabled)
		{
			_logger.info(
				"{0}.addNodeElement({label:'{1}', renderer:'{2}', size:'{3}'}, null, null, new Point({4}, {5}));",
				targetName, label, renderer, size, position.x, position.y
			);
		}
		var ratio:Number = diagrammer.ratio;
		var node:ISprite = diagrammer.addNodeElement({label:label, renderer:renderer, size:size}, container, null, position);
		if(node)
		{
			node.x -= node.width*0.5*ratio;
			node.y -= node.height*0.5*ratio;
		}
		
		return node; 
	}

	public function updateDefaultLinkLine():void
	{
		isLogEnabled = false;
		var linkActionData:LinkActionData = diagrammer.getActionData(LinkAction.ID) as LinkActionData;

		if(layoutModel && layoutModel.layoutType == "orthogonal")
		{
			linkActionData.linkLine = EdgeDrawType.ORTHOGONAL_STRAIGHT_POLYLINE;
		}
		else
		{
			linkActionData.linkLine = EdgeDrawType.STRAIGHT_LINE;
		}
		diagrammer.updateAction(LinkAction.ID, linkActionData);
		isLogEnabled = true;
	}

	/**
	 * Create a new group with the selected nodes
	 */
	public function createGroup():void
	{
		if (isLogEnabled)
			_logger.info("{0}.groupElements(new Object(), {0}.selection);", targetName);

		diagrammer.groupElements({label:'Title'}, selectedNodes,null,null,true);
	}

	/**
	 * Destroy selected groups
	 */
	public function destroyGroups():void
	{
		if (isLogEnabled)
		{
			_logger.info( [
				"var selection:Array = {0}.selection.concat();",
				"{0}.unselectAll();",
				"{0}.unGroupElements(selection);"
			].join("\n"), targetName
			);
		}

		var selection:Array = selectedGroups.concat();
		diagrammer.unselectAll();
		diagrammer.unGroupElements(selection);
	}

	/**
	 * Export graph to XML.
	 * 
	 */	
	public function exportGraph():void
	{
		var xml:XML = diagrammer.toXML();
		var fileReference:FileReference = new FileReference();
		fileReference.save(xml, "exportedData.xml");
	}

	/**
	 * Import graph to diagrammer.
	 * @param xml Imported xml. 
	 * 
	 */	 
	private var file_ref:FileReference;
	public function importGraph():void
	{
        file_ref = new FileReference();
        file_ref.addEventListener(Event.SELECT, onSelect);
        file_ref.browse([new FileFilter("Data","*.xml")]);
	}
	private function onSelect(e:Event):void
	{
        file_ref.addEventListener(Event.COMPLETE, onData);
        file_ref.load();
	}
	private function onData(e:Event):void
	{
        var xml:XML =new XML( file_ref.data );
		diagrammer.fromXML(xml);
	}
	/**
	 * Wrapper used to change the properties of the currently selected edges.
	 */
	public function get selectedEdgesModel():IGenericLinkModel
	{
		return _selectedEdgesModel;
	}
	/**
	 * Wrapper used to change the item renderer properties of the currently
	 * selected nodes.
	 */
	public function get selectedNodeRenderersModel():IDefaultItemRendererModel
	{
		return _selectedNodeRenderersModel;
	}
	/**
	 * Wrapper used to change the item renderer properties of the currently
	 * selected nodes.
	 */
	public function get selectedGroupRenderersModel():IDefaultGroupRendererModel
	{
		return _selectedGroupRenderersModel;
	}

	/**
	 *
	 * Defines the linkStyle property that will apply on new created links
	 *
	 * @param value can be <code>simpleArrow</code>, <code>doubleArrow</code>, <code>simpleLink</code>, <code>dashedLink</code>
	 *
	 */
	public function set defaultLinkStyle(value:Object):void
	{
		var linkStyle:LinkStyle = new LinkStyle();
		var logLinkProperties:String;

		switch(value)
		{
			case DefaultLinkConstant.SIMPLE_ARROW :
				linkStyle.arrowTargetType = LinkStyle.LINK_ARROW_ARROW_TYPE;
				linkStyle.arrowSourceType = LinkStyle.LINK_ARROW_NONE_TYPE;
				logLinkProperties = "\nlinkStyle.arrowTargetType = LinkStyle.LINK_ARROW_ARROW_TYPE;";
			break;
			case DefaultLinkConstant.DOUBLE_ARROW :
				linkStyle.arrowTargetType = LinkStyle.LINK_ARROW_ARROW_TYPE;
				linkStyle.arrowSourceType = LinkStyle.LINK_ARROW_ARROW_TYPE;
				logLinkProperties = "\nlinkStyle.arrowTargetType = LinkStyle.LINK_ARROW_ARROW_TYPE;";
				logLinkProperties += "\nlinkStyle.arrowSourceType = LinkStyle.LINK_ARROW_ARROW_TYPE;";
			break;
			case DefaultLinkConstant.SIMPLE_LINK :
				linkStyle.arrowTargetType = LinkStyle.LINK_ARROW_NONE_TYPE;
				linkStyle.arrowSourceType = LinkStyle.LINK_ARROW_NONE_TYPE;
			break;
			case DefaultLinkConstant.DASHED_LINK :
				linkStyle.arrowTargetType = LinkStyle.LINK_ARROW_NONE_TYPE;
				linkStyle.arrowSourceType = LinkStyle.LINK_ARROW_NONE_TYPE;
				linkStyle.renderingPolicy = LinkStyle.LINK_RENDERING_DASH;
				logLinkProperties = "\nlinkStyle.renderingPolicy = LinkStyle.LINK_RENDERING_DASH;";
			break;
		}

		if (isLogEnabled)
		{
			_logger.info([
					"var linkStyle:LinkStyle = new LinkStyle();{0}",
					"var linkActionData:LinkActionData = new LinkActionData();",
					"linkActionData.linkStyle = linkStyle;",
					"{1}.updateAction(LinkAction.ID, linkActionData);"
				].join("\n"), logLinkProperties, targetName
			);
		}

		var linkActionData:LinkActionData = diagrammer.getActionData(LinkAction.ID) as LinkActionData;
		linkActionData.linkStyle = linkStyle;
		linkActionData.linkLine = EdgeDrawType.ORTHOGONAL_CURVED_POLYLINE;
		diagrammer.updateAction(LinkAction.ID, linkActionData);
	}

	/**
	 *
	 * Activates (or deactivates) the possibility to add links between nodes
	 *
	 * @param value
	 *
	 */
	public function set enableLinkMode(value:Boolean):void
	{
		_enableLinkMode = value;
		if(value)
		{
			if (isLogEnabled)
				_logger.info("{0}.activateAction(LinkAction.ID);", targetName);

			diagrammer.activateAction(LinkAction.ID);
		}
		else
		{
			if (isLogEnabled)
				_logger.info("{0}.deactivateAction(LinkAction.ID);", targetName);

			diagrammer.deactivateAction(LinkAction.ID);
		}
	}

	public function get enableLinkMode():Boolean
	{
		return _enableLinkMode;
	}

	/**
	 *
	 * Activates (or deactivates) the multi-selection
	 *
	 * @param value
	 *
	 */
	public function set enableMultiSelection(value:Boolean):void
	{
		_enableMultiSelection = value;
		if (!value)
		{
			if (isLogEnabled)
				_logger.info("{0}.deactivateAction(MultiSelectionAction.ID);", targetName);

			diagrammer.deactivateAction(MultiSelectionAction.ID);
		}
		else
		{
			if (isLogEnabled)
			{
				_logger.info( [
						"var data:SelectionActionData = new SelectionActionData();",
						"data.isExclusive = true;",
						"{0}.deactivateAction(PanAction.ID);",
						"{0}.activateAction(MultiSelectionAction.ID,data);"
					].join("\n"), targetName
				);
			}

			var data:SelectionActionData = new SelectionActionData();
			data.isExclusive = false;
			diagrammer.deactivateAction(PanAction.ID);
			diagrammer.activateAction(MultiSelectionAction.ID,data);
		}
	}

	public function get enableMultiSelection():Boolean
	{
		return _enableMultiSelection;
	}
	
	/**
	 *
	 * Activates (or deactivates) the zoom
	 *
	 * @param value
	 *
	 */
	public function enableZoom(value:Boolean, isOutState:Boolean):void
	{
		_enableZoom = true;
		if (!value)
		{
			if (isLogEnabled)
				_logger.info("{0}.deactivateAction(ZoomAction.ID);", targetName);
			
			diagrammer.deactivateAction(ZoomAction.ID);
		}
		else
		{
			if (isLogEnabled)
			{
				_logger.info( [
					"var data:ZoomActionData = new ZoomActionData;",
					"data.zoomOutTool = "+ isOutState,
					"data.zoomInTool = "+ !isOutState,
					"data.zoomOutToolCursor = null;",
					"data.zoomInToolCursor = null;",
					"data.zoomWithArea = true;",
					"{0}.updateAction(ZoomAction.ID, data);",
				].join("\n"), targetName
				);
			}
			
			var data:ZoomActionData = new ZoomActionData;
			data.zoomOutTool = isOutState;
			data.zoomInTool = !isOutState;
			data.zoomOutToolCursor = null;
			data.zoomInToolCursor = null;
			data.zoomWithArea = true;
			diagrammer.updateAction(ZoomAction.ID, data);
		}
	}

	/**
	 * Affects the <code>backgroundColors</code> style.
	 */
	public function get backgroundColorsStyle():Array
	{
		return visualizer.getStyle("backgroundColors") as Array;
	}
	public function set backgroundColorsStyle(aValue:Array):void
	{
		if (isLogEnabled)
			_logger.info("{0}.setStyle(\"{1}\", [{2}]);", targetName, "backgroundColors", DebugUtil.colorsToStrings(aValue));

		visualizer.setStyle("backgroundColors", aValue);
	}

}
}