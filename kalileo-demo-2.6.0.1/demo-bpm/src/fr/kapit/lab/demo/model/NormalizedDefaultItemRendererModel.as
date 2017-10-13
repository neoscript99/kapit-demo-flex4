package fr.kapit.lab.demo.model
{
import flash.text.TextFormat;

import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.diagrammer.base.IDiagramSprite;
import fr.kapit.lab.demo.models.IDefaultItemRendererModel;
import fr.kapit.lab.demo.models.constants.TextStyleFlags;
import fr.kapit.lab.demo.util.DebugUtil;
import fr.kapit.lab.demo.util.DefaultItemRendererNormalizer;
import fr.kapit.lab.demo.util.NormalizedValue;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;
import fr.kapit.visualizer.renderers.DefaultItemRenderer;

import mx.logging.ILogger;
import mx.logging.Log;

/**
 * Defines a wrapper to manage <code>DefaultItemRenderer</code> instances.
 * The wrapper applies here to the currently selected nodes.
 *
 * @see fr.kapit.visualizer.renderers.DefaultItemRenderer
 */
public class NormalizedDefaultItemRendererModel implements IDefaultItemRendererModel, IDisposable
{
	/**
	 * Logger instance.
	 */
	protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.NormalizedDefaultItemRendererModel");


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
	 * Current selection of nodes.
	 */
	protected var _sourceNodes:Array = [];

	/**
	 * Helper class to determine common property values
	 * within a multi-selection.
	 */
	protected var _propertiesNormalizer:DefaultItemRendererNormalizer;


	/**
	 * Constructor.
	 *
	 * @param strTargetName
	 * 		Canonical name of the data visualization
	 * 		component (ex: "visualizer").
	 * @param objVisualizer
	 * 		visualizer instance
	 */
	public function NormalizedDefaultItemRendererModel(targetName:String, visualizer:Visualizer)
	{
		assert(null != visualizer);

		_targetName = targetName;
		_visualizer = visualizer;
		_propertiesNormalizer = new DefaultItemRendererNormalizer();
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
		_sourceNodes = null;
		_visualizer = null;
		if (null != _propertiesNormalizer)
		{
			_propertiesNormalizer.dispose();
			_propertiesNormalizer = null;
		}
	}

	/**
	 * Updates the source : the list of nodes.
	 *
	 * @param aSource
	 * 		list of nodes
	 */
	public function updateSource(source:Array):void
	{
		_sourceNodes = source.concat();
		try
		{
			_propertiesNormalizer.nodeLabelFields = _visualizer.nodeLabelFields.toString();
		}
		catch (e:Error)
		{
			_propertiesNormalizer.nodeLabelFields = null;
		}
		normalizeProperties(_sourceNodes);
	}


	/**
	 * Applies the given value to the property named <code>strPropName</code>
	 * on each of the selected <code>DefaultItemRenderer</code>.
	 * The <code>updateGraphics()</code> is then invoked.
	 *
	 * @param propName
	 * 		name of the property
	 * @param objValue
	 * 		value to apply
	 */
	protected function applyGraphicProperty(propName:String, value:*):void
	{
		var renderer:DefaultItemRenderer;
		for each (var node:ISprite in _sourceNodes)
		{
			if (null == node.itemRenderer)
				continue;
			renderer = DefaultItemRenderer(node.itemRenderer);
			renderer[propName] = value;
			renderer.updateGraphics();
		}
	}

	/**
	 * Applies the given value to the property named <code>strPropName</code>
	 * on each of the selected <code>DefaultItemRenderer</code>.
	 * The <code>updateLayout()</code> is then invoked.
	 *
	 * @param propName
	 * 		name of the property
	 * @param value
	 * 		value to apply
	 */
	protected function applyLayoutProperty(propName:String, value:*):void
	{
		var renderer:DefaultItemRenderer;
		for each (var node:ISprite in _sourceNodes)
		{
			if (null == node.itemRenderer)
				continue;
			renderer = DefaultItemRenderer(node.itemRenderer);
			renderer[propName] = value;
			renderer.updateLayout();
		}
	}

	/**
	 * Applies the given value to the property named <code>strPropName</code>
	 * on each of the selected <code>DefaultItemRenderer</code>.
	 * The <code>updateTextStyle()</code> is then invoked.
	 *
	 * @param propName
	 * 		name of the property
	 * @param value
	 * 		value to apply
	 */
	protected function applyTextStyleProperty(propName:String, value:*):void
	{
		var renderer:DefaultItemRenderer;
		for each (var node:ISprite in _sourceNodes)
		{
			if (null == node.itemRenderer)
				continue;
			renderer = DefaultItemRenderer(node.itemRenderer);
			renderer[propName] = value;
			renderer.updateTextStyle();
		}
	}

	/**
	 * Computes the property values found the most within the node selection.
	 *
	 * @param nodes
	 * 		list of selected nodes.
	 */
	protected function normalizeProperties(nodes:Array):void
	{
		_propertiesNormalizer.clear();

		var renderer:DefaultItemRenderer;

		for each (var node:ISprite in nodes)
		{
			if (null == node.itemRenderer || !(node.itemRenderer is DefaultItemRenderer))
				continue;

			renderer = DefaultItemRenderer(node.itemRenderer);
			_propertiesNormalizer.push(renderer);
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
	public function get normalizedBorderThickness():NormalizedValue
	{
		return _propertiesNormalizer.normalizedBorderThickness;
	}

	public function get normalizedFieldsTextSize():NormalizedValue
	{
		return _propertiesNormalizer.normalizedFieldsTextSize;
	}
	public function get normalizedFieldsTextColor():NormalizedValue
	{
		return _propertiesNormalizer.normalizedFieldsTextColor;
	}

	public function get normalizedFieldsTextFormat():NormalizedValue
	{
		return _propertiesNormalizer.normalizedFieldsTextFormat;
	}


	/**
	 * Affects the label (actually, it affects the data, which
	 * SHOULD NOT BE DONE from the renderer).
	 */
	public function set dataLabel(value:String):void
	{
		if (!_visualizer.nodeLabelFields)
		{
			_logger.warn("Could not change node label, {0}.nodeLabelFields is not set", targetName);
			return;
		}

		_logger.info( [
				"var nodeLabelFields:String = {0}.nodeLabelFields;" ,
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.data[strNodeLabelFields] = \"{1}\";" ,
				"renderer.updateItemsFromData();" ,
				"renderer.update();" ,
				"node.controller.draw();"
			].join("\n") , targetName, value
		);

		var nodeLabelFields:String = _visualizer.nodeLabelFields.toString();
		var renderer:DefaultItemRenderer;
		for each (var node:IDiagramSprite in _sourceNodes)
		{
			if (null == node.itemRenderer)
				continue;
			renderer = DefaultItemRenderer(node.itemRenderer);
			if (null == renderer.data)
				continue;

			renderer.data[nodeLabelFields] = value;
			renderer.updateItemsFromData();
			renderer.update();
			if(node.controller)
				node.controller.draw();
		}		
	}

	/**
	 * Affects the background gradient alpha of the renderer.
	 */
	public function set backgroundAlphas(value:Array):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = [ {1} ];" ,
				"renderer.updateGraphics();"
			].join("\n") , "backgroundAlphas", value
		);

		applyGraphicProperty("backgroundAlphas", value);
	}

	/**
	 * Affects the background gradient colors of the renderer.
	 * Applies the settings to the current selection of nodes.
	 *
	 * @param aValue
	 * 		array of gradient colors
	 */
	public function set backgroundColors(value:Array):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
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
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
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
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
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
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateGraphics();"
			].join("\n") , "borderThickness", value
		);

		applyGraphicProperty("borderThickness", value);
	}


	/**
	 * Affects the size of contained text (fields), not titles.
	 * Text size is given in pixels
	 *
	 * @see flash.text.TextFormat#size
	 */
	public function set fieldsTextSize(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateTextStyle();"
			].join("\n") , "fieldsTextSize", value
		);

		applyTextStyleProperty("fieldsTextSize", value);
	}
	/**
	 * Affects the color of contained text (fields), not titles.
	 */
	public function set fieldsTextColor(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateTextStyle();"
			].join("\n") , "fieldsTextColor", DebugUtil.colorToString(value)
		);

		applyTextStyleProperty("fieldsTextColor", value);
	}


	/**
	 * Affects the text style of contained text (fields).
	 * The text style is managed on each renderer through
	 * a <code>TextFormat</code> instance.
	 * The <code>fieldsTextFormatFlags</code> property updates
	 * the <code>bold</code> and <code>italic</code> fields of the
	 * <code>TextFormat</code> instance.
	 *
	 * @see fr.kapit.lab.demo.models.constants.TextStyleFlags
	 */
	public function set fieldsTextFormatFlags(value:int):void
	{
		var isBold:Boolean = TextStyleFlags.isBold(value);
		var isItalic:Boolean = TextStyleFlags.isItalic(value);

		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);",
				"var objTextFormat:TextFormat = renderer.fieldsTextFormat;" ,
				"textFormat.bold = {0};" ,
				"textFormat.italic = {1};" ,
				"renderer.fieldsTextFormat = objTextFormat;" ,
				"renderer.updateTextStyle();"
			].join("\n") , isBold, isItalic
		);

		var renderer:DefaultItemRenderer;
		var textFormat:TextFormat;

		for each (var node:ISprite in _sourceNodes)
		{
			if (null == node.itemRenderer)
				continue;
			renderer = DefaultItemRenderer(node.itemRenderer);
			textFormat = renderer.fieldsTextFormat;
			// the textformat is enforced only if it has been modified
			if ( TextStyleFlags.applyFlagsToTextFormat(value, textFormat) )
			{
				renderer.fieldsTextFormat = textFormat;
				renderer.updateTextStyle();
			}
		}
	}


	/**
	 * Horizontal spacing between fields group and both top and
	 * bottom borders.
	 */
	public function set horizontalPadding(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateLayout();"
			].join("\n") , "horizontalPadding", value
		);

		applyLayoutProperty("horizontalPadding", value);
	}
	/**
	 * Horizontal spacing between titles and fields.
	 */
	public function set horizontalSpacing(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateLayout();"
			].join("\n") , "horizontalSpacing", value
		);

		applyLayoutProperty("horizontalSpacing", value);
	}

	/**
	 * Horizontal spacing between fields group and both left and
	 * right borders.
	 */
	public function set verticalPadding(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateLayout();"
			].join("\n") , "verticalPadding", value
		);

		applyLayoutProperty("verticalPadding", value);
	}
	/**
	 * Vertical spacing between text fields.
	 */
	public function set verticalSpacing(value:uint):void
	{
		_logger.info( [
				"var renderer:DefaultItemRenderer = DefaultItemRenderer(node.itemRenderer);" ,
				"renderer.{0} = {1};" ,
				"renderer.updateLayout();"
			].join("\n") , "verticalSpacing", value
		);

		applyLayoutProperty("verticalSpacing", value);
	}

}
}
