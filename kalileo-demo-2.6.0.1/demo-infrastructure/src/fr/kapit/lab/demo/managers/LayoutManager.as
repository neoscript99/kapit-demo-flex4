package fr.kapit.lab.demo.managers
{
	import fr.kapit.actionscript.lang.ArrayUtil;
	import fr.kapit.lab.demo.util.DebugUtil;
	import fr.kapit.layouts.algorithms.balloon.BalloonLayout;
	import fr.kapit.layouts.algorithms.circular.SingleCycleCircularLayout;
	import fr.kapit.layouts.algorithms.hierarchical.HierarchicalLayout;
	import fr.kapit.layouts.algorithms.orthogonal.OrthogonalLayout;
	import fr.kapit.layouts.algorithms.radial.RadialLayout;
	import fr.kapit.layouts.algorithms.sugiyama.SugiyamaLayout;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	/**
	 * Wrapper around the current layout instance of the diagrammer component.
	 * This is done to dispatch what's going on, on the source code side, as
	 * log messages.
	 */
	public class LayoutManager
	{
		/**
		 * Logger instance.
		 */
		protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.LayoutModel");


		protected var _targetName:String = "visualizer";
		[Bindable]
		/**
		 * Canonical name of the data visualization component (ex: "visualizer").
		 * Used by log messages.
		 */
		public function get targetName():String
		{
			return _targetName;
		}
		public function set targetName(value:String):void
		{
			_targetName = value;
		}
		
		protected var _layoutType:String = HierarchicalLayout.ID;
		[Bindable]
		/**
		 * Identifier of the current layout, such as
		 * <code>HierarchicalLayout.ID</code>, <code>RadialLayout.ID</code>, ...
		 */	
		public function get layoutType():String
		{
			return _layoutType;
		}
		public function set layoutType(value:String):void
		{
			_layoutType = value;
		}
		
		protected var _layout:Object;
		[Bindable]
		/**
		 * Current layout instance
		 */
		public function get layout():Object
		{
			return _layout;
		}
		/**
		 * @private
		 */
		public function set layout(value:Object):void
		{
			_layout = value;
		}


		public function LayoutManager()
		{
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
			_layout = null;
		}
		


		/**
		 * Orientation of the layout.
		 * May be applicable to the following layouts :
		 * <code>HierarchicalLayout</code>, <code>SugiyamaLayout</code>
		 */
		public function set orientation(uiValue:uint):void
		{
			if (! isLayoutTypeIn([ HierarchicalLayout.ID, SugiyamaLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "orientation", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "orientation", DebugUtil.orientationTypeToString(uiValue) );
			_layout.orientation = uiValue;
		}

		/**
		 * layerDistance, affects the spacing between each layer
		 * (hierarchical level) of nodes.
		 * May be applicable to the following layouts :
		 * <code>HierarchicalLayout</code>
		 */
		public function set layerDistance(iValue:int):void
		{
			if (! isLayoutTypeIn([ HierarchicalLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "layerDistance", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "layerDistance", iValue);
			_layout.layerDistance = iValue;
		}

		/**
		 * defaultNodeDistance, affects the spacing between each node of
		 * a same layer (hierarchical level) of nodes.
		 * May be applicable to the following layouts :
		 * <code>HierarchicalLayout</code>
		 */
		public function set defaultNodeDistance(iValue:int):void
		{
			if (! isLayoutTypeIn([ HierarchicalLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "defaultNodeDistance", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "defaultNodeDistance", iValue);
			_layout.defaultNodeDistance = iValue;
		}

		/**
		 * edgeDrawing, affects the line style between nodes.
		 * May be applicable to the following layouts :
		 * <code>HierarchicalLayout</code>, <code>SugiyamaLayout</code>, <code>RadialLayout</code>
		 */
		public function set edgeDrawing(uiValue:uint):void
		{
			if (!isLayoutTypeIn([ HierarchicalLayout.ID, SugiyamaLayout.ID, RadialLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "edgeDrawing", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "edgeDrawing", DebugUtil.edgeDrawTypeToString(uiValue));
			_layout.edgeDrawing = uiValue;
		}


		/**
		 * layerDistance, affects the vertical spacing between the nodes.
		 * May be applicable to the following layouts :
		 * <code>SugiyamaLayout</code>
		 */
		public function set verticalDistance(iValue:int):void
		{
			if (!isLayoutTypeIn([ SugiyamaLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "verticalDistance", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "verticalDistance", iValue);
			_layout.verticalDistance = iValue;
		}

		/**
		 * horizontalDistance, affects the horizontal spacing between the nodes.
		 * May be applicable to the following layouts :
		 * <code>SugiyamaLayout</code>
		 */
		public function set horizontalDistance(iValue:int):void
		{
			if (!isLayoutTypeIn([ SugiyamaLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "horizontalDistance", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "horizontalDistance", iValue);
			_layout.horizontalDistance = iValue;
		}

		/**
		 * nodesSpacing, affects the spacing between the nodes.
		 * May be applicable to the following layouts :
		 * <code>OrthogonalLayout</code>, <code>SingleCycleCircularLayout</code>
		 */
		public function set nodesSpacing(iValue:int):void
		{
			if (!isLayoutTypeIn([ OrthogonalLayout.ID , SingleCycleCircularLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "nodesSpacing", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "nodesSpacing", iValue);
			_layout.nodesSpacing = iValue;
		}

		/**
		 * usePseudoOrthogonalEdges
		 * May be applicable to the following layouts :
		 * <code>OrthogonalLayout</code>
		 */
		public function set usePseudoOrthogonalEdges(bValue:Boolean):void
		{
			if (!isLayoutTypeIn([ OrthogonalLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "usePseudoOrthogonalEdges", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "usePseudoOrthogonalEdges", bValue);
			_layout.usePseudoOrthogonalEdges = bValue;
		}

		/**
		 * May be applicable to the following layouts :
		 * <code>SingleCycleCircularLayout</code>
		 */
		public function set angularSector(iValue:int):void
		{
			if (!isLayoutTypeIn([ SingleCycleCircularLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "angularSector", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "angularSector", iValue);
			_layout.angularSector = iValue;
		}

		/**
		 * May be applicable to the following layouts :
		 * <code>BalloonLayout</code>, <code>RadialLayout</code>
		 */
		public function set rootSelectionPolicy(uiValue:int):void
		{
			if (!isLayoutTypeIn([ BalloonLayout.ID , RadialLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "rootSelectionPolicy", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "rootSelectionPolicy", DebugUtil.rootSelectionTypeToString(uiValue));
			_layout.rootSelectionPolicy = uiValue;
		}

		/**
		 * rootAngularSector, affects the root wedge angle
		 * May be applicable to the following layouts :
		 * <code>BalloonLayout</code>
		 */
		public function set rootAngularSector(iValue:int):void
		{
			if (!isLayoutTypeIn([ BalloonLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "rootAngularSector", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "rootAngularSector", iValue);
			_layout.rootAngularSector = iValue;
		}

		/**
		 * childAngularSector, affects the child wedge angle
		 * May be applicable to the following layouts :
		 * <code>BalloonLayout</code>
		 */
		public function set childAngularSector(iValue:int):void
		{
			if (!isLayoutTypeIn([ BalloonLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "childAngularSector", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "childAngularSector", iValue);
			_layout.childAngularSector = iValue;
		}

		/**
		 * useEvenAngles, affects the angle distribution.
		 * May be applicable to the following layouts :
		 * <code>BalloonLayout</code>
		 */
		public function set useEvenAngles(bValue:Boolean):void
		{
			if (!isLayoutTypeIn([ BalloonLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "useEvenAngles", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "useEvenAngles", bValue);
			_layout.useEvenAngles = bValue;
		}

		/**
		 * May be applicable to the following layouts :
		 * <code>RadialLayout</code>
		 */
		public function set angle2(iValue:int):void
		{
			if (!isLayoutTypeIn([ RadialLayout.ID ]))
			{
				_logger.warn("property {0} is not applicable to layout {1}", "angle2", _layoutType);
				return;
			}

			_logger.info("{0}.layout.{1} = {2};", targetName, "angle2", iValue);
			_layout.angle2 = iValue;
		}


		/**
		 * @private
		 * Checks the current layout type, returns <code>true</code> if
		 * the current layout type matches at least one of the given types.
		 *
		 * @param aAllowedTypes
		 * 		array of allowed layout types
		 * @return Boolean
		 */
		private function isLayoutTypeIn(allowedTypes:Array):Boolean
		{
			return ArrayUtil.isInArray(allowedTypes, _layoutType);
		}

	}
}