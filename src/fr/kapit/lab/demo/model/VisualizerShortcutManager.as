package fr.kapit.lab.demo.model
{
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.lab.demo.models.IShortcutManager;
import fr.kapit.lab.demo.util.SelectionUtil;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.base.IColumn;
import fr.kapit.visualizer.base.ILane;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.base.ITable;

import mx.logging.ILogger;
import mx.logging.Log;

/**
 * Utility class to manage keyboard events; for example pressing the "+" key
 * should trigger a zoom in.
 */
public class VisualizerShortcutManager implements IShortcutManager, IDisposable
{
	/**
	 * Logger instance.
	 */
	protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.VisualizerShortcutManager");

	/**
	 * Access to the current visualizer model.
	 */
	protected var _visualizerModel:VisualizerModel;


	/**
	 * Constructor.
	 *
	 * @param objVisualizerModel
	 * 		instance of the visualizer wrapper
	 */
	public function VisualizerShortcutManager(value:VisualizerModel)
	{
		assert(null != value);
		assert(null != value.visualizer);

		_visualizerModel = value;
		addVisualizerListeners(value.visualizer);
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
		if (null != _visualizerModel)
		{
			removeVisualizerListeners(_visualizerModel.visualizer);
			_visualizerModel = null;
		}
	}


	/**
	 * Handles keyboard event : <code>KeyboardEvent.KEY_DOWN</code>.
	 *
	 * @param event
	 */
	public function keyDownHandler(event:KeyboardEvent):void
	{
		switch(event.keyCode)
		{
			/* zoom in with "+" key */
			case Keyboard.NUMPAD_ADD :
			{
				zoom(.1);
				break;
			}
			/* zoom out with "-" key */
			case Keyboard.NUMPAD_SUBTRACT :
			{
				zoom(-.1);
				break;
			}
			/* moving selected elements using arrow keys */
			case Keyboard.RIGHT :
			case Keyboard.DOWN :
			case Keyboard.LEFT :
			case Keyboard.UP :
			{
				// move by 1 pixel, unless shift key is pressed (move by 10px)
				move(event.keyCode, event.shiftKey ? 10 : 1);
				break;
			}
		}
	}

	/**
	 * Handles keyboard event : <code>KeyboardEvent.KEY_UP</code>.
	 *
	 * @param event
	 */
	public function keyUpHandler(event:KeyboardEvent):void
	{
		// place holder
	}

	/**
	 * Adds event listeners to the current visulaizer instance.
	 *
	 * @param value
	 * 		visualizer instance
	 */
	protected function addVisualizerListeners(value:Visualizer):void
	{
		value.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		value.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	/**
	 * Removes event listeners from the visualizer instance.
	 *
	 * @param objVisualizer
	 * 		visualizer instance
	 */
	protected function removeVisualizerListeners(value:Visualizer):void
	{
		value.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		value.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}

	/**
	 * Request a zoom on the datavisualization component
	 *
	 * @param nOffsetRatio
	 * 		offset to apply on the current zoom ratio
	 */
	protected function zoom(offsetRatio:Number):void
	{
		var ratio:Number = _visualizerModel.visualizer.ratio+ offsetRatio;
		_visualizerModel.zoom(ratio);
	}

	/**
	 * Moves the selected elements using the keyboard arrows.
	 *
	 * @param direction
	 * 		keyboard arrow key code
	 * @param offset
	 * 		displacement offset
	 */
	protected function move(direction:uint, offset:int):void
	{
		var elements:Array = _visualizerModel.visualizer.selection;
		// filtering out links
		elements = SelectionUtil.removeEdgesFrom(elements);
		// filtering out selected nodes within selected groups
		elements = SelectionUtil.onlyTopMostElements(elements);

		if (0 == elements.length)
			return;

		// property name : "x" or "y"
		var propName:String;
		// movement direction "+" or "-"
		var localDirection:String;

		for each(var element:Object in elements)
		{
			if(element is ILane || element is IColumn || element is ITable)
				continue;
			switch(direction)
			{
				case Keyboard.RIGHT :
				{
					propName = "x";
					localDirection = "+";
					element.x += offset;
					break;
				}
				case Keyboard.LEFT :
				{
					propName = "x";
					localDirection = "-";
					element.x -= offset;
					break;
				}
				case Keyboard.UP :
				{
					propName = "y";
					localDirection = "-";
					element.y -= offset;
					break;
				}
				case Keyboard.DOWN :
				{
					propName = "y";
					localDirection = "+";
					element.y += offset;
					break;
				}
			}
		}

		_logger.info( [
				"for each (var objElement:ISprite in {0}.selection)",
				"{",
				"\tobjElement.{1} {2}= {3};" ,
				"}"
			].join("\n"), targetName, propName, localDirection, offset
		);
	}


	/**
	 * Canonical name of the data visualization component (ex: "visualizer").
	 * Used by log messages.
	 */
	public function get targetName():String
	{
		return _visualizerModel.targetName;
	}

}
}