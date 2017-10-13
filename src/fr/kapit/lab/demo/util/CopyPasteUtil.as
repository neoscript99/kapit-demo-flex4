package fr.kapit.lab.demo.util
{
import flash.geom.Point;
import flash.utils.Dictionary;

import fr.kapit.actionscript.system.debug.assert;
import fr.kapit.diagrammer.base.sprite.DiagramLink;
import fr.kapit.diagrammer.base.uicomponent.DiagramGroup;
import fr.kapit.diagrammer.base.uicomponent.DiagramSprite;
import fr.kapit.lab.demo.model.DiagrammerModel;
import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.events.VisualizerEvent;
import fr.kapit.visualizer.renderers.DefaultGroupRenderer;
import fr.kapit.visualizer.renderers.DefaultItemRenderer;
import fr.kapit.visualizer.styles.LinkStyle;

public class CopyPasteUtil
{
	protected static var _clipboardNodesBuffer:Array = null;
	protected static var _clipboardGroupsBuffer:Array = null;
	protected static var _clipboardLinksBuffer:Array = null;
	protected static var _pastedNodes:Array = null;
	protected static var _pastedGroups:Array = null;
	protected static var _clipboardMap:Dictionary;
	protected static var _diagrammerModel:DiagrammerModel;

	protected static var _numPaste:uint;
	protected static var _pasteMinX:int;
	protected static var _pasteMaxX:int;
	protected static var _pasteMinY:int;
	protected static var _pasteMaxY:int;
	protected static var _offsetNode:Point;


	/**
	 *
	 * Initates the current diagrammerModel. You must call this method first.
	 *
	 * @param diagrammerModel
	 *
	 */
	public static function init(diagrammerModel:DiagrammerModel):void
	{
		_diagrammerModel = diagrammerModel;
	}

	/**
	 * Makes a copy of the nodes/groups given in parameters in a temporary buffer.
	 *
	 * @param elements
	 * 		Array of ISprites contains nodes and groups to copy
	 *
	 */
	public static function copy(elements:Array):void
	{
		assert(null != _diagrammerModel, "You must initiate CopyPasteUtil with the current diagrammerModel before use it.");

		_clipboardNodesBuffer = [];
		_clipboardGroupsBuffer = [];
		_pasteMinX = 100000;
		_pasteMaxX = -100000;
		_pasteMinY = 100000;
		_pasteMaxY = -100000;

		if(elements && elements.length>0)
		{
			var topElements:Array = SelectionUtil.onlyTopMostElements(elements);
			SelectionUtil.extractNodes(topElements, _clipboardNodesBuffer);
			SelectionUtil.extractGroups(topElements, _clipboardGroupsBuffer);
		}

		var i:int;
		for(i=0; i<_clipboardNodesBuffer.length; ++i)
		{
			var nodeWidth:int = DiagramSprite(_clipboardNodesBuffer[i]).width;
			var nodeHeight:int = DiagramSprite(_clipboardNodesBuffer[i]).height;
			checkLimits(_clipboardNodesBuffer[i] as ISprite, nodeWidth, nodeHeight);
		}

		for(i=0; i<_clipboardGroupsBuffer.length; ++i)
		{
			var groupWidth:int = DiagramGroup(_clipboardGroupsBuffer[i]).width;
			var groupHeight:int = DiagramGroup(_clipboardGroupsBuffer[i]).height;
			checkLimits(_clipboardGroupsBuffer[i] as ISprite, groupWidth, groupHeight);
		}

		_numPaste = 0;
	}

	protected static function checkLimits(node:ISprite, w:int, h:int):void
	{
		if(node.x < _pasteMinX)	_pasteMinX = node.x;
		if(node.y < _pasteMinY)	_pasteMinY = node.y;
		if(node.x + w > _pasteMaxX)	_pasteMaxX = node.x + w;
		if(node.y + h > _pasteMaxY) _pasteMaxY = node.y + h;
	}

	/**
	 * Pastes elements contained in the temporary buffer previously copied.
	 *
	 */
	public static function paste():void
	{
		assert(null != _diagrammerModel, "You must initiate CopyPasteUtil with the current diagrammerModel before use it.");

		_diagrammerModel.logEnabled = false;
		var clipboardNodesBufferLength:int=_clipboardNodesBuffer?_clipboardNodesBuffer.length:0;
		var clipboardGroupsBufferLength:int=_clipboardGroupsBuffer?_clipboardGroupsBuffer.length:0;
		if(_clipboardNodesBuffer.length>0 || _clipboardGroupsBuffer.length>0)
		{
			var widthPaste:int = _pasteMaxX - _pasteMinX;
			var heightPaste:int = _pasteMaxY - _pasteMinY;
			var offsetBase:uint = (_numPaste+1) * 25;
			var pasteCenter:Point = new Point(_pasteMinX + widthPaste/2, _pasteMinY + heightPaste/2);
			var diagCenter:Point = new Point(offsetBase + (_diagrammerModel.diagrammer.width) / 2, offsetBase + (_diagrammerModel.diagrammer.height) / 2);
			_offsetNode = diagCenter.subtract(pasteCenter);

			_clipboardLinksBuffer = [];
			_clipboardMap = new Dictionary();
			var newSelection:Array = [];
			var i:int;
			for(i=0; i<_clipboardNodesBuffer.length; ++i)
			{
				var newNode:ISprite = pasteNode(_clipboardNodesBuffer[i] as DiagramSprite);
				newSelection.push(newNode);
			}

			for(i=0; i<_clipboardGroupsBuffer.length; ++i)
			{
				var newGroup:IGroup = pasteGroup(_clipboardGroupsBuffer[i] as DiagramGroup);
				newSelection.push(newGroup);
			}

			for(i=0; i<_clipboardLinksBuffer.length; ++i)
			{
				var link:DiagramLink = _clipboardLinksBuffer[i] as DiagramLink;
				var source:ISprite = _clipboardMap[link.source.itemID];
				var target:ISprite = _clipboardMap[link.target.itemID];
				if(target)
				{
					var linkStyle:LinkStyle = link.linkStyle.clone();
					_diagrammerModel.diagrammer.addLinkElement(new Object(), source, target, null, -1, -1, null, linkStyle);
				}
			}

			_clipboardMap = null;
			_diagrammerModel.unselectAll();

			for each(var pastedNode:ISprite in newSelection)
			{
				pastedNode.isSelected = true;
			}
			_diagrammerModel.diagrammer.dispatchVisualizerEvent(VisualizerEvent.ELEMENTS_SELECTION_CHANGED,_diagrammerModel.diagrammer.selection);
			_diagrammerModel.logEnabled = true;
		}
		++_numPaste;
	}

	protected static function pasteNode(node:DiagramSprite):ISprite
	{
		var newNode:ISprite = _diagrammerModel.addNode(node.data.label, node.data.renderer, new Point(node.x+_offsetNode.x, node.y+_offsetNode.y), node.data.size);
		copyNodeStyle(node as ISprite, newNode);

		_clipboardMap[node.itemID] = newNode;
		for each(var nodeLink:DiagramLink in node.outLinks)
			_clipboardLinksBuffer.push(nodeLink);
		return newNode;
	}

	protected static function pasteGroup(group:DiagramGroup):IGroup
	{
		var contentGroup:Array = [];
		for(var i:int=0; i<group.sprites.length; ++i)
		{
			if(group.sprites[i].isGroup)
				contentGroup.push(pasteGroup(group.sprites[i]));
			else
				contentGroup.push(pasteNode(group.sprites[i]));
		}
		var newGroup:IGroup = _diagrammerModel.diagrammer.groupElements(new Object(), contentGroup);
		copyGroupStyle(group as IGroup, newGroup);
		_clipboardMap[group.itemID] = newGroup;
		for each(var groupLink:DiagramLink in group.outLinks)
		_clipboardLinksBuffer.push(groupLink);
		return newGroup;
	}

	protected static function copyNodeStyle(nodeSource:ISprite, nodeTarget:ISprite):void
	{
		var source:DefaultItemRenderer = DefaultItemRenderer(nodeSource.itemRenderer)
		var target:DefaultItemRenderer = DefaultItemRenderer(nodeTarget.itemRenderer);

		var copyProperties:Array = [
			"backgroundAlphas",
			"backgroundColors",
			"borderAlpha",
			"borderColor",
			"borderThickness",
			"fieldsTextSize",
			"fieldsTextColor",
			"fieldsTextFormat",
			"fieldsTextFormat",
			"horizontalPadding",
			"horizontalSpacing",
			"verticalPadding",
			"verticalSpacing"
		];

		for(var i:int=0; i<copyProperties.length; ++i)
		{
			var prop:String = copyProperties[i];
			target[prop] = source[prop];
		}

		DiagramSprite(target.item).width = DiagramSprite(source.item).width;
		DiagramSprite(target.item).height = DiagramSprite(source.item).height;


		target.updateLayout();
		target.updateTextStyle();
		target.updateGraphics();
	}

	protected static function copyGroupStyle(groupSource:IGroup, groupTarget:IGroup):void
	{
		var source:DefaultGroupRenderer = DefaultGroupRenderer(groupSource.itemRenderer)
		var target:DefaultGroupRenderer = DefaultGroupRenderer(groupTarget.itemRenderer);

		var copyProperties:Array = [
			"backgroundAlphas",
			"backgroundColors",
			"borderAlpha",
			"borderColor",
			"borderThickness"
		];

		for(var i:int=0; i<copyProperties.length; ++i)
		{
			var prop:String = copyProperties[i];
			target[prop] = source[prop];
		}

		DiagramGroup(target.item).width = DiagramGroup(source.item).width;
		DiagramGroup(target.item).height = DiagramGroup(source.item).height;

		target.updateLayout();
		target.updateTextStyle();
		target.updateGraphics();
	}
}
}