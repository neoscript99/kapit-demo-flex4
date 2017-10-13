package fr.kapit.lab.demo.model
{
	import fr.kapit.actionscript.system.IDisposable;
	import fr.kapit.actionscript.system.debug.assert;
	import fr.kapit.lab.demo.models.IGenericLinkModel;
	import fr.kapit.lab.demo.util.DebugUtil;
	import fr.kapit.lab.demo.util.GenericLinkNormalizer;
	import fr.kapit.lab.demo.util.NormalizedValue;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.base.ILink;
	import fr.kapit.visualizer.base.sprite.GenericLink;
	import fr.kapit.visualizer.events.VisualizerEvent;
	import fr.kapit.visualizer.styles.LinkStyle;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Defines a wrapper to manage <code>GenericLink</code> instances.
	 * The wrapper applies here to the currently selected edges.
	 *
	 * @see fr.kapit.visualizer.base.sprite.GenericLink
	 */
	public class NormalizedGenericLinkModel implements IDisposable, IGenericLinkModel
	{
		/**
		 * Logger instance.
		 */
		protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.NormalizedGenericLinkModel");
		
		
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
		 * Current selection of edges (links).
		 */
		protected var _sourceEdges:Array = [];
		
		/**
		 * Helper class to determine common property values
		 * within a multi-selection.
		 */
		protected var _propertiesNormalizer:GenericLinkNormalizer;
		
		
		/**
		 * Constructor.
		 *
		 * @param targetName
		 * 		Canonical name of the data visualization
		 * 		component (ex: "visualizer").
		 * @param visualizer
		 * 		visualizer instance
		 */
		public function NormalizedGenericLinkModel(targetName:String, visualizer:Visualizer)
		{
			assert(null != visualizer);
			
			_targetName = targetName;
			_visualizer = visualizer;
			_propertiesNormalizer = new GenericLinkNormalizer();
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
			_sourceEdges = null;
			_visualizer = null;
			if (null != _propertiesNormalizer)
			{
				_propertiesNormalizer.dispose();
				_propertiesNormalizer = null;
			}
		}
		
		/**
		 * Updates the source : the list of edges.
		 *
		 * @param source
		 * 		list of edges (links)
		 */
		public function updateSource(source:Array):void
		{
			_sourceEdges = source.concat();
			normalizeProperties(_sourceEdges);
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
			
			for each (var link:GenericLink in groups)
			{
				if (null == link)
					continue;
				
				_propertiesNormalizer.push(link);
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
		
		
		public function get normalizedArrowSourceType():NormalizedValue
		{
			return _propertiesNormalizer.normalizedArrowSourceType;
		}
		
		public function get normalizedArrowTargetType():NormalizedValue
		{
			return _propertiesNormalizer.normalizedArrowTargetType;
		}
		
		public function get normalizedLineColor():NormalizedValue
		{
			return _propertiesNormalizer.normalizedLineColor;
		}
		public function get normalizedThickness():NormalizedValue
		{
			return _propertiesNormalizer.normalizedThickness;
		}
		public function get normalizedRenderingPolicy():NormalizedValue
		{
			return _propertiesNormalizer.normalizedRenderingPolicy;
		}
		
		
		/**
		 * Affects the style of the connection to the source node.
		 */
		public function set arrowSourceType(value:String):void
		{
			_logger.info( [
				"var link:GenericLink;" ,
				"link.linkStyle.{0} = {1};" ,
				"link.forcePathUpdate = true;"
			].join("\n") , "arrowSourceType", DebugUtil.linkStyleArrowToString(value)
			);
			
			for each (var link:GenericLink in _sourceEdges)
			{
				link.linkStyle.arrowSourceType = value;
				link.forcePathUpdate = true;
			}
		}
		
		/**
		 * Affects the style of the connection to the target node.
		 */
		public function set arrowTargetType(value:String):void
		{
			_logger.info( [
				"var link:GenericLink;" ,
				"link.linkStyle.{0} = {1};" ,
				"link.forcePathUpdate = true;"
			].join("\n") , "arrowTargetType", DebugUtil.linkStyleArrowToString(value)
			);
			
			for each (var link:GenericLink in _sourceEdges)
			{
				link.linkStyle.arrowTargetType = value;
				link.forcePathUpdate = true;
			}
		}
		
		/**
		 * Affects the line color of the edge (link).
		 */
		public function set lineColor(uiValue:uint):void
		{
			_logger.info( [
				"var link:GenericLink;" ,
				"link.linkStyle.{0} = {1};" ,
			].join("\n") , "lineColor", DebugUtil.colorToString(uiValue)
			);
			
			for each (var link:GenericLink in _sourceEdges)
			{
				link.linkStyle.lineColor = uiValue;
			}
		}
		
		/**
		 * Affects the line thickness of the edge (link).
		 */
		public function set thickness(uiValue:uint):void
		{
			_logger.info( [
				"var link:GenericLink;" ,
				"link.linkStyle.{0} = {1};" ,
			].join("\n") , "thickness", uiValue
			);
			
			for each (var link:GenericLink in _sourceEdges)
			{
				link.linkStyle.arrowHeight = int(uiValue * 3 + 2);
				link.linkStyle.arrowWidth = int(uiValue * 3 + 2);
				// forcePathUpdate needed to update arrows
				link.forcePathUpdate = true;
				link.linkStyle.highlightThickness = uiValue;
				link.linkStyle.selectionThickness = uiValue;
				link.linkStyle.thickness = uiValue;
			}
		}
		
		/**
		 * Affects the rendering policy of the edge (link).
		 */
		public function set renderingPolicy(strValue:String):void
		{
			_logger.info( [
				"var link:GenericLink;" ,
				"link.linkStyle.{0} = {1};" ,
			].join("\n") , "renderingPolicy", DebugUtil.linkRenderingPolicyToString(strValue)
			);
			
			for each (var link:GenericLink in _sourceEdges)
			{
				link.linkStyle.renderingPolicy = strValue;
			}
		}
	}
}