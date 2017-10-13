////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.renderer.mindmap
{

import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import fr.kapit.diagrammer.renderers.IEditable;
import fr.kapit.lab.demo.data.MindMapNodeData;
import fr.kapit.lab.demo.ui.skins.MindMapNodeRendererSkin;
import fr.kapit.visualizer.base.IItem;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.renderers.IRenderer;
import fr.kapit.visualizer.renderers.ISelectable;

import mx.core.IDataRenderer;

import spark.components.Button;
import spark.components.TextArea;
import spark.components.TextInput;
import spark.components.supportClasses.SkinnableComponent;
import spark.components.supportClasses.SkinnableTextBase;
import spark.events.TextOperationEvent;

//--------------------------------------
//  Skin states
//--------------------------------------

[SkinState("editing")]
[SkinState("editedAndNormal")]
[SkinState("editedAndSelected")]
[SkinState("editedAndHighlighted")]

public class MindMapNodeRenderer extends SkinnableComponent implements IEditable,ISelectable,IRenderer
{

	[SkinPart(required="true")]
	public var editionText: SkinnableTextBase;

	/* ********
	* IEditable impl
	*************/

	protected var _dataModel:Object;

	public function get dataModel():Object
	{
		return _dataModel;
	}

	public function set dataModel(value:Object):void
	{
		_dataModel = value;
	}

	protected var _isSizeFixed:Boolean = true;

	public function get isSizeFixed():Boolean
	{
		return _isSizeFixed;
	}

	public function set isSizeFixed(value:Boolean):void
	{
		_isSizeFixed = value;
	}

	protected var _limitWidth:Number=0;

	public function get limitWidth():Number
	{
		return _limitWidth;
	}

	public function set limitWidth(value:Number):void
	{
		_limitWidth = value;
	}

	protected var _limitHeight:Number=40;

	public function get limitHeight():Number
	{
		return _limitHeight;
	}

	public function set limitHeight(value:Number):void
	{
		_limitHeight = value;
	}


	protected var _prohibitLinkingFrom:Boolean;

	public function get prohibitLinkingFrom():Boolean
	{
		return _prohibitLinkingFrom;
	}

	public function set prohibitLinkingFrom(value:Boolean):void
	{
		_prohibitLinkingFrom = value;
	}

	protected var _prohibitLinkingTo:Boolean = true;

	public function get prohibitLinkingTo():Boolean
	{
		return _prohibitLinkingTo;
	}

	public function set prohibitLinkingTo(value:Boolean):void
	{
		_prohibitLinkingTo = false;
	}

	/* ********
	* IRenderer impl
	*************/

	[Bindable]
	public var mindMapData:MindMapNodeData;

	protected var _data:Object;

	protected var _dataChanged:Boolean;

	public function get data():Object
	{
		return _data;
	}

	public function set data(value:Object):void
	{
		_data = value;
		mindMapData = _data as MindMapNodeData;
		_dataChanged = true;
		invalidateProperties();
	}

	protected var _isFixed:Boolean;

	public function get isFixed():Boolean
	{
		return _isFixed;
	}

	public function set isFixed(value:Boolean):void
	{
		_isFixed = value;
	}

	protected var _item:IItem;

	public function get item():IItem
	{
		return _item;
	}

	public function set item(value:IItem):void
	{
		_item = value;
	}

	protected var _isEditing:Boolean;

	public function get isEditing():Boolean
	{
		return _isEditing;
	}

	public function set isEditing(value:Boolean):void
	{
		_isEditing = value;
		syncStates();
	}

	/* ********
	* ISelectable impl
	*************/

	protected var _isHighlighted : Boolean;

	public function set isHighlighted(value:Boolean):void
	{
		_isHighlighted = value;
		syncStates();
	}

	protected var _isSelected : Boolean;

	public function set isSelected(value:Boolean):void
	{
		if(_isSelected && !value)
		{
			mindMapData.label = editionText.text;
			_isEditing = false;
		}
		_isSelected = value;
		syncStates();
	}

	/* ********
	* Constructor
	*************/

	public function MindMapNodeRenderer()
	{
		super();
		setStyle("skinClass",MindMapNodeRendererSkin);
		width = 150;
		height = 40;
		addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick)
	}
	
	
	/* ********
	* Overriden methods
	*************/

	override protected function getCurrentSkinState():String
	{
		return super.getCurrentSkinState();
	}

	override protected function partAdded(partName:String, instance:Object):void
	{
		super.partAdded(partName, instance);
		if (instance == editionText)
		{
			editionText.addEventListener(TextOperationEvent.CHANGING, handleTextOperation);
		}
	}

	override protected function partRemoved(partName:String, instance:Object):void
	{
		super.partRemoved(partName, instance);

	}

	/* ********
	* Helper methods
	*************/

	private function syncStates():void
	{
		if (!skin)
		{
			return;
		}
		if (_isEditing && _isSelected)
		{
			skin.currentState = "editing";
			_isFixed = true;
		}
		else
		{
			if (_isSelected)
			{
				skin.currentState = "editedAndSelected";
			}
			else if (_isHighlighted)
			{
				skin.currentState = "editedAndHighlighted";
			}
			else
			{
				skin.currentState = "editedAndNormal";
			}
			_isEditing = _isFixed = false;
		}

	}

	public function handleEnterKey(event:KeyboardEvent):void
	{
		if (!mindMapData)
		{
			return;
		}
		if (event.ctrlKey || event.shiftKey)
		{
			editionText.text = editionText.text + "\n"
		}
		else
		{
			mindMapData.label = editionText.text;
			_isEditing = false;
			syncStates();
		}
		stage.focus = null;

	}

	public function handleActivateEditionMode(event:KeyboardEvent):void
	{
		var text:String = String.fromCharCode(event.charCode)
		_isEditing = true;
		syncStates();
		if (text)
		{
			editionText.text = text;
		}
		callLater(editionText.setFocus);
		mindMapData.label = editionText.text;


	}
	protected function onDoubleClick(event:MouseEvent):void
	{
		_isEditing = true;
		syncStates();
		callLater(editionText.setFocus);
		
	}
	public function handleEscKey():void
	{
		_isEditing = false;
		syncStates();
		stage.focus = null;
	}

	public function handleSpaceBar():void
	{
		_isEditing = true;
		syncStates();
		callLater(editionText.setFocus);
	}



	/* ********
	* Handler methods
	*************/

	protected function handleTextOperation(event:TextOperationEvent):void
	{
		if (!mindMapData)
		{
			return;
		}
		mindMapData.label = editionText.text;
	}

	protected function onFocusIn(event:FocusEvent):void
	{
		event.currentTarget.selectAll();

	}

}
}
