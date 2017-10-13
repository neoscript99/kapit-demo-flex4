package fr.kapit.lab.demo.model
{
import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.lab.demo.models.IDefaultGroupRendererModel;
import fr.kapit.lab.demo.util.DebugUtil;
import fr.kapit.lab.demo.util.DefaultGroupRendererNormalizer;
import fr.kapit.lab.demo.util.NormalizedValue;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;
import fr.kapit.visualizer.renderers.DefaultGroupRenderer;

import mx.logging.ILogger;
import mx.logging.Log;

import spark.components.supportClasses.ItemRenderer;

public class NormalizedDefaultGroupRendererModel implements IDefaultGroupRendererModel, IDisposable
{
	/**
	 * Logger instance.
	 */
	protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.NormalizedDefaultGroupRendererModel");


	/**
	 * Canonical name of the data visualization component (ex: "visualizer").
	 * Used by log messages.
	 */
	protected var _targetName:String = "visualizer";
	/**
	 * Visualizer instance
	 */
	protected var _visualizer:Visualizer;

	/**
	 * Current selection of groups.
	 */
	protected var _sourceGroups:Array = [];

	/**
	 * Helper class to determine common property values
	 * within a multi-selection.
	 */
	protected var _propertiesNormalizer:DefaultGroupRendererNormalizer;


	/**
	 * Constructor.
	 *
	 * @param targetName
	 * 		Canonical name of the data visualization
	 * 		component (ex: "visualizer").
	 * @param value
	 * 		visualizer instance
	 */
	public function NormalizedDefaultGroupRendererModel(targetName:String, value:Visualizer)
	{
		assert(null != value);

		_targetName = targetName;
		_visualizer = value;
		_propertiesNormalizer = new DefaultGroupRendererNormalizer();
	}


	/**
	 * Explicit references clean up.
	 * The current instance may not be considered usable there after, so
	 * one should call the <code>dispose()</code> method before an
	 * object gets "destroyed".
	 * <p>
	 * The <code>bRecursive</code> parameter is intended to be used
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
		_visualizer = null;
		_sourceGroups = null;
		if (null != _propertiesNormalizer)
		{
			_propertiesNormalizer.dispose();
			_propertiesNormalizer = null;
		}
	}

	/**
	 * Updates the source : the list of groups.
	 *
	 * @param source
	 * 		list of groups
	 */
	public function updateSource(source:Array):void
	{
		_sourceGroups = source.concat();
		try
		{
			_propertiesNormalizer.groupLabelField = _visualizer.groupLabelField.toString();
		}
		catch (e:Error)
		{
			_propertiesNormalizer.groupLabelField = null;
		}
		normalizeProperties(_sourceGroups);
	}


	/**
	 * Computes the property values found the most within the group selection.
	 *
	 * @param groups
	 * 		list of selected groups.
	 */
	protected function normalizeProperties(groups:Array):void
	{
		_propertiesNormalizer.clear();

		var renderer:DefaultGroupRenderer;

		for each (var selectedNode:ISprite in groups)
		{
			if (null == selectedNode.itemRenderer)
				continue;

			renderer = DefaultGroupRenderer(selectedNode.itemRenderer);
			_propertiesNormalizer.push(renderer);
		}
	}


	/**
	 * Applies the given value to the property named <code>strPropName</code>
	 * on each of the selected <code>DefaultGroupRenderer</code>.
	 * The <code>updateGraphics()</code> is then invoked.
	 *
	 * @param propName
	 * 		name of the property
	 * @param value
	 * 		value to apply
	 */
	protected function applyGraphicProperty(propName:String, value:*):void
	{
		var renderer:DefaultGroupRenderer;
		for each (var group:IGroup in _sourceGroups)
		{
			if (null == group.itemRenderer)
				continue;
			renderer = DefaultGroupRenderer(group.itemRenderer);
			renderer[propName] = value;
			renderer.updateGraphics();
		}
	}


	/**
	 * Canonical name of the data visualization component (ex: "visualizer").
	 * Used by log messages.
	 */
	public function get targetName():String
	{
		return _targetName;
	}


	public function get normalizedDataLabel():NormalizedValue
	{
		return _propertiesNormalizer.normalizedDataLabel;
	}

	public function get normalizedBackgroundColors():NormalizedValue
	{
		return _propertiesNormalizer.normalizedBackgroundColors;
	}

	public function get normalizedBorderColor():NormalizedValue
	{
		return _propertiesNormalizer.normalizedBorderColor;
	}


	/**
	 * Affects the label (actually, it affects the data, which
	 * SHOULD NOT BE DONE from the renderer).
	 */
	public function set dataLabel(value:String):void
	{
		if (!_visualizer.groupLabelField)
		{
			_logger.warn("Could not change group label, {0}.groupLabelField is not set", targetName);
			return;
		}

		_logger.info( [
				"var groupLabelField:String = {0}.groupLabelField;" ,
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(group.itemRenderer);" ,
				"renderer.data[strGroupLabelField] = \"{1}\";" ,
				"renderer.updateItemsFromData();" ,
				"renderer.update();"
			].join("\n") , targetName, value
		);

		var groupLabelField:String = _visualizer.groupLabelField;
		var renderer:DefaultGroupRenderer;
		for each (var group:IGroup in _sourceGroups)
		{
			if (null == group.itemRenderer)
				continue;
			renderer = DefaultGroupRenderer(group.itemRenderer);
			if (null == renderer.data)
				continue;

			renderer.data[groupLabelField] = value;
			renderer.updateItemsFromData();
			renderer.update();
		}
	}

	/**
	 * Affects the background gradient alpha of the renderer.
	 */
	public function set backgroundAlphas(value:Array):void
	{
		_logger.info( [
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(objGroup.itemRenderer);" ,
				"renderer.{0} = [ {1} ];" ,
				"renderer.updateGraphics();"
			].join("\n") , "backgroundAlphas", value
		);

		applyGraphicProperty("backgroundAlphas", value);
	}

	/**
	 * Affects the background gradient colors of the renderer.
	 */
	public function set backgroundColors(value:Array):void
	{
		_logger.info( [
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(objGroup.itemRenderer);" ,
				"renderer.{0} = [ {1} ];" ,
				"renderer.updateGraphics();"
			].join("\n") , "backgroundColors", DebugUtil.colorsToStrings(value)
		);

		applyGraphicProperty("backgroundColors", value);
	}

	/**
	 * Affects the border alpha transparency of the renderer.
	 */
	public function set borderAlpha(value:Number):void
	{
		_logger.info( [
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(objGroup.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateGraphics();"
			].join("\n") , "borderAlpha", value
		);

		applyGraphicProperty("borderAlpha", value);
	}

	/**
	 * Affects the border color of the renderer.
	 */
	public function set borderColor(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(objGroup.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateGraphics();"
			].join("\n") , "borderColor", DebugUtil.colorToString(value)
		);

		applyGraphicProperty("borderColor", value);
	}

	/**
	 * Affects the border thickness of the renderer.
	 */
	public function set borderThickness(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultGroupRenderer = DefaultGroupRenderer(objGroup.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateGraphics();"
			].join("\n") , "borderThickness", value
		);

		applyGraphicProperty("borderThickness", value);
	}
}
}