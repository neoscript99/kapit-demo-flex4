package fr.kapit.lab.demo.ui.renderers
{
	public class BPMRendererData
	{
		[Bindable] public var isGroup:Boolean = false;
		[Bindable] public var type:String;
		[Bindable] public var icon:Object;
		private var _iconref:String;
		
		[Bindable]
		public function get iconref():String
		{
			return _iconref;
		}
		
		public function set iconref(value:String):void
		{
			_iconref = value;
			icon = RenderersMap.getImageFromID(value);
		}
	}
}