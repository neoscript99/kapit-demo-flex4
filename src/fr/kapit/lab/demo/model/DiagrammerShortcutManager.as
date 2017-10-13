package fr.kapit.lab.demo.model
{
import flash.events.KeyboardEvent;

import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
import fr.kapit.lab.demo.util.CopyPasteUtil;
import fr.kapit.lab.demo.util.SelectionUtil;
import fr.kapit.visualizer.base.ISprite;

import mx.logging.ILogger;
import mx.logging.Log;

public class DiagrammerShortcutManager extends VisualizerShortcutManager
{
	/**
	 * Logger instance.
	 */
	protected static var _logger:ILogger = Log.getLogger("fr.kapit.lab.demo.model.DiagrammerShortcutManager");

	/**
	 * Abstraction to control the diagrammer instance.
	 */
	protected var _diagrammerModel:DiagrammerModel = null;

	/**
	 * Constructor.
	 *
	 * @param value
	 * 		instance of the diagrammer wrapper
	 */
	public function DiagrammerShortcutManager(value:DiagrammerModel)
	{
		super(value);
		_diagrammerModel = value;

		CopyPasteUtil.init(value);
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
	override public function dispose(recursive:Boolean=false):void
	{
		super.dispose(recursive);
		_diagrammerModel = null;
	}


	/**
	 * Handles keyboard event : <code>KeyboardEvent.KEY_DOWN</code>.
	 *
	 * @param event
	 */
	override public function keyDownHandler(event:KeyboardEvent):void
	{
		super.keyDownHandler(event);

		switch(event.keyCode)
		{
			/* copy (CTRL + C) */
			case 67 :
			{
				if (event.ctrlKey)
				{
					copy();
				}
				break;
			}
			/* paste (CTRL + V) */
			case 86 :
			{
				if (event.ctrlKey)
				{
					paste();
				}
				break;
			}
			/* group (CTRL + G) or ungroup (CTRL + SHIFT + G) */
			case 71 :
			{
				if (event.ctrlKey)
				{
					event.shiftKey ? ungroup() : group();
				}
				break;
			}
		}
	}

	/**
	 * Handles keyboard event : <code>KeyboardEvent.KEY_UP</code>.
	 *
	 * @param event
	 */
	override public function keyUpHandler(event:KeyboardEvent):void
	{
		super.keyUpHandler(event);
	}


	/**
	 * Returns <code>true</code> if at least one element of the given list
	 * is currently being edited
	 *
	 * @see fr.kapit.diagrammer.renderers.DefaultEditorRenderer#isEditing
	 *
	 * @param aList
	 * 		list of elements
	 * @return
	 * 		true if at least one of the element is being edited,
	 * 		false otherwise
	 */
	public static function isEditing(list:Array):Boolean
	{
		var elements:Array = SelectionUtil.removeEdgesFrom(list);
		var renderer:DefaultEditorRenderer;

		for each (var element:ISprite in elements)
		{
			renderer = element.itemRenderer as DefaultEditorRenderer;
			if (null == renderer)
				continue;
			if (renderer.isEditing)
				return true;
		}

		return false;
	}


	/**
	 * Returns <code>true</code> if at least one element of the
	 * current selection is currently being edited
	 *
	 * @return
	 * 		true if at least one of the element is being edited,
	 * 		false otherwise
	 */	protected function isEditingSelectedElements():Boolean
	{
		return SelectionUtil.isEditingElements(_diagrammerModel.diagrammer.selection);
	}


	/**
	 * Request a zoom on the datavisualization component
	 *
	 * @param nOffsetRatio
	 * 		offset to apply on the current zoom ratio
	 */
	override protected function zoom(offsetRatio:Number):void
	{
		if (isEditingSelectedElements())
			return;

		super.zoom(offsetRatio);
	}

	/**
	 * Moves the selected elements using the keyboard arrows.
	 *
	 * @param direction
	 * 		keyboard arrow key code
	 * @param offset
	 * 		displacement offset
	 */
	override protected function move(direction:uint, offset:int):void
	{
		if (isEditingSelectedElements())
			return;

		super.move(direction, offset);
	}


	protected function copy():void
	{
		_logger.info("CopyPasteUtil.copy({0}.selection);", targetName);
		CopyPasteUtil.copy(_diagrammerModel.diagrammer.selection);
	}

	protected function paste():void
	{
		_logger.info("CopyPasteUtil.paste();");
		CopyPasteUtil.paste();
	}

	protected function group():void
	{
		if (! _diagrammerModel.isNodeSelection(true))
			return;
		_diagrammerModel.createGroup();
	}

	protected function ungroup():void
	{
		if (! _diagrammerModel.isGroupSelection(true))
			return;
		_diagrammerModel.destroyGroups();
	}

}
}