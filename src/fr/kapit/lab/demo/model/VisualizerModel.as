package fr.kapit.lab.demo.model
{
import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.lab.demo.models.ILayoutModel;
import fr.kapit.lab.demo.models.IShortcutManager;
import fr.kapit.lab.demo.util.DebugUtil;
import fr.kapit.lab.demo.util.SelectionUtil;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;

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
	 *  Nodes with a renderer different from defaultItemRenderer currently selected
	 */
	protected var _selectedNonDefaultRenderer:Array=[];


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
		_shortcutManager = new VisualizerShortcutManager(this);

		addVisualizerListeners(visualizer);
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
		_selectedNonDefaultRenderer=[];
		SelectionUtil.explodeList(visualizer.selection, _selectedNodes, _selectedGroups, _selectedEdges,_selectedNonDefaultRenderer);
	}


	/**
	 * Performs a pan and zoom to fit the Visualizer content to his container
	 *
	 * @see fr.kapit.visualizer.Visualizer#autoFit
	 */
	public function applyAutofit(withAnimation:Boolean = true):void
	{
		if (isLogEnabled)
			_logger.info("{0}.autoFit(" + withAnimation + ");", targetName);

		visualizer.autoFit(withAnimation,10,10,false,false);
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
	 * If <code>bExclusive</code> flag is set to <code>true</code>, then
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
	 * If <code>bExclusive</code> flag is set to <code>true</code>, then
	 * if there is another kind of element also selected, the method will
	 * return <code>false</code>.
	 *
	 * @param bExclusive
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
	 * If <code>bExclusive</code> flag is set to <code>true</code>, then
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
		if (! exclusive)
			return true;
		// exclusive node selection ?
		var othersCount:int = selectedGroups.length + selectedEdges.length+ selectedNonDefaultNodes.length;
		if (0 < othersCount)
			return false;
		return true;
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
	 * Nodes with renderers different from DefaultItemRenderer currently selected.
	 */
	public function get selectedNonDefaultNodes():Array
	{
		return _selectedNonDefaultRenderer;
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
	public function get layoutID():String
	{
		return visualizer.layoutID;
	}
	/** @private */
	public function set layoutID(strValue:String):void
	{
		if (isLogEnabled)
			_logger.info("{0}.layoutID = {1};", targetName, DebugUtil.layoutTypeToString(strValue));

		visualizer.layoutID = strValue;

		if (layoutModel)
			IDisposable(layoutModel).dispose();

		_layoutModel = new LayoutModel(targetName, strValue, visualizer.layout);
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
			_logger.info("{0}.mouseChildren = {1};", targetName, !bValue);
		}
		visualizer.enablePan = bValue;
		visualizer.mouseChildren = !bValue;
	}

	/**
	 * Return the logger instance.
	 */
	public function get objLogger():ILogger
	{
		return _logger;
	}
}
}