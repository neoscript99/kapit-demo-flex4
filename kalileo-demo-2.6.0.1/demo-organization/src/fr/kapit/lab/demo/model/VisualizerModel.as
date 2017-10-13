package fr.kapit.lab.demo.model
{
import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.diagrammer.actions.LinkAction;
import fr.kapit.diagrammer.actions.data.LinkActionData;
import fr.kapit.diagrammer.base.IDiagramSprite;
import fr.kapit.lab.demo.models.IDefaultGroupRendererModel;
import fr.kapit.lab.demo.models.IDefaultItemRendererModel;
import fr.kapit.lab.demo.models.IGenericLinkModel;
import fr.kapit.lab.demo.models.IHistoryModel;
import fr.kapit.lab.demo.models.ILayoutModel;
import fr.kapit.lab.demo.models.IShortcutManager;
import fr.kapit.lab.demo.models.constants.DefaultLinkConstant;
import fr.kapit.lab.demo.util.DebugUtil;
import fr.kapit.lab.demo.util.SelectionUtil;
import fr.kapit.layouts.layouts_internal;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.actions.MultiSelectionAction;
import fr.kapit.visualizer.actions.ZoomAction;
import fr.kapit.visualizer.actions.data.SelectionActionData;
import fr.kapit.visualizer.actions.data.ZoomActionData;
import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;
import fr.kapit.visualizer.renderers.DefaultGroupRenderer;
import fr.kapit.visualizer.renderers.DefaultItemRenderer;
import fr.kapit.visualizer.styles.LinkStyle;

import mx.logging.ILogger;
import mx.logging.Log;


[Bindable]
/**
 * Wrapper around the visualizer instance.
 * This is done to dispatch what's going on, on the source code side, as
 * log message.
 */
public class VisualizerModel implements IDisposable
{
	/**
	 * Logger instance.
	 */
	protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.VisualizerModel");

	/**
	 * @private
	 * Whether logs should be dispatched.
	 */
	private var _isLogEnabled:Boolean = true


	/**
	 * Current instance of the visualizer component.
	 */
	protected var _visualizer:Visualizer;

	/**
	 * Canonical name of the data visualization component (ex: "visualizer").
	 * Used by log messages.
	 */
	protected var _targetName:String = "visualizer";

	/**
	 * Wrapper used to set the layout.
	 */
	protected var _layoutModel:ILayoutModel;

	/**
	 * Abstraction to control the shortcuts events.
	 */
	protected var _shortcutManager:IShortcutManager;


	/**
	 * Links currently selected.
	 */
	protected var _selectedEdges:Array = [];
	/**
	 * Nodes currently selected.
	 */
	protected var _selectedNodes:Array = [];
	/**
	 * Groups currently selected.
	 */
	protected var _selectedGroups:Array = [];



	/**
	 * Constructor.
	 *
	 * @param value
	 * 		instance of the visualizer component
	 */
	public function VisualizerModel(value:Visualizer)
	{
		assert(null != value);
		_visualizer = value;
		_targetName = "visualizer";

		addVisualizerListeners(visualizer);
		
		_selectedNodeRenderersModel = new NormalizedDefaultItemRendererModel(targetName, value);
		_selectedGroupRenderersModel = new NormalizedDefaultGroupRendererModel(targetName, value);
		_selectedEdgesModel = new NormalizedGenericLinkModel(targetName, value);
		
	}


	/**
	 * Explicit references clean up.
	 * The current instance may not be considered usable there after, so
	 * one should call the <code>dispose()</code> method before an
	 * object gets "destroyed".
	 * <p>
	 * The <code>recursive</code> parameter is intended to be used
	 * on composite classes : for example, a collection may try to apply
	 * <code>dispose()</code> on each of its elements.
	 * </p>
	 *
	 * @see http://en.wikipedia.org/wiki/Dispose
	 *
	 * @param recursive
	 * 		if set to <code>true</code> then the clean up is recusively done.
	 */
	public function dispose(recursive:Boolean=false):void
	{
		if (null != shortcutManager)
		{
			IDisposable(shortcutManager).dispose(recursive);
			_shortcutManager = null;
		}
		if (null != visualizer)
		{
			removeVisualizerListeners(visualizer);
			_visualizer = null;
		}
	}


	/**
	 * Adds event listeners to the current visulaizer instance.
	 *
	 * @param value
	 * 		visualizer instance
	 */
	protected function addVisualizerListeners(value:Visualizer):void
	{
		value.addEventListener(VisualizerEvent.ELEMENTS_DELETED, elementsDeletedHandler);
		value.addEventListener(VisualizerEvent.GROUP_ELEMENTS, groupElementsCreatedHandler);
		value.addEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, selectionChangedHandler, false, 10, true);

		// event debugging
		value.addEventListener(VisualizerEvent.GRAPH_PANNED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.GRAPH_ZOOMED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.GRAPH_FITTED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_CREATED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_DELETED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_DRAG_STARTED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_DRAGGING, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_DRAG_FINISHED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENTS_EXPANDED_COLLAPSED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENT_CLICKED, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENT_ROLL_OVER, traceVisualizerEvent);
		value.addEventListener(VisualizerEvent.ELEMENT_ROLL_OUT, traceVisualizerEvent);
	}
	/**
	 * Removes event listeners from the visualizer instance.
	 *
	 * @param value
	 * 		visualizer instance
	 */
	protected function removeVisualizerListeners(value:Visualizer):void
	{
		value.removeEventListener(VisualizerEvent.GROUP_ELEMENTS, groupElementsCreatedHandler);
		value.removeEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, selectionChangedHandler);

		// event debugging
		value.removeEventListener(VisualizerEvent.GRAPH_PANNED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.GRAPH_ZOOMED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.GRAPH_FITTED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_CREATED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_DELETED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_DRAG_STARTED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_DRAGGING, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_DRAG_FINISHED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENTS_EXPANDED_COLLAPSED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENT_CLICKED, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENT_ROLL_OVER, traceVisualizerEvent);
		value.removeEventListener(VisualizerEvent.ELEMENT_ROLL_OUT, traceVisualizerEvent);
	}


	/**
	 * @private
	 * Traces the event dispatched by the visualizer component.
	 *
	 * @param event
	 */
	protected function traceVisualizerEvent(event:VisualizerEvent):void
	{
	}

	/**
	 * @private
	 * Called when a group is created
	 *
	 * @param event
	 */
	protected function groupElementsCreatedHandler(event:VisualizerEvent):void
	{
		unselectAll();
	}

	/**
	 * @private
	 * Called when elements are deleted
	 *
	 * @param event
	 */
	protected function elementsDeletedHandler(event:VisualizerEvent):void
	{
		unselectAll();
	}



	/**
	 * Performs a pan and zoom to fit the Visualizer content to his container
	 *
	 * @see fr.kapit.visualizer.Visualizer#autoFit
	 */
	public function applyAutofit():void
	{
		if (isLogEnabled)
			_logger.info("{0}.autoFit();", targetName);

		visualizer.autoFit();
	}

	/**
	 * Performs a pan and zoom to center the Visualizer content and render
	 * it with a 1:1 scale
	 *
	 * @see fr.kapit.visualizer.Visualizer#centerContent
	 * @see fr.kapit.visualizer.Visualizer#zoomContent
	 */
	public function applyZoomCenter():void
	{
		if (isLogEnabled)
		{
			_logger.info([
					"{0}.centerContent();" ,
					"{0}.zoomContent(1, null, false);"
				].join("\n"), targetName
			);
		}
		visualizer.centerContent();
		visualizer.zoomContent(1,null,false);
	}

	/**
	 * Performs a zoom on Visualizer content according to the
	 * ratio given in parameter.
	 * For example, a <code>ratio</code> of <code>1.1</code> results
	 * in a 10% zoom increase (id est <code>1.1</code> <=> 110%).
	 *
	 * @param ratio a Number representing the scale of the component
	 *
	 */
	public function zoom(ratio:Number):void
	{
		if (isLogEnabled)
			_logger.info("{0}.zoomContent({1}, null, false, false);", targetName, ratio);

		visualizer.zoomContent(ratio,null,false,false);
	}


	/**
	 * Unselect all elements
	 */
	public function unselectAll():void
	{
		if (isLogEnabled)
			_logger.info("{0}.unselectAll();", targetName);

		visualizer.unselectAll();

		/* force unselect hack : */
		visualizer.dispatchVisualizerEvent(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, []);
	}

	/**
	 * Changes the selection with given elements
	 *
	 * @param elements
	 * 		Array of elements to add in the selection
	 */
	public function createNewSelection(elements:Array):void
	{
		unselectAll();
		if(elements)
		{
			for each(var item:ISprite in elements)
			{
				item.isSelected = true;
			}
		}
		visualizer.dispatchVisualizerEvent(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, elements);
	}

	/**
	 * Checks whether there is one or more group selected.
	 * If <code>exclusive</code> flag is set to <code>true</code>, then
	 * if there is another kind of element also selected, the method will
	 * return <code>false</code>.
	 *
	 * @param exclusive
	 * 		whether the check should take care of other type of elements
	 * @return
	 * 		boolean
	 */
	public function isGroupSelection(exclusive:Boolean=true):Boolean
	{
		if (0 == selectedGroups.length)
			return false;
		if (!exclusive)
			return true;
		
		// exclusive group selection ?
		var othersCount:int = selectedEdges.length + selectedNodes.length;
		if (0 < othersCount)
			return false;
		return true;
	}
	
	/**
	 * Checks whether there is one or more edge (link) selected.
	 * If <code>exclusive</code> flag is set to <code>true</code>, then
	 * if there is another kind of element also selected, the method will
	 * return <code>false</code>.
	 *
	 * @param exclusive
	 * 		whether the check should take care of other type of elements
	 * @return
	 * 		boolean
	 */
	public function isEdgeSelection(exclusive:Boolean=true):Boolean
	{
		if (0 == selectedEdges.length)
			return false;
		if (! exclusive)
			return true;
		// exclusive edge selection ?
		var othersCount:int = selectedGroups.length + selectedNodes.length;
		if (0 < othersCount)
			return false;
		return true;
	}
	/**
	 * Checks whether there is one or more node selected.
	 * If <code>exclusive</code> flag is set to <code>true</code>, then
	 * if there is another kind of element also selected, the method will
	 * return <code>false</code>.
	 *
	 * @param exclusive
	 * 		whether the check should take care of other type of elements
	 * @return
	 * 		boolean
	 */
	public function isNodeSelection(exclusive:Boolean=true):Boolean
	{
		if (0 == selectedNodes.length)
			return false;
		if (!exclusive)
			return true;
		// exclusive node selection ?
		var othersCount:int = selectedGroups.length + selectedEdges.length;
		if (0 < othersCount)
			return false;
		return true;
	}
	
	/**
	 * Checks whether there is one or more uneditable artefacts selected.
	 * If <code>exclusive</code> flag is set to <code>true</code>, then
	 * if there is another kind of element also selected, the method will
	 * return <code>false</code>.
	 *
	 * @param exclusive
	 * 		whether the check should take care of other type of elements
	 * @return
	 */
	public function isSelectionNonEditable(exclusive:Boolean):Boolean
	{
		if (selectedNodes.length==0 && selectedGroups.length==0)
			return false;
		if (!exclusive)
			return true;
		var node:ISprite;
		for each(node in selectedNodes)
		{
			if(!(node.itemRenderer is DefaultItemRenderer))
				return true;
		}
		var group:IGroup;
		for each(group in selectedGroups)
		{
			if(!(group.itemRenderer is DefaultGroupRenderer))
				return true;
		}
		return false;
	}

	/**
	 * Canonical name of the data visualization component (ex: "visualizer").
	 * Used by log messages.
	 */
	public function get targetName():String
	{
		return _targetName;
	}

	/**
	 * Current instance of the visualizer component.
	 */
	public function get visualizer():Visualizer
	{
		return _visualizer;
	}

	/**
	 * Abstraction to control the shortcuts events.
	 */
	public function get shortcutManager():IShortcutManager
	{
		return _shortcutManager;
	}

	/**
	 * Wrapper used to configure the layout.
	 */
	public function get layoutModel():ILayoutModel
	{
		return _layoutModel;
	}

	/**
	 * Links currently selected.
	 */
	public function get selectedEdges():Array
	{
		return _selectedEdges;
	}
	/**
	 * Nodes currently selected.
	 */
	public function get selectedNodes():Array
	{
		return _selectedNodes;
	}
	/**
	 * Groups currently selected.
	 */
	public function get selectedGroups():Array
	{
		return _selectedGroups;
	}

	/**
	 * Is there something selected ? node, group, link or whatever ?
	 */
	public function get isSelectionEmpty():Boolean
	{
		if (0 < selectedNodes.length)
			return false;
		if (0 < selectedEdges.length)
			return false;
		if (0 < selectedGroups.length)
			return false;
		return true;
	}

	/**
	 * Whether logs should be dispatched.
	 */
	public function get isLogEnabled():Boolean
	{
		return _isLogEnabled;
	}
	/** @private */
	public function set isLogEnabled(bValue:Boolean):void
	{
		_isLogEnabled = bValue;
	}

	/**
	 * Visualizer Data provider. It can be :
	 * <ul>
	 * <li> CSV file as String: When using a CSV as your <code>dataProvider</code> make sure to give
	 * an <code>analysisPath</code> and the <code>delimiter</code> string in order to parse
	 * the CSV correctly and generate the appropriate analysis graph.
	 * @example
	 * <listing version="3.0">
	 * Entreprise,Department,EmployeeID,Age
	 * Enterp,D1,D11,21
	 * Enterp,D1,D12,52
	 * Enterp,D1,D13,23
	 * Enterp,D2,D21,26
	 * Enterp,D2,D22,59
	 * Enterp,D3,D31,32
	 * ...
	 * </listing>
	 * In this Example, the Analysis Path can be ["Entreprise", "Department", "EmployeeID"] or ["Entreprise", "EmployeeID"];
	 * </li>
	 *
	 * <li> Any object with the children keyword : Analysis is performed in an Hierarchical way without taking into account the <code>analysisPath</code>
	 * attribute and a visibility level (displayed levels) can be controlled via the <code>visibilityLevel</code> attribute.
	 * Expand/Collapse features are also enabled by default for such type.</li>
	 * <li> XML and XMLListCollection : The <code>dataProvider</code> will be analysed according to the XML Hierarchy structure.
	 * <li> ICollectionView instances</li>
	 * </ul>
	 *
	 */
	public function get dataProvider():Object
	{
		return _visualizer.dataProvider;
	}
	/** @private */
	public function set dataProvider(objValue:Object):void
	{
		if (isLogEnabled)
			_logger.info("{0}.dataProvider = {1};", targetName, DebugUtil.dataProviderToString(objValue));

		_visualizer.dataProvider = objValue;
	}

	/**
	 * Current Visualizer layout string reference.
	 * When setting a new layout, specify a layout via its
	 * <code>String</code> reference (e.g SingleCycleCircularLayout.ID).
	 * <b>This way of setting layout is recommended.</b>
	 *
	 * @see fr.kapit.visualizer.Visualizer#layoutID
	 * @see fr.kapit.visualizer.Visualizer#layout
	 */
	private var _layoutID:String;
	
	public function get layoutID():String
	{
		return _layoutID?_layoutID:visualizer.layoutID;
	}
	/** @private */
	public function set layoutID(strValue:String):void
	{
		if (isLogEnabled)
			_logger.info("{0}.layoutID = {1};", targetName, DebugUtil.layoutTypeToString(strValue));

		var selection:Array = visualizer.selection;
		var groupsList:Array = [];
		var group:IGroup;
		for each(var o:Object in selection)
		{
			group = o as IGroup
			if(group && group.isGroupExpanded)
				groupsList.push(group);
		}
		
		if(groupsList.length==0)
		{
			visualizer.layoutID = strValue;
			
			if (layoutModel)
				IDisposable(layoutModel).dispose();
			_layoutID = visualizer.layoutID;
			_layoutModel = new LayoutModel(targetName, strValue, visualizer.layout);
		}
		else
		{
			for each(var g:IGroup in groupsList)
			{
				g.layout = strValue;
				
				if (layoutModel)
					IDisposable(layoutModel).dispose();
				_layoutID = g.layout.layoutID;
				_layoutModel = new LayoutModel(targetName, strValue, g.layout);
			}
		}
	}

	/**
	 * Indicator if the Visualizer content should be animated
	 * on layout (animating zoom and position).
	 *
	 * @see fr.kapit.visualizer.Visualizer#enableAnimation
	 */
	public function get enableAnimation():Boolean
	{
		return visualizer.enableAnimation;
	}
	/** @private */
	public function set enableAnimation(bValue:Boolean):void
	{
		if (isLogEnabled)
			_logger.info("{0}.enableAnimation = {1};", targetName, bValue);

		visualizer.enableAnimation = bValue;
	}

	/**
	 * Indicator if selected elements can be dragged and re-positionned.
	 *
	 * @see fr.kapit.visualizer.Visualizer#enableSelectionDrag
	 */
	public function get enableSelectionDrag():Boolean
	{
		return visualizer.enableSelectionDrag;
	}
	/** @private */
	public function set enableSelectionDrag(bValue:Boolean):void
	{
		if (isLogEnabled)
			_logger.info("{0}.enableSelectionDrag = {1};", targetName, bValue);

		visualizer.enableSelectionDrag = bValue;
	}

	/**
	 * Indicator if graphe can be panned.
	 *
	 * @see fr.kapit.visualizer.Visualizer#enablePan
	 */
	public function get enablePan():Boolean
	{
		return visualizer.enablePan;
	}
	/** @private */
	public function set enablePan(bValue:Boolean):void
	{
		if (isLogEnabled)
		{
			_logger.info("{0}.enablePan = {1};", targetName, bValue);
		}
		visualizer.enablePan = bValue;
	}

	/**
	 * Return the logger instance.
	 */
	public function get objLogger():ILogger
	{
		return _logger;
	}
	
	public function syncLayoutModel():void
	{
		var selection:Array = visualizer.selection;
		var groupsList:Array = [];
		var group:IGroup;
		for each(var o:Object in selection)
		{
			group = o as IGroup
			if(group)
				groupsList.push(group);
		}
		if(groupsList.length==0)
		{
			if (layoutModel)
				IDisposable(layoutModel).dispose();
			_layoutID = visualizer.layoutID;
			_layoutModel = new LayoutModel(targetName, _layoutID, visualizer.layout);
		}
		else
		{
			for each(var g:IGroup in groupsList)
			{
				if (layoutModel)
					IDisposable(layoutModel).dispose();
				if(!g || !g.layout)
					continue;
				_layoutID = g.layout.layoutID;
				_layoutModel = new LayoutModel(targetName, _layoutID, g.layout);
			}
		}
	}
	/**
	 * List of active listeners
	 */
	protected var _listeners:Array = [];
	
	/**
	 * Instance of history model
	 */
	protected var _history:IHistoryModel;
	
	
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
	 * Indicates if there are any nodes
	 */
	public var isEmpty:Boolean;
	
	
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
		visualizer.addEventListener(type, listener, useCapture);
	}
	
	/**
	 * Removes all the registered listeners
	 */
	public function unregisterAllListeners():void
	{
		for(var i:int=0; i<_listeners.length; ++i)
			visualizer.removeEventListener(_listeners[i].type, _listeners[i].listener, _listeners[i].useCapture);
		_listeners = [];
	}
	
	
	
	/**
	 * @private
	 * Extracts the nodes / groups / edges from the current selection
	 *
	 * @param event
	 */
	protected function selectionChangedHandler(event:VisualizerEvent):void
	{
		_selectedNodes = [];
		_selectedGroups = [];
		_selectedEdges = [];
		
		SelectionUtil.explodeList(visualizer.selection, _selectedNodes, _selectedGroups, _selectedEdges);
		
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
	public function enableSelectAndResizeNodes(value:Boolean):void
	{
		if (isLogEnabled)
			_logger.info([
				"for each(var obj:DiagramSprite in {0}.nodesMap) {" ,
				"\tobj.isFixed = {1};",
				"\tobj.isSizeFixed = {1};",
				"}"
			].join("\n"), targetName, !value
			);
		
		_enableSelectAndResizeNodes = !value;
		
		for each(var obj:* in visualizer.nodesMap)
		{
			if(obj is IDiagramSprite)
			{
				obj.isFixed = !value;
				obj.isSizeFixed = !value;
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
	
	public function removeAll():void
	{
		_logger.info("{0}.removeAll();", targetName);
		visualizer.removeAll();
		isEmpty = true;
	}
	
	
	/**
	 * Create a new group with the selected nodes
	 */
	public function createGroup():void
	{
		if (isLogEnabled)
			_logger.info("{0}.groupElements(new Object(), {0}.selection);", targetName);
		
		var group:IGroup = visualizer.groupElements({label:'Title'}, visualizer.selection.concat(),null,null,true);
		if(!group)
			return;
		group.isSelected = true;
		visualizer.dispatchVisualizerEvent(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, visualizer.selection);
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
		visualizer.unselectAll();
		visualizer.unGroupElements(selection);
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
		
		var linkActionData:LinkActionData = visualizer.getActionData(LinkAction.ID) as LinkActionData;
		linkActionData.linkStyle = linkStyle;
		visualizer.updateAction(LinkAction.ID, linkActionData);
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
			
			visualizer.activateAction(LinkAction.ID);
		}
		else
		{
			if (isLogEnabled)
				_logger.info("{0}.deactivateAction(LinkAction.ID);", targetName);
			
			visualizer.deactivateAction(LinkAction.ID);
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
			
			visualizer.deactivateAction(MultiSelectionAction.ID);
		}
		else
		{
			if (isLogEnabled)
			{
				_logger.info( [
					"var data:SelectionActionData = new SelectionActionData();",
					"data.isExclusive = true;",
					"{0}.activateAction(MultiSelectionAction.ID,data);"
				].join("\n"), targetName
				);
			}
			
			var data:SelectionActionData = new SelectionActionData();
			data.isExclusive = false;
			visualizer.activateAction(MultiSelectionAction.ID,data);
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
			
			visualizer.deactivateAction(ZoomAction.ID);
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
			visualizer.updateAction(ZoomAction.ID, data);
		}
	}
	
	public function get isZoomEnabled():Boolean
	{
		return _enableZoom;
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