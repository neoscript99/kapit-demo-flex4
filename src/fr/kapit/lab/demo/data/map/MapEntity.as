package fr.kapit.lab.demo.data.map
{
	import mx.utils.UIDUtil;

	public class MapEntity
	{
		protected var _uid:String;
		[Bindable]
		public function get uid():String
		{
			return _uid;
		}
		public function set uid(value:String):void
		{
			_uid = value;
		}
		
		protected var _type:String;
		[Bindable]
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			_type = value;
		}
		
		protected var _label:String;
		[Bindable]
		public function get label():String
		{
			return _label;
		}
		public function set label(value:String):void
		{
			_label = value;
		}
		
		protected var _comment:String;
		[Bindable]
		public function get comment():String
		{
			return _comment;
		}
		public function set comment(value:String):void
		{
			_comment = value;
		}
		
		public function MapEntity()
		{
			uid = UIDUtil.createUID();
		}
	}
}