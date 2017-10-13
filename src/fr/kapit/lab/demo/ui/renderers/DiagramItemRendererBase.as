package fr.kapit.lab.demo.ui.renderers
{
	import fr.kapit.diagrammer.renderers.IEditable;
	import fr.kapit.visualizer.base.IItem;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.renderers.IRenderer;
	import fr.kapit.visualizer.renderers.ISelectable;
	import spark.components.supportClasses.ItemRenderer;
	
	public class DiagramItemRendererBase extends ItemRenderer implements IRenderer, ISelectable, IEditable
	{
		//private var _data:Object;
		private var _isSelected:Boolean;
		private var _isHighlighted:Boolean;
		private var _item:IItem;
		private var _isEditable:Boolean = true;
		private var _isMoveable:Boolean = true;
		private var _dataModel:Object = null;
		private var _isFixed:Boolean = false;
		private var _isFixedSize:Boolean = false;
		private var _prohibitLinkingFrom:Boolean;
		private var _prohibitLinkingTo:Boolean;
		private var _limitWidth:Number;		
		private var _limitHeight:Number;
		
		public function DiagramItemRendererBase()
		{
			super();
			isSizeFixed = true;
		}
		
		public function set img(value:Class):void {}
		
		[Bindable]
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
		}
		
		[Bindable]
		public function get isHighlighted():Boolean
		{
			return _isHighlighted;
		}
		
		public function set isHighlighted(value:Boolean):void
		{
			_isHighlighted = value;
		}
		
		[Bindable]
		public function get item():IItem
		{
			return _item;
		}
		
		public function set item(value:IItem):void
		{
			_item = value;
		}
		
		[Bindable]
		public function get isEditable():Boolean
		{
			return _isEditable;
		}
		
		public function set isEditable(value:Boolean):void
		{
			_isEditable = value;
		}
		
		[Bindable]
		public function get isMoveable():Boolean
		{
			return _isMoveable;
		}
		
		public function set isMoveable(value:Boolean):void
		{
			_isMoveable = value;
		}
		
		public function get dataModel():Object
		{
			return _dataModel;
		}
		
		public function set dataModel(value:Object):void
		{
			_dataModel = value;
		}
		
		public function get isFixed():Boolean
		{
			return _isFixed;
		}
		
		public function set isFixed(arg0:Boolean):void
		{
			_isFixed = arg0;
		}
		
		public function get isSizeFixed():Boolean
		{
			return _isFixedSize;
		}
		
		public function set isSizeFixed(value:Boolean):void
		{
			_isFixedSize = value;
		}
		
		public function get prohibitLinkingFrom():Boolean
		{
			return _prohibitLinkingFrom;
		}
		
		public function set prohibitLinkingFrom(value:Boolean):void
		{
			_prohibitLinkingFrom  = value;
		}
		
		public function get prohibitLinkingTo():Boolean
		{
			return _prohibitLinkingTo;
		}
		
		public function set prohibitLinkingTo(value:Boolean):void
		{
			_prohibitLinkingTo = value;
		}
		
		public function get limitWidth():Number
		{
			return _limitWidth;
		}
		
		public function set limitWidth(value:Number):void
		{
			_limitWidth = value;
		}
		
		public function get limitHeight():Number
		{
			return _limitHeight;
		}
		
		public function set limitHeight(value:Number):void
		{
			_limitHeight = value;
		}
		
		public function update():void
		{
			// override this method
		}
		/*
		[Bindable]
		public function get data():Object
		{
		return _data;
		}
		
		public function set data(value:Object):void
		{
		_data = value;
		}
		*/
	}
}